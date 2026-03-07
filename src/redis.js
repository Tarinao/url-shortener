const Redis = require('ioredis');

const client = new Redis({
  host: process.env.REDIS_HOST || 'localhost',
  port: 6379,
});

const DEFAULT_TTL = 604800; // 7 days

const redis = {
  async set(code, url, ttlSeconds = DEFAULT_TTL) {
    await client.set(code, url, 'EX', ttlSeconds);
    return true;
  },

  async get(code) {
    return client.get(code);
  },

  async del(code) {
    return client.del(code);
  },
};

module.exports = redis;
