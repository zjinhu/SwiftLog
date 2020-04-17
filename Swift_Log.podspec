
Pod::Spec.new do |s|
  s.name             = 'Swift_Log'
  s.version          = '0.2.0'
  s.summary          = '路由.'
 
  s.description      = <<-DESC
							工具.
                       DESC

  s.homepage         = 'https://github.com/jackiehu/' 
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'HU' => '814030966@qq.com' }
  s.source           = { :git => 'https://github.com/jackiehu/SwiftLog.git', :tag => s.version.to_s }

  s.ios.deployment_target = "9.0" 
  s.swift_versions     = ['4.0','4.2','5.0','5.1','5.2']
  s.requires_arc = true

  s.frameworks   =  "Foundation" #支持的框架

  s.source_files = 'SwiftLog/SwiftLog/Class/**/*' 
end
