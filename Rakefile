require 'yard'
require 'rspec/core/rake_task'

# Clean working directory
desc 'Remove generated files'
task (:clean) {system 'rm -rf .yardoc doc formatted-date-*.gem'}

# Gem build
desc 'Build the gem'
task (:build) {system 'gem build formatted-date.gemspec'}

# Push the gem to the rubygems server
desc 'Push the gem'
task :push => :build do
	require "#{File.dirname(__FILE__)}/lib/formatted-date/version"
	system "gem push formatted-date-#{FormattedDate::VERSION}.gem"
end

# Generate YARD documentation
YARD::Rake::YardocTask.new

# Test gem
RSpec::Core::RakeTask.new do |t|
	t.rspec_opts = %w(--color --format documentation)
end

# By default, test, generate documentation, and build
task :default => [:spec, :yard, :build]
