require 'bundler'
Bundler.require :test

require "rspec/json_expectations"
require 'arkaan/specs'

service = Arkaan::Utils::MicroService.instance
  .register_as('services')
  .from_location(__FILE__)
  .in_test_mode

Arkaan::Specs.include_shared_examples