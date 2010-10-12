Gem::Specification.new do |s|
  s.name = %q{upstart}
  s.version = "0.0.4"
  s.authors = ["Gert Thiel"]
  s.date = %q{2010-10-12}
  s.description = s.summary = %q{Capistrano Recipies for Upstart}
  s.email = %q{GertThiel@gmx.net}
  s.homepage = %q{http://github.com/GertThiel/upstart}
  #s.rubyforge_project = %q{upstart}

  s.files = [
    "lib/up_start.rb",
    "MIT-LICENSE",
    "README.md"
  ]
  s.require_paths = ["lib"]

  s.add_dependency(%q<capistrano>)

  s.has_rdoc = false
  s.extra_rdoc_files = ["MIT-LICENSE", "README.md"]

  s.rubygems_version = %q{1.1.0}
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
end
