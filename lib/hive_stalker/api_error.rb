module HiveStalker
  # Error raised when communication with the Hive2 API fails, e.g. when:
  # - Connection times out
  # - DNS resolution fails
  # - API returns non-successful status code
  # - API returns invalid or incomplete JSON
  class APIError < StandardError
  end
end
