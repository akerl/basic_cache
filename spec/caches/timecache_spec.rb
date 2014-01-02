require 'spec_helper'

describe BasicCache::TimeCache do
  let(:cache) do
    cache = BasicCache::TimeCache.new(lifetime: 1)
    cache.cache('a') { 3 }
    cache.cache(:b) { 5 }
    cache.cache { 9 }
    cache
  end
  let(:names) { (0..4).map { |x| :"block (#{x} levels) in <top (required)>" } }

  it 'creates a cache' do
    expect(cache).to be_an_instance_of BasicCache::TimeCache
  end
  it 'has a store' do
    expect(subject.store).to be_an_instance_of BasicCache::Store
  end
  it 'has a set lifetime' do
    expect(cache.lifetime).to eq 1
    expect(BasicCache::TimeCache.new.lifetime).to eq 60
  end
  describe '#size' do
    it 'shows the size of the cache' do
      expect(cache.size).to eql 3
      expect(BasicCache::TimeCache.new.size).to eql 0
    end
    it 'does not include expired items in size' do
      expect(cache.size).to eql 3
      sleep 2
      expect(cache.size).to eql 0
    end
  end
  describe '#cache' do
    it 'caches values without a key' do
      subject.cache { 9 }
      expect(subject.cache { 10 }).to eql 9
      expect(subject.include?).to be_true
    end
    it 'caches values with a key' do
      subject.cache('c') { 1 }
      expect(subject.cache('c') { 2 }).to eql 1
      expect(subject.include? :c). to be_true
    end
    it 'expires values after their lifetime' do
      expect(cache.include? 'a').to be_true
      sleep 2
      expect(cache.include? 'a').to be_false
    end
  end
  describe '#include?' do
    it 'checks for a value in the cache' do
      expect(cache.include? 'a').to be_true
      expect(cache.include? :b).to be_true
      expect(cache.include? 'z').to be_false
      expect(cache.include? names[2]).to be_true
    end
  end
  describe '#[]' do
    it 'returns values from the cache' do
      expect(cache['a']).to eql 3
      expect(cache[:b]).to eql 5
      expect { cache[:c] }.to raise_error KeyError
    end
    it 'will not return an expired key' do
      expect(cache['a']).to eql 3
      sleep 2
      expect { cache['a'] }.to raise_error KeyError
    end
  end
  describe '#clear!' do
    describe 'when given no argument' do
      it 'clears the cache' do
        expect(cache.size).to eql 3
        cache.clear!
        expect(cache.size).to eql 0
      end
    end
    describe 'when given an argument' do
      it 'removes that entry from the cache' do
        expect(cache.size).to eql 3
        expect(cache.clear! 'c').to be_nil
        expect(cache.size).to eql 3
        expect(cache.clear! 'a').to eql 3
        expect(cache.size).to eql 2
        expect(cache.clear! :b).to eql 5
        expect(cache.size).to eql 1
        expect(cache.clear! names[2]).to eql 9
        expect(cache.size).to eql 0
      end
    end
  end
  describe '#prune' do
    it 'prunes invalid cache entries' do
      expect(cache.store.size).to eql 3
      sleep 2
      expect(cache.store.size).to eql 3
      expect(cache.prune).to eql [:a, :b, names[2]]
      expect(cache.store.size).to eql 0
    end
  end
end
