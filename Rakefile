require 'open3'

#
# Constants
#
VERBOSE = true
NOOP = false

MAPPINGS = {
  :bin => { 
    :src => File.join(Dir.pwd, 'bin'),
    :dst => File.expand_path('~/.bin')
  },
  :bash => {
    :src => File.join(Dir.pwd, 'completion/tailor.bash'),
    :dst => File.expand_path('~/.bash_completion.d/tailor')
  },
  :zsh => {
    :src => File.join(Dir.pwd, 'completion/tailor.zsh'),
    :dst => File.expand_path('~/.zsh-completions/_tailor')
  }
}
LOCK_FILE = File.join(Dir.pwd, 'PREFIX.lock')

#
# Extended String
#
class String
  def red;     "\033[31m#{self}\033[0m"; end
  def green;   "\033[32m#{self}\033[0m"; end
  def yellow;  "\033[33m#{self}\033[0m"; end
  def blue;    "\033[34m#{self}\033[0m"; end
  def magenta; "\033[35m#{self}\033[0m"; end
  def cyan;    "\033[36m#{self}\033[0m"; end
  def gray;    "\033[37m#{self}\033[0m"; end
end

#
# Helper functions
#
class Helper

  #
  # output info
  #
  def self.info(message)
    STDERR.puts "[INFO] #{message}".cyan if VERBOSE
  end

  #
  # output warn
  #
  def self.warn(message)
    STDERR.puts "[WARN] #{message}".yellow if VERBOSE
  end

  #
  # list files in directory
  #
  def self.lsdir(dir)
    return Dir.entries(dir) - ['.', '..']
  end

  #
  # make directory recursively
  #
  def self.mkdir_p(dir)
    return self.exec("mkdir -p #{dir}")
  end

  #
  # create symlink forcely
  #
  def self.ln_sf(src, dst)
    return self.exec("ln -sf #{src} #{dst}")
  end

  #
  # copy file
  #
  def self.cp(src, dst)
    return self.exec("cp #{src} #{dst}")
  end

  #
  # remove file
  #
  def self.rm(file)
    return self.exec("rm #{file}")
  end

  #
  # remove file recursively
  #
  def self.rm_r(file)
    return self.exec("rm -r #{file}")
  end

  #
  # create symlink recursively
  #
  def self.symlink_r(src: nil, dst: nil)

    if !File.exists?(src)
      self.warn("File NOT FOUND: #{src}")
      return false
    end

    if File.symlink?(dst)
      self.info("File already exists: #{dst}")
      return true
    end

    if !Dir.exists?(dir = File.dirname(dst))
      self.mkdir_p(dir)
    end

    # file
    if File.file?(src) 
      return self.ln_sf(src, dst)
    end

    # directory
    if !File.directory?(dst)
      self.mkdir_p(dst) 
    end

    success = true

    self.lsdir(src).each do |conf|
      success &= self.symlink_r(src: File.join(src, conf), dst: File.join(dst, conf))
    end

    return success
  end

  #
  # copy file recursively
  #
  def self.copy_r(src: nil, dst: nil)

    if !File.exists?(src)
      self.warn("File NOT FOUND: #{src}")
      return false
    end

    if File.exists?(dst)
      self.info("File already exists: #{dst}")
      return true
    end

    if !Dir.exists?(dir = File.dirname(dst))
      self.mkdir_p(dir)
    end

    # file
    if File.file?(src) 
      return self.cp(src, dst)
    end

    # directory
    if !File.directory?(dst)
      self.mkdir_p(dst) 
    end

    success = true

    self.lsdir(src).each do |conf|
      success &= self.cp(File.join(src, conf), File.join(dst, conf))
    end

    return success
  end

  #
  # unlink file
  #
  def self.unlink_r(src: nil, dst: nil)

    if !File.exists?(dst) and !File.symlink?(dst)
      self.info("File already removed: #{dst}")
      return true
    end

    # symlink
    if File.symlink?(dst) and File.exists?(src)
      return self.rm(dst)
    end

    # file
    if File.file?(dst)
      self.info("File is NOT LINK: #{dst}")
      return false
    end

    # directory
    success = true

    self.lsdir(src).each do |file|
      if !File.symlink?(path = File.join(dst, file))
        next
      end

      success &= self.rm(path)
    end

    if self.lsdir(dst).empty?
      success &= self.rm_r(dst)
    end

    return success
  end

  #
  # show status
  #
  def self.status_r(src: nil, dst: nil)

    paths = []

    if File.file?(dst) or File.symlink?(dst)
      # file
      paths.push(dst)
    else
      # directory
      self.lsdir(src).each do |file|
        path = File.join(dst, file)

        if File.exists?(path) or File.symlink?(path)
          paths.push(path)
        end
      end
    end

    return self.exec("ls -ldG #{paths.join(' ')}", verbose: true, noop: false)
  end

  #
  # install bundles
  #
  def self.bundle
    return self.exec('bundle install')
  end

  #
  # exec shell command
  #
  def self.exec(command, options={})
    verbose = !options[:verbose].nil? ? options[:verbose] : VERBOSE
    noop = !options[:noop].nil? ? options[:noop] : NOOP

    if verbose
      STDERR.puts "[EXEC] #{command}".green 
    end

    return true if noop

    Process.waitpid(Process.spawn(command))

    return $?.success?
  end
end

#
# Tasks
#
desc 'install'
task :install do
  if !(prefix = ENV['PREFIX']).nil?
    MAPPINGS[:bin][:dst] = prefix
    File.write(LOCK_FILE, prefix)
  end

  Helper.bundle

  MAPPINGS.each do |id, mapping|
    Helper.symlink_r(mapping)
  end
end

desc 'uninstall'
task :uninstall do
  if File.exists?(LOCK_FILE)
    MAPPINGS[:bin][:dst] = File.read(LOCK_FILE)
  end

  MAPPINGS.each do |id, mapping|
    Helper.unlink_r(mapping)
  end
end

desc 'show status'
task :status do
  if File.exists?(LOCK_FILE)
    MAPPINGS[:bin][:dst] = File.read(LOCK_FILE)
  end

  MAPPINGS.each do |id, mapping|
    Helper.status_r(mapping)
  end
end
