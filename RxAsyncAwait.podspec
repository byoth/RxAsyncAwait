Pod::Spec.new do |s|
  s.name             = 'RxAsyncAwait'
  s.version          = '0.1.1'
  s.summary          = 'RxSwift extensions for using asynchronous functions on streams.'
  s.homepage         = 'https://github.com/byoth/RxAsyncAwait'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'byoth' => 'taehyunjo97@gmail.com' }
  s.source           = { :git => 'https://github.com/byoth/RxAsyncAwait.git', :tag => s.version.to_s }
  s.swift_version = "5.0"
  s.ios.deployment_target = '13.0'
  s.source_files = 'Sources/**/*'
  s.frameworks = 'Foundation'
  s.dependency 'RxSwift', '~> 6.0'
end
