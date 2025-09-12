platform :ios, '15.0'

target 'Wonders' do
  use_frameworks!

  # Firebase pods
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'leveldb-library'
  pod 'RecaptchaInterop'
  pod 'nanopb'
  pod 'GoogleSignIn'

  target 'WondersTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'WondersUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      config.build_settings['CLANG_CXX_LIBRARY'] = 'libc++'
      config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      config.build_settings['CODE_SIGNING_REQUIRED'] = 'NO'
      config.build_settings['CODE_SIGN_IDENTITY'] = ''
    end
  end
  installer.aggregate_targets.each do |aggregate_target|
    aggregate_target.user_project.targets.each do |user_target|
      user_target.build_configurations.each do |config|
        config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
        config.build_settings['CODE_SIGNING_REQUIRED'] = 'NO'
        config.build_settings['CODE_SIGN_IDENTITY'] = ''
      end
    end
  end
end
