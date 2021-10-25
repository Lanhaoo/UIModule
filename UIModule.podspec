#
# Be sure to run `pod lib lint UIModule.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UIModule'
  s.version          = '0.0.2'
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
  
  s.subspec 'EZSwiftExtensions' do |ezswiftExtensions|
      ezswiftExtensions.source_files = 'UIModule/Classes/EZSwiftExtensions/*'
      end
#  s.subspec 'Category' do |category|
#        category.source_files = 'XXX/Classes/Category/**/*'
#        category.dependency 'AFNetworking'
#    end
#
#    s.subspec 'Downloader' do |dowmloader|
#        dowmloader.source_files = 'XXX/Classes/Downloader/**/*'
#        dowmloader.dependency 'YYModel'
#    end
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
