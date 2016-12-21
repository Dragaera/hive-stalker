module HiveStalker
  class Stalker
    attr_reader :client

    def initialize(**kwargs)
      @client = Client.new(kwargs)
    end

    def get_player_data(player_id)
      PlayerData.new(@client.get_player_data(player_id))
    end
  end
end
