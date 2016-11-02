//
//  JSQMessagesActivityIndicatorHeaderView.m
//  JSQMessages
//
//  Created by Gianni Carlo on 8/5/16.
//  Copyright © 2016 Hexed Bits. All rights reserved.
//

#import "MonkeyActivityIndicatorHeaderView.h"
#import "JSQMessagesLoadEarlierHeaderView.h"
#import "NSBundle+JSQMessages.h"

@interface MonkeyActivityIndicatorHeaderView ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation MonkeyActivityIndicatorHeaderView
#pragma mark - Class methods

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([MonkeyActivityIndicatorHeaderView class])
                          bundle:[NSBundle bundleForClass:[MonkeyActivityIndicatorHeaderView class]]];
}

+ (NSString *)headerReuseIdentifier
{
    return NSStringFromClass([MonkeyActivityIndicatorHeaderView class]);
}

#pragma mark - Initialization

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)dealloc
{
    _activityIndicatorView = nil;
}

#pragma mark - Reusable view

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    self.activityIndicatorView.backgroundColor = backgroundColor;
}

@end
