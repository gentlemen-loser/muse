require 'eventmachine'
require 'muse_connection'

$world = {}

class MuseServer
  
  attr_accessor :sig
  
  def initialize
    @sig = EventMachine::run {
      EventMachine::start_server("127.0.0.1", 3000, MuseConnection) do |connection|
        connection.server = self
      end
      puts 'running server on 3000'
    }
  end
  
end

MuseServer.new