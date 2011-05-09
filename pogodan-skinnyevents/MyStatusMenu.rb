class MyStatusMenu < NSMenu
  attr_accessor :status_bar_item
  attr_accessor :loc_menu_item
  attr_accessor :current_location
  attr_accessor :events
  attr_accessor :menu_events
  
  def awakeFromNib
    self.status_bar_item = NSStatusBar.systemStatusBar.statusItemWithLength(NSVariableStatusItemLength)
    
    dir_path = NSBundle.mainBundle.resourcePath.fileSystemRepresentation
    puts "hello zzz?: " + File.join(dir_path, 'events_20mar-21apr.csv')
    
    image = NSImage.imageNamed 'menubar-icon'
    self.status_bar_item.setImage image
    
    self.events = Event.import(File.join(dir_path, 'events_20mar-21apr.csv'), self)
    
    self.loc_menu_item = NSMenuItem.new.tap do |mi|
      mi.title = "location goes here"
      mi.target = self
      mi.action = 'reset_location:'
      self.addItem mi
      mi
    end
    
    self.menu_events = []
    
    # start looking for a CL
    @loc = CLLocationManager.alloc.init
    @loc.delegate = self
    @loc.startUpdatingLocation
    
    self.status_bar_item.setMenu self
  end
  
  def reset_location(sender)
    # hack to reset location into Edinborough
    new_location = CLLocation.alloc.initWithLatitude(55.97575000, longitude:-3.16604200)
    set_location(new_location)
  end
  
  def closest_events
    events.select{|e| e.tags =~ /Music/ }.uniq_by(&:name).sort_by(&:distance_from_location)
  end
  
  def populate_menu_with_nearby_events
    #puts "events: " + events.inspect
    
    puts 'removing old?'
    self.menu_events.each do |me|
      self.removeItem me
    end
    
    puts 'adding new?'
    self.menu_events = closest_events[1 .. 20].map do |event|
      mi = NSMenuItem.new
      mi.title = "#{event.name}: #{(event.distance_from_location / 1000.0).round(2)} km"
      mi.target = self
      self.addItem mi
      
      mi
    end
  end
  
  # run update when we get a CL callback
  def locationManager(manager, didUpdateToLocation: new_location, fromLocation: old_location)
    puts "got new location from CoreLocation"
    set_location(new_location)
  end
  
  def set_location(new_location)
    self.current_location = new_location
    self.loc_menu_item.title = "location: #{current_location.description}"
    self.populate_menu_with_nearby_events
  end
end