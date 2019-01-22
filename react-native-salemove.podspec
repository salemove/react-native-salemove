require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = "react-native-salemove"
  s.version      = package['version']
  s.summary      = "Salemove iOS component for React Native"
  s.description  = package['description']
  s.author       = { 'Salemove' => 'support@salemove.com' }
  s.homepage     = "https://github.com/salemove/react-native-salemove#readme"
  s.license      = package['license']
  s.platform     = :ios, "10.0"

  s.source       = { :git => 'https://github.com/salemove/react-native-salemove.git', :tag => "v#{s.version}" }
  s.source_files  = "ios/**/*.{h,m,swift}"
  s.resource_bundles = {
    'react-native-salemove' => ['ios/**/*.{storyboard,xib}']
  } 
  s.swift_version = '4.2'
  s.ios.deployment_target = '10.0'

  s.dependency 'React'
  s.dependency 'SalemoveSDK'
  s.dependency 'PodAsset'
end
