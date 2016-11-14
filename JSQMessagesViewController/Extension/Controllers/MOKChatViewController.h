//
//  MOKChatViewController.h
//  JSQMessages
//
//  Created by Gianni Carlo on 11/1/16.
//  Copyright © 2016 Hexed Bits. All rights reserved.
//

#import "JSQMessagesViewController.h"

#import "JSQMessagesBubbleImage.h"
#import "JSQMessagesBubbleImageFactory.h"

@protocol MOKMediaDataDelegate <NSObject>

-(void)recordedAudio:(NSData *)data;
-(void)selectedImage:(NSData *)data;

@end

@interface MOKChatViewController : JSQMessagesViewController <UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) id<MOKMediaDataDelegate> mediaDataDelegate;

@property (nonatomic, strong) NSString *headerViewIdentifier;

@property (nonatomic, strong) UIView *descriptionView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *statusLabel;
//@property (nonatomic, strong) UITapGestureRecognizer *descriptionViewTapRecognizer;

@property (nonatomic, strong) UIBarButtonItem *avatarBarButtonItem;
@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UILabel *timerLabel;

@property (strong, nonatomic) UIGestureRecognizer *panGesture;

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

-(NSString *)getDate:(NSTimeInterval)timestamp format:(nullable NSString *)format;
@end
