# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'EventTest' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for EventTest
  pod 'Alamofire'
  pod 'SnapKit'
  pod 'RxCocoa'
  pod 'RxSwift'
  pod 'SDWebImage'
  pod 'RealmSwift'
  pod 'Texture'
  pod "PromiseKit", "~> 6.8"
  
  target 'EventTestTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'EventTestUITests' do
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'RxSwift'
            target.build_configurations.each do |config|
                if config.name == 'Debug'
                    config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
                end
            end
        end
    end
end

