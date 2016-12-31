module HiveStalker
  # Module to convert various formats of Steam IDs into an account ID.
  module SteamID
    STEAM_ID_64_OFFSET = 61197960265728

    PATTERN_STEAM_ID = /^STEAM_[0-9]:([0-9]):([0-9]+)$/i
    PATTERN_STEAM_ID_3 = /^U:([0-9]{1,2}):([0-9]+)$/i
    PATTERN_STEAM_ID_64 = /^765([0-9]+)$/
    # Not sure what its valid range is - exists with at least 7 and 8 numbers.
    PATTERN_ACCOUNT_ID = /^[0-9]+$/

    # Convert Steam ID into account ID suitable for API calls.
    # @param s [String] Steam ID, either of:
    #   - Steam ID: STEAM_0:0:24110655
    #   - Steam ID 3: U:1:48221310
    #   - Steam ID 64: 76561198008487038
    #   - Account ID: 48221310
    # @return [Fixnum] Account ID
    # @raise [ArgumentError] If the supplied string could not be converted to
    #   an account ID.
    def self.from_string(s)
      # In case we get a fixnum.
      s = s.to_s

      # https://developer.valvesoftware.com/wiki/SteamID#Format
      PATTERN_STEAM_ID.match(s) do |m|
        return m[1].to_i + m[2].to_i * 2
      end

      PATTERN_STEAM_ID_3.match(s) do |m|
        return m[2].to_i
      end

      PATTERN_STEAM_ID_64.match(s) do |m|
        return m[1].to_i - STEAM_ID_64_OFFSET
      end

      # Matching this one last, as not to catch an ID 64 on accident.
      PATTERN_ACCOUNT_ID.match(s) do |m|
        return s.to_i
      end

      # If we get until here, we did not match any regex.
      raise ArgumentError, "#{ s.inspect } is not a supported SteamID."
    end
  end
end
