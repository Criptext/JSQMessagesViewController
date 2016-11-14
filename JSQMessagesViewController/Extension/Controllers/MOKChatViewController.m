//
//  MOKChatViewController.m
//  JSQMessages
//
//  Created by Gianni Carlo on 11/1/16.
//  Copyright © 2016 Hexed Bits. All rights reserved.
//

#import "MOKChatViewController.h"

#import "UIImage+JSQMessages.h"
#import "UIColor+JSQMessages.h"

#import "MonkeyCollectionViewCellIncoming.h"
#import "MonkeyCollectionViewCellOutgoing.h"

#import "MonkeyActivityIndicatorHeaderView.h"

@interface MOKChatViewController ()
@property (strong, nonatomic) NSDateFormatter *curentTimezoneFormatter;
@end

@implementation MOKChatViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.curentTimezoneFormatter = [[NSDateFormatter alloc] init];
  [self.curentTimezoneFormatter setDateFormat:@"h:mm aa"];
  
  /******************** Setting up Cells **************************/
  self.outgoingCellIdentifier = [MonkeyCollectionViewCellOutgoing cellReuseIdentifier];
  self.outgoingMediaCellIdentifier = [MonkeyCollectionViewCellOutgoing mediaCellReuseIdentifier];
  
  [self.collectionView registerNib:[MonkeyCollectionViewCellOutgoing nib] forCellWithReuseIdentifier:self.outgoingCellIdentifier];
  [self.collectionView registerNib:[MonkeyCollectionViewCellOutgoing nib] forCellWithReuseIdentifier:self.outgoingMediaCellIdentifier];
  
  self.incomingCellIdentifier = [MonkeyCollectionViewCellIncoming cellReuseIdentifier];
  self.incomingMediaCellIdentifier = [MonkeyCollectionViewCellIncoming mediaCellReuseIdentifier];
  
  [self.collectionView registerNib:[MonkeyCollectionViewCellIncoming nib] forCellWithReuseIdentifier:self.incomingCellIdentifier];
  [self.collectionView registerNib:[MonkeyCollectionViewCellIncoming nib] forCellWithReuseIdentifier:self.incomingMediaCellIdentifier];
  
  /***************** Bubble image data **********************/
  JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] initWithBubbleImage:[UIImage jsq_bubbleCompactTaillessImage] capInsets:UIEdgeInsetsZero];
  self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleBlueColor]];
  self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
  
  /******************** Timestamp Pan Gesture Recognizer **************************/
  self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
  self.panGesture.delegate = self;
  
  [self.collectionView addGestureRecognizer:self.panGesture];
  
  /***************** Header Collection View **********************/
  self.headerViewIdentifier = [MonkeyActivityIndicatorHeaderView headerReuseIdentifier];
  [self.collectionView registerNib:[MonkeyActivityIndicatorHeaderView nib]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:[MonkeyActivityIndicatorHeaderView headerReuseIdentifier]];
  
  /***************** Audio setup **********************/
  self.timerLabel = [UILabel new];
  self.timerLabel.text = @"00:00";
  self.timerLabel.hidden = true;
  
  [self.inputToolbar.contentView addSubview:self.timerLabel];
  self.timerLabel.frame = CGRectMake(30, 0, self.inputToolbar.contentView.frame.size.width, self.inputToolbar.contentView.frame.size.height);
  [self.inputToolbar.contentView bringSubviewToFront:self.timerLabel];
  
  
  ////
  //self.inputToolbar.contentView.textView.pasteDelegate = self;
  
  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeMake(12, 9.5);
  
  self.showLoadEarlierMessagesHeader = true;
  
}

#pragma mark - Utils
-(NSString *)getDate:(NSTimeInterval)timestamp format:(NSString *)format{
  if (format != nil) {
    [self.curentTimezoneFormatter setDateFormat:format];
  }
  
  return [self.curentTimezoneFormatter stringFromDate:[[NSDate alloc] initWithTimeIntervalSince1970:timestamp]];
}

#pragma mark - UIGestures recognizers
-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
  
  CGPoint translation;
  
  if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
    translation = [gestureRecognizer velocityInView:[self.collectionView superview]];
    
    // Check for horizontal gesture
    if (fabsf(translation.x)>fabsf(translation.y))
      return YES;
  }
  
  return NO;
}

-(void)handlePan:(UIPanGestureRecognizer *)recognizer {
  for (MonkeyCollectionViewCellIncoming *cell in [self.collectionView visibleCells]) {
    [cell cellHandlePan:recognizer];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
