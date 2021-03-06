require 'pstore'
require 'md5'
require 'json'

module EDash
  class Project
    class << self
      def store
        Storage.store
      end
      
      def all
        projects = nil
        store.transaction do
          projects = store['projects'] || {}
        end
        projects = projects.values
        projects.sort
      end

      def save(project)
        store.transaction do
          store['projects'] ||= {}
          store['projects'][project.name] = project
        end
      end

      def find(name)
        store.transaction do
          projects = store['projects'] || {}
          projects[name]
        end
      end
    end

    attr_reader :name, :author, :status, :author_email, :author_gravatar
    attr :progress, :writer => true

    def <=>(other)
      self.name <=> other.name
    end

    def initialize(params)
      @name = params['project']
      update_from(params)
    end

    def update_from(params)
      @author = params['author']
      @status = params['status']

      if (@author && @author.size > 0)
        @author_email = @author.match(/<(.*)>/)[1].gsub(' ', '+')
        @author_gravatar = gravatar_uri
      end
    end

    def gravatar_uri
      "http://www.gravatar.com/avatar/#{MD5::md5(@author_email)}?s=50"
    end

    def to_json(*a)
      {
        'json_class' => self.class.name,
        'name' => name,
        'author' => author,
        'status' => status,
        'author_email' => author_email,
        'author_gravatar' => author_gravatar
      }.to_json(*a)
    end
  end
end
