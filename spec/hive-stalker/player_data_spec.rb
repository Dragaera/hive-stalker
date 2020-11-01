module HiveStalker
  RSpec.describe PlayerData do
    let(:player_data) do
      PlayerData.new(
        level: 20,

        skill: 1000,
        skill_offset: 240,
        adagrad_sum: 0.9,
        comm_skill: 400,
        comm_skill_offset: 50,
        comm_adagrad_sum: 0.4,
      )
    end

    describe '#initialize' do
      it 'sets the various attributes' do
        data = PlayerData.new({
          :player_id=>455990,
          :steam_id=>48221310,
          :alias=>"|LZ| Morrolan",
          :score=>4371,
          :level=>12,
          :experience=>95938,
          :badges=>[],
          :skill=>693,
          :skill_offset=>42,
          :comm_skill=>250,
          :comm_skill_offset=>67,
          :time_total=>33790,
          :time_marine=>24110,
          :time_alien=>9680,
          :time_commander=>239,
          :reinforced_tier=>nil,
          :adagrad_sum=>0.0093,
          :comm_adagrad_sum=>0.0193,
          :latitude=>1,
          :longitude=>2,
          :continent=>'EU',
        })

        expect(data.player_id).to eq 455990
        expect(data.steam_id).to eq 48221310
        expect(data.alias).to eq '|LZ| Morrolan'
        expect(data.score).to eq 4371
        expect(data.level).to eq 12
        expect(data.experience).to eq 95938
        expect(data.badges).to eq []
        expect(data.skill).to eq 693
        expect(data.skill_offset).to eq 42
        expect(data.commander_skill).to eq 250
        expect(data.commander_skill_offset).to eq 67
        expect(data.time_total).to eq 33790
        expect(data.time_marine).to eq 24110
        expect(data.time_alien).to eq 9680
        expect(data.time_commander).to eq 239
        expect(data.reinforced_tier).to be_nil
        expect(data.adagrad_sum).to be_within(0.01).of(0.0093)
        expect(data.commander_adagrad_sum).to be_within(0.01).of(0.0193)
        expect(data.latitude).to eq 1
        expect(data.longitude).to eq 2
        expect(data.continent).to eq 'EU'
      end
    end

    describe '#specific_skills' do
      it "returns the player's per-team and per-position skills" do
        skill = player_data.specific_skills

        expect(skill.marine.field).to eq 1240
        expect(skill.marine.commander).to eq 450

        expect(skill.alien.field).to eq 760
        expect(skill.alien.commander).to eq 350
      end

      it "never returns negative skills" do
        skill = PlayerData.new(
          level: 20,

          skill: 200,
          skill_offset: 240,
          adagrad_sum: 0.9,
          comm_skill: 400,
          comm_skill_offset: 450,
          comm_adagrad_sum: 0.4,
        ).specific_skills

        expect(skill.alien.field).to eq 0
        expect(skill.alien.commander).to eq 0
      end

      it "returns lower bounds for each specific skill" do
        skill = player_data.specific_skills

        expect(skill.marine.field_estimate).to be_within(0.01).of(1213.64)
        expect(skill.marine.commander_estimate).to be_within(0.01).of(410.47)

        expect(skill.alien.field_estimate).to be_within(0.01).of(733.64)
        expect(skill.alien.commander_estimate).to be_within(0.01).of(310.47)
      end

      it "never returns negative values for the lower bounds" do
        skill = PlayerData.new(
          level: 20,

          skill: 1000,
          skill_offset: 240,
          adagrad_sum: 0.001,
          comm_skill: 400,
          comm_skill_offset: 50,
          comm_adagrad_sum: 0.002,
        ).specific_skills

        expect(skill.alien.field_estimate).to be_within(0.01).of(0)
        expect(skill.alien.commander_estimate).to be_within(0.01).of(0)
      end
    end

    describe '#skill_tier' do
      it "returns the player's assigned skill tier" do
        tiers = player_data.specific_skill_tiers

        expect(tiers.marine.field.name).to eq 'Squad Leader'
        expect(tiers.marine.field.rank).to eq 3

        expect(tiers.marine.commander.name).to eq 'Frontiersman'
        expect(tiers.marine.commander.rank).to eq 2

        expect(tiers.alien.field.name).to eq 'Frontiersman'
        expect(tiers.alien.field.rank).to eq 2

        expect(tiers.alien.commander.name).to eq 'Frontiersman'
        expect(tiers.alien.commander.rank).to eq 2
      end

      it "returns the rookie tier if the player's level is below 20" do
        tiers = PlayerData.new(
          level: 10,

          skill: 1000,
          skill_offset: 240,
          adagrad_sum: 0.9,
          comm_skill: 400,
          comm_skill_offset: 50,
          comm_adagrad_sum: 0.4,
        ).specific_skill_tiers

        expect(tiers.marine.field.name).to eq 'Rookie'
        expect(tiers.marine.field.rank).to eq 0
      end
    end
  end
end
