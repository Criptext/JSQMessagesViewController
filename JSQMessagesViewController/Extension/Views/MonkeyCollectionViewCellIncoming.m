//
//  MOKCollectionViewCellIncoming.m
//  Criptext
//
//  Created by Gianni Carlo on 6/29/15.
//  Copyright (c) 2015 Criptext INC. All rights reserved.
//

#import "MonkeyCollectionViewCellIncoming.h"

@interface MonkeyCollectionViewCellIncoming()
@property CGPoint originalCenterHora;

@end
@implementation MonkeyCollectionViewCellIncoming

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.messageBubbleTopLabel.textAlignment = NSTextAlignmentLeft;
    self.cellBottomLabel.textAlignment = NSTextAlignmentLeft;
    self.protectedLabel.text = [@"    " stringByAppendingString:NSLocalizedString(@"privateidKey", @"")];
    [self.privateTapButton setTitle:@"" forState:UIControlStateNormal];
    [self.privateTapButton setTitle:NSLocalizedString(@"messageExpired", @"") forState:UIControlStateDisabled];
}
- (IBAction)didPressPrivateButton:(UIButton *)sender {
    if ([self.criptextDelegate respondsToSelector:@selector(openTextEfimero:)]) {
        [self.criptextDelegate openTextEfimero:self];
    }
}

-(void)cellHandlePan:(UIPanGestureRecognizer *)recognizer{
    
    // 1
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // if the gesture has just started, record the current centre location
        self.originalCenterHora = self.dateLabel.center;
    }
    // 2
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        // translate the center
        CGPoint translation = [recognizer translationInView:self.messageBubbleContainerView];

        if(translation.x<0 && translation.x>=-60){
            self.dateLabel.center = CGPointMake(self.originalCenterHora.x + translation.x, self.originalCenterHora.y);
        }
        else if(translation.x<0){
            self.dateLabel.center = CGPointMake(self.originalCenterHora.x - 60, self.originalCenterHora.y);
        }
        
        if (translation.x>-100) {
            self.dateLabel.alpha = translation.x / (-100);
        }
        
    }
    // 3
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        // the frame this cell would have had before being dragged
        CGRect originalFrameHora = CGRectMake(self.originalCenterHora.x-(self.dateLabel.bounds.size.width/2),self.originalCenterHora.y-(self.dateLabel.bounds.size.height/2), self.dateLabel.bounds.size.width, self.dateLabel.bounds.size.height);
        
        [UIView animateWithDuration:0.2 animations:^{
            self.dateLabel.frame = originalFrameHora;
        }];
        
    }
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}
@end
