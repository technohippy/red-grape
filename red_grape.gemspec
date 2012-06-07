# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "red_grape/version"

Gem::Specification.new do |s|
  s.name        = "red_grape"
  s.version     = RedGrape::VERSION
  s.authors     = ["ANDO Yasushi"]
  s.email       = ["andyjpn@gmail.com"]
  s.homepage    = "https://github.com/technohippy/red-grape"
  s.summary     = %q{RedGrape - Extremely Simple GraphDB}
  s.description = %q{RedGrape is an in-memory graph database written in ruby. I made this in order to learn how graph databases work so that please do not use this for any serious purpose.}

  s.rubyforge_project = "red_grape"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_runtime_dependency "nokogiri"
end
