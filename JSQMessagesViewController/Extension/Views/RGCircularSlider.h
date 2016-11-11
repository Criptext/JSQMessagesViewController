//
//  RGCircularSlider.h
//  Block
//
//  Created by ROBERA GELETA on 12/7/14.
//  Copyright (c) 2014 ROBERA GELETA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol RGCircularSliderDelegate <NSObject>
- (void)audioDidBeginPlaying:(id _Nonnull)audioSlider;
- (void)audioDidFinishPlaying:(id _Nonnull)audioSlider;
@optional
- (void)audioDidBeginPause:(id _Nonnull)audioSlider;
- (void)audioIsEmpty;

@end

@interface RGCircularSlider : UIView <AVAudioPlayerDelegate>
@property (strong, nonatomic)NSString *nameAudio;
@property (strong, nonatomic)NSString *soundFilePath;
@property (weak, nonatomic)id<RGCircularSliderDelegate> delegate;
@property (strong, nonatomic)UILabel *timeLabel;
@property BOOL pressed;
- (instancetype)initWithFrame:(CGRect)frame isIncoming:(BOOL)isIncomming;
- (NSString*)timeFormat:(float)value;
- (void)stopAudio;
- (void)pauseAudio;
- (void)didOpenEfimero;
@end
