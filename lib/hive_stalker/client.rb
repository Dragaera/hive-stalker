# coding: utf-8

require 'json'
require 'typhoeus'

module HiveStalker
  # Low-level binding to the Hive2 HTTP API.
  # @example Basic usage
  #   require 'hive_stalker'
  #   client = HiveStalker::Client.new
  #   begin
  #     data = client.get_player_data(48221310)
  #     puts "Playtime: #{ data[:time_total] }s"
  #   rescue APIError => e
  #     puts "Error when querying player data:"
  #     puts e.message
  #     if e.cause
  #       puts "Caused by:"
  #       puts e.cause.message
  #     end
  #   end
  class Client
    # Default API endpoint of Hive2 API, which will be used unless overwritten.
    # `%{{action}}` is a placeholder for the to-be-performed action.
    HIVE_ENDPOINT = 'http://hive2.ns2cdt.com/api/%{action}'
    # Path of 'get player data' action. `%{{player_id}}` is a placeholder for
    # the to-be-queried player's account ID.
    GET_PLAYER_DATA = 'get/playerData/%{player_id}'

    # API endpoint of Hive2 API.
    # @return [String]
    attr_reader :endpoint

    # Initialize a new instance of the class.
    #
    # @param endpoint [String] API endpoint of Hive2 API. Defaults to
    #   {Client::HIVE_ENDPOINT}.
    #   Must contain `%{{action}}` as placeholder for the action.
    def initialize(endpoint: HIVE_ENDPOINT)
      @endpoint = endpoint
    end

    # Retrieve statistics of a given player.
    #
    # @param player_id [Fixnum] Account ID for which to query data.
    # @return [Hash<Symbol, Object>] Hash with player statistics.
    # @raise [APIError] In case of errors communicating with the API.
    def get_player_data(player_id)
      raw_data = call_api(GET_PLAYER_DATA, player_id: player_id)

      begin
        {
          player_id: raw_data.fetch('pid'),
          steam_id: raw_data.fetch('steamid'),
          alias: raw_data.fetch('alias'),
          score: raw_data.fetch('score'),
          level: raw_data.fetch('level'),
          experience: raw_data.fetch('xp'),
          badges: raw_data.fetch('badges') || [],
          # With legacy users (who have not played since introduction of
          # Hive2), skill can be a float value.  Likely due to the
          # normalization of skills, which happened shortly after Hive2 went
          # live.
          skill: raw_data.fetch('skill').to_i,
          skill_offset: raw_data.fetch('skill_offset').to_i,
          comm_skill: raw_data.fetch('comm_skill').to_i,
          comm_skill_offset: raw_data.fetch('comm_skill_offset').to_i,
          time_total: raw_data.fetch('time_played'),
          time_marine: raw_data.fetch('marine_playtime'),
          time_alien: raw_data.fetch('alien_playtime'),
          time_commander: raw_data.fetch('commander_time'),
          reinforced_tier: raw_data.fetch('reinforced_tier'),
          # For accounts with no Hive2 rounds on record, the adagrad sum will be null.
          adagrad_sum: raw_data.fetch('adagrad_sum') || 0,
          # For people without a single comm round on record since Hive3, the comm adagrad sum might be null.
          comm_adagrad_sum: raw_data.fetch('comm_adagrad_sum') || 0,
          latitude: raw_data.fetch('lat', 0).to_f,
          longitude: raw_data.fetch('long', 0).to_f,
          continent: raw_data.fetch('cont', ''),
        }
      rescue KeyError => e
        raise APIError, "Incomplete JSON received from API: #{ e.message }"
      end
    end

    private
    def call_api(action, **kwargs)
      url = HIVE_ENDPOINT % { action: action }
      url = url % kwargs

      response = Typhoeus.get(url)
      if response.success?
        begin
          JSON.parse(response.body)
        rescue JSON::ParserError
          raise APIError, "Invalid JSON received from API."
        end
      elsif response.code == 0
        raise APIError, "Error while connecting to API: #{ response.return_message }"
      else
        raise APIError, "Non-success status code recieved from API: #{ response.code }"
      end
    end

  end
end
