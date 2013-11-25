Pod::Spec.new do |s|
  s.name     = 'PSObjectMapping'
  s.version  = '0.0.1'
  s.license  = 'MIT'
  s.summary  = 'Easy Core Data Mapping'
  s.source   = { :git => 'https://github.com/premosystems/PSObjectMapping.git'}
  s.requires_arc = true

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'

  s.public_header_files = 'PSObjectMapping/*.{h,m}'
  s.source_files = 'PSObjectMapping/*.*'

  s.dependency "MagicalRecord", "~> 2.2"
  s.dependency "AFNetworking", "~> 2.0"
  
  s.prefix_header_contents = "#ifdef __OBJC__\n\#define MR_SHORTHAND\n\#import \"NSManagedObject+PSObjectMapping.h\"\n\#import "CoreData+MagicalRecord.h\"\n#endif"
  
  end