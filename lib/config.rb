require 'rubygems'
require 'bundler'
Bundler.require

require 'ostruct'
require 'pp'
require 'pathname'
require 'csv'

ROOT_PATH = Pathname.new File.expand_path('../../', __FILE__)

def ROOT(file)
	ROOT_PATH + file
end

# Ensure existing folders
['tmp'].each do |path|
	FileUtils.mkpath ROOT(path)
end

# Required folders
['lib'].each do |folder|
	$: << ROOT(folder)
end
#pp $:

# Search for shared folder
#path = Pathname.new(File.dirname(__FILE__))
#name = 'shared'
#
#depth = 0
#dir = path + name
#until dir.directory?
#	depth += 1
#	raise "#{name} no found" if depth > 10
#
#	path = path.parent
#	dir = path + name
#end

#pp dir

# Required files
#['misc.rb', 'qt/misc.rb', 'settings.rb'].each do |file_name|
#	require dir + file_name
#end
