module HiveStalker
  # High-level binding to the Hive2 HTTP API.
  # @example Basic usage
  #   require 'hive_stalker'
  #   stalker = HiveStalker::Stalker.new
  #   begin
  #     data = stalker.get_player_data('STEAM_0:0:24110655')
  #     puts "--- #{ data.alias } ---"
  #     puts "Playtime: #{ data.time_total }s"
  #     puts "Skill: #{ data.skill }"
  #   rescue APIError => e
  #     puts "Could not retrieve player statistics."
  #     puts e.message
  #   end
  class Stalker
    # API client which is used.
    # @return [Client]
    attr_reader :client

    # Initialize a new instance of the class.
    #
    # @param kwargs [Hash] Configuration settings which are passed through to
    #   the underlying client. See {Client#initialize} for details.
    def initialize(**kwargs)
      @client = Client.new(kwargs)
    end

    # Retrieve statistics of a given player.
    #
    # @param steam_id [String, Fixnum] Any supported Steam or account ID.
    #   Supported are:
    #     - Steam ID: STEAM_0:0:24110655
    #     - Steam ID 3: U:1:48221310
    #     - Steam ID 64: 76561198008487038
    #     - Account ID: 48221310
    # @return [PlayerData] Object containing player statistics.
    # @raise [APIError] In case of errors communicating with the API.
    def get_player_data(steam_id)
      account_id = SteamID.from_string(steam_id)
      PlayerData.new(@client.get_player_data(account_id))
    end
  end
end
