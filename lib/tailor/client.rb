require 'colorize'

module Tailor

  #
  # Client
  #
  class Client

    SSH_CONFIG = File.expand_path('~/.ssh/config')

    #
    # Initailize client
    #
    # @param path   [String]
    # @param server [OpenStruct]
    # @param queue  [Queue]
    # @constructor
    #
    def initialize(path: nil, server: nil, queue: nil)
      @path = path
      @server = server
      @queue = queue
    end

    #
    # Start to tail log
    #
    def start
      conf = RecursiveOpenStruct.new(Net::SSH::Config.load(SSH_CONFIG, @server.host))
      chost = @server.host.colorize((@server.color || 'default').to_sym)

      Net::SSH.start(conf.host, conf.user, keys: conf.identityfile) do |ssh|
        ssh.open_channel do |channel|
          channel.on_data do |ch, data|
            data.lines.each do |line|
              @queue.push("[#{chost}] #{line}")
            end
          end

          channel.exec("tail -f #{@path}")
        end
      end
    end
  end
end
