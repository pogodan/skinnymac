# loading frameworks
framework 'Cocoa'
framework 'CoreLocation'

require 'open-uri'
require 'csv'
require 'json'

# monkey-patching
module Enumerable    
  def uniq_by
    h = {}; inject([]) {|a,x| h[yield(x)] ||= a << x}
  end
end

# Loading all the Ruby project files.
main = File.basename(__FILE__, File.extname(__FILE__))
dir_path = NSBundle.mainBundle.resourcePath.fileSystemRepresentation
Dir.glob(File.join(dir_path, '*.{rb,rbo}')).map { |x| File.basename(x, File.extname(x)) }.uniq.each do |path|
  if path != main
    require(path)
  end
end

# Starting the Cocoa main loop.
NSApplicationMain(0, nil)
