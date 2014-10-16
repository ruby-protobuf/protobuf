module Protobuf
  class Statsd
    class << self
      # The StatsD Client to send stats to. The client must match the
      # interface provided by lookout-statsd
      # (https://github.com/lookout/statsd).
      attr_accessor :client
    end
  end
end
