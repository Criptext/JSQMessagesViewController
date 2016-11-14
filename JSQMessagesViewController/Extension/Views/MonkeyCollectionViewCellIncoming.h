//
//  MOKCollectionViewCellIncoming.h
//  Criptext
//
//  Created by Gianni Carlo on 6/29/15.
//  Copyright (c) 2015 Criptext INC. All rights reserved.
//

#import "JSQMessagesCollectionViewCellIncoming.h"

@protocol MonkeyCollectionViewCellIncomingDelegate <NSObject>
-(void)openTextEfimero:(JSQMessagesCollectionViewCellIncoming *)cell;
@end

@interface MonkeyCollectionViewCellIncoming : JSQMessagesCollectionViewCellIncoming
@property (weak, nonatomic) id<MonkeyCollectionViewCellIncomingDelegate>criptextDelegate;
@property (nonatomic, strong) NSTimer *timerEfimero;
@property (weak, nonatomic) IBOutlet UIButton *privateTapButton;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *protectedLabel;

-(void)cellHandlePan:(UIGestureRecognizer *)recognizer;
@end
