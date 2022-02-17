# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'


def common_pods

  # network
  pod 'Alamofire'
  
  # layout
  pod 'SnapKit'
  
  # reactive programing
  pod 'RxCocoa'
  pod 'RxSwift'
  
  # newwork load image
  pod 'SDWebImage'
  
  # database
  pod 'RealmSwift'
  pod 'YYKit'
  
  pod 'Texture'
  pod "PromiseKit", "~> 6.8"
  
  # Animation
  ## animation json render
  pod 'lottie-ios'
  pod 'Hero'
  pod 'pop'
  # pod 'Spring'
  pod 'JXPhotoBrowser','~> 3.1'
  
  # 视频播放
  pod ''
end

target 'EventTest' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
   
  common_pods


  target 'TextEditingDemo' do
    common_pods
  end

  target 'AnimationDemo' do
    common_pods
  end
  
  target 'ImageBrowerDemo' do
    common_pods
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

