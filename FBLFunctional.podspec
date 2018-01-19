Pod::Spec.new do |s|
  s.name        = 'FBLFunctional'
  s.version     = '1.0'
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

  s.ios.deployment_target  = '9.0'
  s.osx.deployment_target  = '10.10'
  s.tvos.deployment_target = '9.0'

  s.prefix_header_file = false
  s.source_files = "Sources/#{s.name}/**/*.{h,m}"
end
