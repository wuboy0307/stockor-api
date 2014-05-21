require 'bundler/setup'
require "bundler/gem_tasks"
require 'rake/testtask'
require 'guard'
require 'skr/api'

Rake::TestTask.new do |t|
    t.libs << 'test'
    t.pattern = "test/*_test.rb"
end


desc "API Routes"
task :routes do
    Skr::API::Root.routes.each do |api|
        method = api.route_method.ljust(10)
        path = api.route_path
        puts "     #{method} #{path}"
    end
end
