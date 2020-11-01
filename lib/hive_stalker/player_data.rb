module HiveStalker
  SpecificSkill = Struct.new(:alien, :marine)
  TeamSkill = Struct.new(:field, :field_estimate, :commander, :commander_estimate)

  SkillTier = Struct.new(:name, :rank)
  SpecificSkillTier = Struct.new(:alien, :marine)
  TeamSkillTier = Struct.new(:field, :commander)

  # Container for various player statistics. Essentially a glorified struct.
  class PlayerData
    # Player ID, probably NS2/Hive2-internal.
    # @return [Fixnum]
    attr_reader :player_id

    # Steam account ID.
    # @return [Fixnum]
    attr_reader :steam_id

    # User alias (in-game name)
    # @return [String]
    attr_reader :alias

    # Score - not sure where it's used or shown.
    # @return [Fixnum]
    attr_reader :score

    # Level
    # @return [Fixnum]
    attr_reader :level

    # Experience points
    # @return [Fixnum]
    attr_reader :experience

    # Array of badges. Always empty so far.
    # @return [Array]
    attr_reader :badges

    # Field skill / ELO base value
    # @return [Fixnum]
    attr_reader :skill

    # Field skill / ELO offset
    # @return [Fixnum]
    attr_reader :skill_offset

    # Comm skill / ELO base value
    # @return [Fixnum]
    attr_reader :commander_skill

    # Comm skill / ELO offset
    # @return [Fixnum]
    attr_reader :commander_skill_offset

    # Total time played in seconds.
    #
    # This equals {#time_marine} + {#time_alien}
    # @return [Fixnum]
    attr_reader :time_total

    # Time played as marines in seconds.
    # @return [Fixnum]
    attr_reader :time_marine

    # Time played as aliens in seconds.
    # @return [Fixnum]
    attr_reader :time_alien

    # Time played as commander in seconds.
    # @return [Fixnum]
    attr_reader :time_commander

    # Don't know what this is. Always nil.
    # @return [NilClass]
    attr_reader :reinforced_tier

    # Field AdaGrad sum (https://en.wikipedia.org/wiki/Stochastic_gradient_descent#AdaGrad).
    # @return [Float]
    attr_reader :adagrad_sum

    # Comm AdaGrad sum (https://en.wikipedia.org/wiki/Stochastic_gradient_descent#AdaGrad).
    # @return [Float]
    attr_reader :commander_adagrad_sum

    # Geographical latitude
    # @return [Float]
    attr_reader :latitude

    # Geographical longitude
    # @return [Float]
    attr_reader :longitude

    # Continent
    # @return [String]
    attr_reader :continent

    # Initialize a new instance of the class.
    #
    # @param kwargs [Hash<Symbol, Object>] data with which to initialize the
    #   instance's attributes.
    def initialize(**kwargs)
      @player_id              = kwargs[:player_id]
      @steam_id               = kwargs[:steam_id]
      @alias                  = kwargs[:alias]
      @score                  = kwargs[:score]
      @level                  = kwargs[:level]
      @experience             = kwargs[:experience]
      @badges                 = kwargs[:badges]
      @skill                  = kwargs[:skill]
      @skill_offset           = kwargs[:skill_offset]
      @commander_skill        = kwargs[:comm_skill]
      @commander_skill_offset = kwargs[:comm_skill_offset]
      @time_total             = kwargs[:time_total]
      @time_marine            = kwargs[:time_marine]
      @time_alien             = kwargs[:time_alien]
      @time_commander         = kwargs[:time_commander]
      @reinforced_tier        = kwargs[:reinforced_tier]
      @adagrad_sum            = kwargs[:adagrad_sum]
      @commander_adagrad_sum  = kwargs[:comm_adagrad_sum]
      @latitude               = kwargs[:latitude]
      @longitude              = kwargs[:longitude]
      @continent              = kwargs[:continent]
    end

    # Returns per-team and per-position (field / commander) skills, including
    # lower bounds for each.
    def specific_skills
      return SpecificSkill.new(
        # Alien
        TeamSkill.new(
          # Field
          [skill - skill_offset, 0].max,
          skill_estimate(skill - skill_offset, adagrad_sum),

          # Commander
          [commander_skill - commander_skill_offset, 0].max,
          skill_estimate(commander_skill - commander_skill_offset, commander_adagrad_sum),
        ),

        # Marine
        TeamSkill.new(
          # Field
          skill + skill_offset,
          skill_estimate(skill + skill_offset, adagrad_sum),

          # Commander
          commander_skill + commander_skill_offset,
          skill_estimate(commander_skill + commander_skill_offset, commander_adagrad_sum),
        ),
      )
    end

    def specific_skill_tiers
      skills = specific_skills

      return SpecificSkillTier.new(
        # Alien
        TeamSkillTier.new(
          # Field
          skill_tier(skills.alien.field_estimate, level),
          # Commander
          skill_tier(skills.alien.commander_estimate, level),
        ),

        # Marine
        TeamSkillTier.new(
          # Field
          skill_tier(skills.marine.field_estimate, level),
          # Commander
          skill_tier(skills.marine.commander_estimate, level),
        ),
      )
    end

    private
    # Conservative estimate of a player's skill, using the sum of adagrad
    # gradients. Works somewhat like a lower one-sided bound with indeterminate
    # confidence.
    def skill_estimate(skill_value, adagrad_sum_value)
      # Use adagrad sum to get a lower bound for a player's skill.
      [0, skill_value - 25 / Math.sqrt(adagrad_sum_value)].max
    end

    # Skill tier assignment based on skill estimate and level.
    def skill_tier(skill_estimate, level)
      if level < 20
        SkillTier.new('Rookie', 0)

      elsif skill_estimate < 301
        SkillTier.new('Recruit', 1)

      elsif skill_estimate < 751
        SkillTier.new('Frontiersman', 2)

      elsif skill_estimate < 1401
        SkillTier.new('Squad Leader', 3)

      elsif skill_estimate < 2101
        SkillTier.new('Veteran', 4)

      elsif skill_estimate < 2901
        SkillTier.new('Commandant', 5)

      elsif skill_estimate < 4101
        SkillTier.new('Special Ops', 6)

      else
        SkillTier.new('Sanji Survivor', 7)
      end
    end
  end
end
