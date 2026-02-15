
module ScoreFormats
  ## namespace inside version or something
  module Version
    def self.major
      0   
    end

    def self.minor
      2
    end

    def self.patch
      0
    end

    def self.version_string
      [major,minor,patch].join('.')
    end
  end

  def self.version
    Version.version_string
  end

  def self.banner
    "score-formats/#{version} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    File.expand_path( File.dirname(File.dirname(File.dirname(__FILE__))) )
  end
end   # module ScoreFormats
