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
    @redis
  end

  def _serialize(value)
    Zlib::Deflate.deflate(Marshal.dump(value))
  end

  def _deserialize(value)
    Marshal.load(Zlib::Inflate.inflate(value))
  end

  def set(key, value)
    @redis.set(key, _serialize(value))
  end

  def get(key)
    value = @redis.get(key)
    value = _deserialize(value) if value != nil
    value
  end

  def bulk_get(keys)
    values = @redis.pipelined do
      keys.each do |key|
        @redis.get(key)
      end
    end
    values.map! {|v| _deserialize(v) if v != nil}
    values
  end

  def del(key)
    @redis.del(key)
  end

  def flushdb()
    @redis.flushdb()
  end

  def incr(key)
    @redis.incr(key)
  end

  def getset(key, value)
    @redis.getset(key, value)
  end

  def rpush(key, value)
    @redis.rpush(key, value)
  end

  def lrange(key, offset, limit)
    @redis.lrange(key, offset, limit)
  end

  def zadd(key, score, member)
    @redis.zadd(key, score, member)
  end

  def zrank(key, member)
    @redis.zrank(key, member)
  end

  def zrevrank(key, member)
    @redis.zrevrank(key, member)
  end

  def zscore(key, member)
    @redis.zscore(key, member)
  end

  def zrevrange(key, start, stop, scores: true)
    @redis.zrevrange(key, start, stop, with_scores: scores)
  end
end
