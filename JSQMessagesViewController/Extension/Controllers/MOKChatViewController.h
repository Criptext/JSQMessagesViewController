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

@interface MOKChatViewController : JSQMessagesViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSString *headerViewIdentifier;

@property (nonatomic, strong) UILabel *timerLabel;

@property (strong, nonatomic) UIGestureRecognizer *panGesture;

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

-(NSString *)getDate:(NSTimeInterval)timestamp format:(nullable NSString *)format;
@end
