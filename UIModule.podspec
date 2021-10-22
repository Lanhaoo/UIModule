#
# Be sure to run `pod lib lint UIModule.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UIModule'
  s.version          = '0.0.1'
  s.summary          = '项目ui模块'
  s.description      = <<-DESC
项目ui的基础模块
                       DESC
  s.homepage         = 'https://github.com/Lanhaoo/UIModule'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Lanhaoo' => 'lanhao_dev@163.com' }
  s.source           = { :git => 'https://github.com/Lanhaoo/UIModule.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.swift_version    = '5.0'
  s.source_files = 'UIModule/Classes/**/*'
  # s.resource_bundles = {
  #   'UIModule' => ['UIModule/Assets/*.png']
  # }
  s.dependency 'TangramKit'
  s.dependency 'DZNEmptyDataSet'
  s.dependency 'MJRefresh'
  s.dependency 'Kingfisher','~>4.10.1'
  s.dependency 'FWPopupView'
  s.dependency 'AsyncSwift'
end
