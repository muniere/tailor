require 'erb'
require 'yaml'
require 'net/ssh'
require 'parallel'
require 'recursive-open-struct'

module Tailor

  #
  # Project
  #
  class Project

    @@directory = File.expand_path('~/.tailor')
    @@extname = '.yml'

    attr_reader :path, :servers

    #
    # Load a project file
    #
    # @param name [String] project name to load
    # @return [Project] loaded project
    #
    def self.load(name)
      if !File.exists?(path = self.abs_path(name))
        raise ArgumentError, "File not found: #{path}"
      end

      return self.new(RecursiveOpenStruct.new(YAML.load_file(path), recurse_over_arrays: true))
    end

    #
    # Create a new project
    #
    # @param name [String] project name to create
    #
    def self.create(name)
      if File.exists?(path = self.abs_path(name))
        raise ArgumentError, "File already exists: #{path}"
      end
      if !Dir.exists?(@@directory)
        FileUtils.mkdir_p(@@directory)
      end

      File.write(path, ERB.new(self.template).result(binding))
    end

    #
    # Delete a project
    #
    # @param name [String] project name to delete
    #
    def self.delete(name)
      if !File.exists?(path = self.abs_path(name))
        raise ArgumentError, "File not found: #{path}"
      end

      FileUtils.rm(path)
    end

    #
    # Open a project with editor
    #
    def self.edit(name)
      Kernel.system("#{self.editor} #{self.abs_path(name)}")
    end

    #
    # List projects
    #
    def self.list
      return (Dir.entries(@@directory) - ['.', '..']).map{ |f| File.basename(f, '.*') }
    end

    #
    # Initialize project 
    #
    # @param attrs [RecursiveOpenStruct]
    # @constructor
    #
    def initialize(attrs)
      @path = attrs.path
      @servers = attrs.servers
    end

    #
    # Validate project
    #
    def validate
      if @path.nil? or @path.empty?
        raise ArgumentError, 'Validation failed: Path not configured'
      end
      if @servers.nil? or @servers.empty?
        raise ArgumentError, 'Validation failed: No servers were specified'
      end

      return self
    end

    private

    #
    # Get absolute path of project
    #
    def self.abs_path(name)
      return File.join(@@directory, "#{name}#{@@extname}")
    end

    #
    # Detect editor
    #
    def self.editor
      return ENV['EDITOR'] || 'vi'
    end

    #
    # Read template file
    #
    def self.template
      return File.read(File.expand_path(File.join(__dir__, './template/project.yml.erb')))
    end

  end
end
