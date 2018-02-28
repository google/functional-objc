Pod::Spec.new do |s|
  s.name        = 'FunctionalObjC'
  s.version     = '1.0.2'
  s.authors     = 'Google Inc.'
  s.license     = { :type => 'Apache', :file => 'LICENSE' }
  s.homepage    = 'https://github.com/google/functional-objc'
  s.source      = { :git => 'https://github.com/google/functional-objc.git', :tag => s.version }
  s.summary     = 'Functional operators for Objective-C'
  s.description = <<-DESC

  An Objective-C library of functional operators, derived from Swift.Sequence,
  that help you write more concise and readable code for collection
  transformations. Foundation collections supported include: NSArray,
  NSDictionary, NSOrderedSet, and NSSet.
                  DESC

  s.ios.deployment_target  = '8.0'
  s.osx.deployment_target  = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.module_name = 'FBLFunctional'
  s.prefix_header_file = false
  s.source_files = "Sources/#{s.module_name}/**/*.{h,m}"

  s.test_spec "Tests" do |ts|
    ts.source_files = "Tests/#{s.module_name}Tests/*.{h,m}"
  end
end
