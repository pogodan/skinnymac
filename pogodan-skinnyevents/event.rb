class Event
  def self.import(file, menu)
    CSV.read(File.expand_path(file), :encoding => 'UTF-8')[1 .. -1].map do |cve|
      puts "importing: " + cve.inspect
      new(menu, :name => cve[1], :price => cve[3], :address => cve[6], 
            :start_time => cve[4], :end_time => cve[5], 
            :latitude => cve[10], :longitude => cve[11], :tags => cve[12])
    
    
    end
  end
  
  attr_reader :menu
  attr_accessor :name, :address, :price, :start_time, :end_time, :latitude, :longitude, :tags
  def initialize(menu, attrs)
    @menu = menu
    @distance_from_locations = {}
    @name, @address, @price, @start_time, @end_time, @latitude, @longitude, @tags = attrs.values_at(:name, :address, :price, :start_time, :end_time, :latitude, :longitude, :tags)
  end
  
  # DateTime.parse(start_time)
  
  def distance_from_location
    @distance_from_locations[menu.current_location.description] ||= begin
      puts "calculating distance from #{location.description}"
      location.distanceFromLocation(menu.current_location)
      #rand(100)
    end
  end
  
  def location
    @location ||= CLLocation.alloc.initWithLatitude(latitude.to_f, longitude:longitude.to_f)
  end
end