module HiveStalker
  class Stalker
    attr_reader :client

    def initialize(**kwargs)
      @client = Client.new(kwargs)
    end

    def get_player_data(steam_id)
      account_id = SteamID.from_string(steam_id)
      PlayerData.new(@client.get_player_data(account_id))
    end
  end
end
