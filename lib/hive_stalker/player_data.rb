module HiveStalker
  class PlayerData
    attr_reader :player_id
    attr_reader :steam_id
    attr_reader :alias
    attr_reader :score
    attr_reader :level
    attr_reader :experience
    attr_reader :badges_enabled
    attr_reader :badges
    attr_reader :skill
    attr_reader :time_total
    attr_reader :time_marine
    attr_reader :time_alien
    attr_reader :time_commander
    attr_reader :reinforced_tier
    attr_reader :adagrad_sum

    def initialize(**kwargs)
      @player_id       = kwargs[:player_id]
      @steam_id        = kwargs[:steam_id]
      @score           = kwargs[:score]
      @level           = kwargs[:level]
      @experience      = kwargs[:experience]
      @badges_enabled  = kwargs[:badges_enabled]
      @badges          = kwargs[:badges]
      @time_total      = kwargs[:time_total]
      @time_marine     = kwargs[:time_marine]
      @time_alien      = kwargs[:time_alien]
      @time_commander  = kwargs[:time_commander]
      @reinforced_tier = kwargs[:reinforced_tier]
      @adagrad_sum     = kwargs[:adagrad_sum]
    end
  end
end
