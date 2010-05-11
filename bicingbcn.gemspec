Gem::Specification::new do |spec|
  spec.name = "bicingbcn"
  spec.version = "0.1"
  spec.description = "BicingBCN is a simple module to interface Barcelona Bicing services"
  spec.platform = Gem::Platform::RUBY
  spec.summary = "bicingbcn"

  spec.files = ["bicingbcn.gemspec", "lib", "lib/bicingbcn.rb", "README", 
                "test", "test/bicingbcn_test.rb", "test/localizaciones.php"]
  spec.executables = ["bicingbcn"]
  
  spec.require_path = "lib"

  spec.has_rdoc = true
  spec.test_files = "test/bicingbcn_test.rb"
  spec.add_dependency 'hpricot'

  #spec.extensions.push(*[])

  #spec.rubyforge_project = 'bicingbcn'
  spec.author = "Arnau Sanchez"
  spec.email = "tokland@gmail.com"
  spec.homepage = "http://www.arnau-sanchez.com/en"
end
