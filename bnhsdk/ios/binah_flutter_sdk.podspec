Pod::Spec.new do |s|
    s.name             = 'binah_flutter_sdk'
    s.version          = '5.0.3'
    s.summary          = 'A new flutter plugin project.'
    s.description      = <<-DESC
  A new flutter plugin project.
                         DESC
    s.homepage         = 'https://ilstechnik.com'
    s.license          = { :type => 'MIT' } # Solo especifica el tipo de licencia
    s.author           = { 'ilstechnick' => 'app@ilstechnick.com' }
    s.source           = { :path => '.' }
    s.source_files     = 'Classes/**/*'
    s.public_header_files = 'Classes/**/*.h'
    s.dependency 'Flutter'
    s.platform = :ios, '13.0'

    # Flutter.framework does not contain a i386 slice.
    s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
    s.preserve_paths = 'BinahAI.framework'
    s.xcconfig = { 'OTHER_LDFLAGS' => '-framework BinahAI' }
    s.vendored_frameworks = "BinahAI.framework"
end
