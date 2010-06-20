require 'muse_commands'

class MuseConnection < EventMachine::Connection
  include MuseCommands
  
  attr_accessor :server
  
  def post_init
    puts "-- someone connected to the server!"
    respond_with "Welcome to M.U.S.E."
  end

  def unbind
    @clock.cancel unless @clock.nil?
    puts "-- someone disconnected from the server!"
  end
  
  def respond_with(string)
    send_data "#{string}\r\n\r\n"
  end
  
end