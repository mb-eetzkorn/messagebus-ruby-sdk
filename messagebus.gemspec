# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "messagebus-sdk/messagebus_version"

Gem::Specification.new do |s|
  s.name        = "messagebus-sdk"
  s.version     = MessagebusSDK::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Message Bus"]
  s.email       = ["support@messagebus.com"]
  s.homepage    = ""
  s.summary     = %q{Message Bus SDK}
  s.description = %q{SDK for Message Bus platform}

  s.rubyforge_project = "messagebus-sdk"

  s.files         = Dir.glob("{lib,spec}/**/*") + %w(README.md Gemfile Rakefile .rvmrc)
  s.test_files    = Dir.glob("{spec}/**/*")
  s.executables   = []
  s.require_paths = ["lib","lib/messagebus-sdk"]

  s.license = 'APACHE2'

end
