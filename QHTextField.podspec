Pod::Spec.new do |s|
  s.name     = 'QHTextField'
  s.version  = '0.1.1'
  s.license  = 'MIT'
  s.summary  = 'QHTextField'
  s.homepage = 'https://github.com/imqiuhang/QHTextField'
  s.author   = { 'imqiuhang' => 'imqiuhang@hotmail.com' }
  s.source = { git: "https://github.com/imqiuhang/QHTextField.git", tag: s.version.to_s }
  s.source_files = 'QHTextField/**/*.{h,m}'
  s.resource_bundles = {
    'QHTextFieldResources' => ['QHTextField/Resource/**/*.{xcassets,xib}']
  }

  s.requires_arc = true
  s.xcconfig = { 'CLANG_MODULES_AUTOLINK' => 'YES' }
  s.ios.deployment_target = '8.0'

  # dependency
  s.dependency 'PureLayout'
  
end
