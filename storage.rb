module EDash
  module Storage
    def self.init_store(env)
      @store = PStore.new(File.dirname(__FILE__)+'/edash-'+ env +'.pstore')
    end

    def self.store
      @store
    end
  end
end
