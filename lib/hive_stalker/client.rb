require 'json'
require 'typhoeus'

module HiveStalker
  class Client
    HIVE_ENDPOINT = 'http://hive2.ns2cdt.com/api/%{action}'
    GET_PLAYER_DATA = 'get/playerData/%{player_id}'

    attr_reader :endpoint

    def initialize(endpoint: HIVE_ENDPOINT)
      @endpoint = endpoint
    end

    def get_player_data(player_id)
      raw_data = call_api(GET_PLAYER_DATA, player_id: player_id)

      {
        player_id: raw_data.fetch('pid'),
        steam_id: raw_data.fetch('steamid'),
        alias: raw_data.fetch('alias'),
        score: raw_data.fetch('score'),
        level: raw_data.fetch('level'),
        experience: raw_data.fetch('xp'),
        badges_enabled: raw_data.fetch('badges_enabled'),
        badges: raw_data.fetch('badges') || [],
        skill: raw_data.fetch('skill'),
        time_total: raw_data.fetch('time_played'),
        time_marine: raw_data.fetch('marine_playtime'),
        time_alien: raw_data.fetch('alien_playtime'),
        time_commander: raw_data.fetch('commander_time'),
        reinforced_tier: raw_data.fetch('reinforced_tier'),
        adagrad_sum: raw_data.fetch('adagrad_sum')
      }
    end

    private
    def call_api(action, **kwargs)
      url = HIVE_ENDPOINT % { action: action }
      url = url % kwargs

      response = Typhoeus.get(url)
      JSON.parse(response.body)
    end

  end
end
