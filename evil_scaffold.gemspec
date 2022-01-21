lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'evil_scaffold/version'

Gem::Specification.new do |spec|
  spec.name          = "evil_scaffold"
  spec.version       = EvilScaffold::VERSION
  spec.authors       = ["Conan Dalton"]
  spec.email         = ["conan@conandalton.net"]
  spec.summary       = %q{ Generates mostly-unsurprising controller code at app startup so your codebase is not cluttered with boilerplate @foo.find(params[:id]).update_attributes(params[:foo]) style code }
  spec.description   = %q{ Generates rails controller actions at runtime. Does not generate source code for you to inspect, modify and commit to version control, so requires your blind faith, hence evil. Also does not attempt to generate view code. On the other hand, massively reduces your line count.}
  spec.homepage      = "http://github.com/conanite/evil_scaffold"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'rspec', '~> 2.9'
end
