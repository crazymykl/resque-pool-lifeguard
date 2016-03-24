require 'spec_helper'

describe Resque::Pool::Lifeguard do

  before :each do
    Resque.redis.flushall
  end

  let(:host) { Socket.gethostname }
  let(:pool_key) { subject.class.pool_key }

  it 'has a version number' do
    expect(Resque::Pool::Lifeguard::VERSION).not_to be nil
  end

  context "getting and setting" do
    it 'sets all values' do
      subject.values = {'foo' => 1}

      expect(Resque.redis.keys).to eq [pool_key]
      expect(Resque.redis.hgetall pool_key).to eq host => (Resque.encode 'foo' => 1)
    end

    it 'gets all values' do
      Resque.redis.hset pool_key, host, (Resque.encode 'foo' => 1)

      expect(subject.values).to eq 'foo' => 1
    end

    it 'nukes invalid data' do
      Resque.redis.hset pool_key, host, "AWFUL WAFFLE"

      expect(subject.values).to be_nil
      expect(Resque.redis.hget pool_key, host).to be_nil
    end

    it "gets one value" do
      subject.values = {'foo' => 1}

      expect(subject['foo']).to eq 1
    end

    it "sets incrementally" do
      subject.values = {'foo' => 1}

      subject['baz'] = 3

      expect(subject.values).to eq 'foo' => 1, 'baz' => 3
    end

    it "removes assignment when given 0 workers" do
      subject.values = {'foo' => 1}

      subject['foo'] = 0

      expect(subject.values).to be_empty
    end

  end

  context "multiple pools" do
    let(:pool) { subject.class.new hostname: "blah", defaults: -> (env) { {env => 1} } }

    before :each do
      subject['foo'] = 6
      pool['foo'] = 5
    end

    it "sets and gets indepentently" do
      pool['bar'] = 5
      pool['foo'] = 0

      expect(subject.class.all_pools).to eq \
        host => {'foo' => 6},
        'blah' => {'bar' => 5}
    end

    it "resets one" do
      pool.reset!

      expect(subject.class.all_pools).to eq host => {'foo' => 6}
    end

    it "resets all" do
      subject.class.reset!

      expect(subject.class.all_pools).to be_empty
    end

    it "respects defaults when empty" do
      subject.class.reset!

      expect(pool.('cat')).to eq 'cat' => 1
      expect(subject.('cat')).to be_empty
    end

    it "nukes everything if the data's invalid" do
      Resque.redis.hset pool_key, "FGSFDS", "BLAH"

      expect(subject.class.all_pools).to be_empty
    end

  end
end
