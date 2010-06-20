module MuseCommands
  
  USER_CMDS = %w{tick tock create look describe examine quit}
  ADMIN_CMDS = %w{shutdown}
  
  def receive_data data
    args = data.split
    method = args.shift.downcase
    if (USER_CMDS.include? method) || (ADMIN_CMDS.include? method)
      self.send(method, args) 
    else
      respond_with "I don't know how to #{method}" 
    end
  end
  
  def tick(args)
    unless @clock 
      @clock = EventMachine::PeriodicTimer.new(1) { respond_with "...tick..." }
      respond_with "Clock started..."    
    end
  end

  def tock(args)
    if @clock
      @clock.cancel
      @clock = nil
      respond_with "...clock stopped."    
    end
  end

  def create(args)
    thing = args.shift 
    desc = "It doesn't look like much." 
    $world[thing] = desc
    respond_with "Created a #{thing}."    
  end
  
  def look(args)
    if args.empty?
      if $world.keys.empty?
        respond_with "There is nothing here."    
      else
        result = "You see "
        things = $world.keys.join(", a ")
        respond_with "You see a #{things}."    
      end
    else
      thing = args.shift
      unless $world[thing]
        respond_with "There is no #{thing} here."    
      else
        respond_with description thing    
      end
    end
  end

  def examine(args)
    respond_with description args.shift
  end
  
  def description(thing)
    "#{$world[thing]}"
  end
  
  def describe(args)
    $world[args.shift] = args.join(" ")
    respond_with "Ok."    
  end

  def quit(args)
    close_connection_after_writing
  end
  
end