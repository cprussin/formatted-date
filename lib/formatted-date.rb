# This module encloses all library code.
module FormattedDate; end
Dir["#{File.dirname(__FILE__)}/formatted-date/*.rb"].each {|file| require file}
