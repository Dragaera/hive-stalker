module HiveStalker
  module SteamID
    STEAM_ID_64_OFFSET = 61197960265728

    PATTERN_STEAM_ID = /^STEAM_0:([0-9]):([0-9]+)$/
    PATTERN_STEAM_ID_3 = /^U:([0-9]{1,2}):([0-9]+)$/
    PATTERN_STEAM_ID_64 = /^765([0-9]+)$/
    PATTERN_ACCOUNT_ID = /^[0-9]{8}$/

    def self.from_string(s)
      # In case we get a fixnum.
      s = s.to_s

      # https://developer.valvesoftware.com/wiki/SteamID#Format
      PATTERN_ACCOUNT_ID.match(s) do |m|
        return s.to_i
      end

      PATTERN_STEAM_ID.match(s) do |m|
        return m[1].to_i + m[2].to_i * 2
      end

      PATTERN_STEAM_ID_3.match(s) do |m|
        return m[2].to_i
      end

      PATTERN_STEAM_ID_64.match(s) do |m|
        return m[1].to_i - STEAM_ID_64_OFFSET
      end

      # If we get until here, we did not match any regex.
      raise ArgumentError, "#{ s.inspect } is not a supported SteamID."
    end
  end
end
