require "bundler/setup"
require "rails"
require "rails/test_help"
require "active_support/testing/autorun"
require "minitest/mock"
require "byebug"

require "kredis"

Kredis.configurator = Class.new { def config_for(name) {} end }.new

Kredis.logger = Logger.new(STDOUT) if ENV["VERBOSE"]

class ActiveSupport::TestCase
  teardown { Kredis.clear_all }

  class RedisUnavailableProxy
    def multi; yield; end
    def pipelined; yield; end
    def method_missing(*); raise Redis::BaseError; end
  end

  def stub_redis_down(redis_holder, &block)
    (redis_holder.try(:proxy) || redis_holder).stub(:redis, RedisUnavailableProxy.new, &block)
  end
end
