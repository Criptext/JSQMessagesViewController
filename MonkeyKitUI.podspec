Pod::Spec.new do |s|
	s.name = 'MonkeyKitUI'
	s.version = '7.4.0'
	s.summary = 'An elegant messages UI library for iOS.'
	s.homepage = 'https://criptext.com'
	s.license = 'MIT'
	s.platform = :ios, '7.0'

	s.author = 'Criptext, Inc.'
	s.social_media_url = 'https://twitter.com/criptext'

	s.screenshots = ['https://raw.githubusercontent.com/jessesquires/JSQMessagesViewController/develop/Screenshots/screenshot0.png',
                    'https://raw.githubusercontent.com/jessesquires/JSQMessagesViewController/develop/Screenshots/screenshot1.png',
                    'https://raw.githubusercontent.com/jessesquires/JSQMessagesViewController/develop/Screenshots/screenshot2.png',
                    'https://raw.githubusercontent.com/jessesquires/JSQMessagesViewController/develop/Screenshots/screenshot3.png']

	s.source = { :git => 'https://github.com/Criptext/Monkey-UI-iOS.git', :tag => s.version }
	s.source_files = 'JSQMessagesViewController/**/*.{h,m}'

	s.resources = ['JSQMessagesViewController/Assets/JSQMessagesAssets.bundle', 'JSQMessagesViewController/**/*.{xib}']

	s.frameworks = 'QuartzCore', 'CoreGraphics', 'CoreLocation', 'MapKit', 'AVFoundation'
	s.requires_arc = true

	s.dependency 'JSQSystemSoundPlayer', '~> 2.0.1'
end
