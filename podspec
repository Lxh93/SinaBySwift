Pod::Spec.new do |s|
s.name = 'SinaBySwift'
s.version = '0.1'
s.license = 'MIT'
s.summary = 'Sina(use Swift4) on iOS.'
s.homepage = 'https://github.com/Lxh93/SinaBySwift'
s.authors = { '李小华' => '894365394@qq.com' }
s.source = { :git => 'https://github.com/Lxh93/SinaBySwift.git', :tag => s.version.to_s }
s.requires_arc = true
s.ios.deployment_target = '8.0'
s.source_files = 'Appdelegate/*.{h,m}'
s.resources = 'SinaBySwift/images/*.{png,xib}'
end
