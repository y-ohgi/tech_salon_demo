# coding: utf-8

require 'yaml'
require 'redis'
require 'redis-namespace'

class RedisCache
  @config = YAML.load_file("#{Rails.root}/config/redis.yml")[Rails.env]
  @redis_connection = Redis.new(host: @config['hosts'].first,
                                port: @config['port'],
                                db: @config['db']['cache'])

  def initialize(namespace)
    @redis = Redis::Namespace.new(namespace, :redis => @redis_connection)
  end

  def _redis
    return @redis
  end

  def _serialize(value)
    return Zlib::Deflate.deflate(Marshal.dump(value))
  end

  def _deserialize(value)
    return Marshal.load(Zlib::Inflate.inflate(value))
  end

  def set(key, value)
    return @redis.set(key, _serialize(value))
  end

  def get(key)
    value = @redis.get(key)
    value = _deserialize(value) if value != nil
    return value
  end

  def bulk_get(keys)
    values = @redis.pipelined do
      keys.each do |key|
        @redis.get(key)
      end
    end
    values.map! {|v| _deserialize(v) if v != nil}
    return values
  end

  def del(key)
    return @redis.del(key)
  end

  def flushdb()
    return @redis.flushdb()
  end
end
