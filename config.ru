require 'bundler'
Bundler.require(ENV['RACK_ENV'].to_sym || :development)

$stdout.sync = true

Virtuatable::Application.load!('services')

run Controllers::Services