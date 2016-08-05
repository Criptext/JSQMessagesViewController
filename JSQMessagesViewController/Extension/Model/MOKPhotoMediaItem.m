//
//  BLPhotoMedia.m
//  Criptext
//
//  Created by Criptext Mac on 8/4/15.
//  Copyright (c) 2015 Criptext INC. All rights reserved.
//

#import "MOKPhotoMediaItem.h"
#import "JSQMessagesMediaPlaceholderView.h"
#import "JSQMessagesMediaViewBubbleImageMasker.h"
#import "UIColor+JSQMessages.h"

#define time_efimero 15

@interface MOKPhotoMediaItem()

@property (strong, nonatomic) id cachedMediaView;

@end

@implementation MOKPhotoMediaItem

@synthesize mediaName = _mediaName;
@synthesize size = _size;

-(instancetype)initWithMediaName:(NSString *)name asOutgoing:(BOOL)isOutgoing isEfimero:(BOOL)isEfimero readStatus:(BOOL)readByUser{
    if (self = [super init]) {
        
        self.mediaName = name;
        self.appliesMediaViewMaskAsOutgoing = isOutgoing;
        
        self.size = CGSizeMake(210.0f, 210.0f);
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            self.size = CGSizeMake(315.0f, 315.0f);
        }
        
        NSString *mediaPath = [[self documentsDirectory] stringByAppendingPathComponent:self.mediaName];
        
        //        if(!isOutgoing){
        if (![[NSFileManager defaultManager] fileExistsAtPath:mediaPath] && !(isEfimero && readByUser)) {
////            self.isFileDownloaded = false;
////            UIView *view = [JSQMessagesMediaPlaceholderView viewWithActivityIndicator];
////            view.frame = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
////            view.contentMode = UIViewContentModeScaleAspectFill;
////            view.clipsToBounds = YES;
////            view.autoresizesSubviews = YES;
//            [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:view isOutgoing:self.appliesMediaViewMaskAsOutgoing];
//            self.cachedMediaView = view;
            return self;
        }
        //        }
        
        [self loadDownloadedMedia];
    }
    return self;
}
-(void)loadDownloadedMedia{
    UIView *mediaView;
    NSString *privateString = @"";
    
    NSString *mediaPath = [[self documentsDirectory] stringByAppendingPathComponent:self.mediaName];
    UIImage *imageloaded = [UIImage imageWithData:[NSData dataWithContentsOfFile:mediaPath]];
    mediaView = [[UIImageView alloc] initWithImage:imageloaded];
    
    float scaleratio = mediaView.frame.size.width/mediaView.frame.size.height;
    
    if (scaleratio >= 1) {//landscape
        self.size = CGSizeMake(210.0f, 150.0f);
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            self.size = CGSizeMake(315.0f, 225.0f);
        }
        
    }else{//portrait
        self.size = CGSizeMake(210.0f, 210.0f);
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            self.size = CGSizeMake(315.0f, 315.0f);
        }
        
    }
    if (self.appliesMediaViewMaskAsOutgoing) {
        privateString = NSLocalizedString(@"privateImage", @"");
    }else{
        privateString = NSLocalizedString(@"tapToView", @"");
    }
    
//    if (self.isEfimero) {
//        
//        if (self.appliesMediaViewMaskAsOutgoing) {
//            mediaView = [[[NSBundle mainBundle] loadNibNamed:@"PrivateMessageView" owner:self options:nil] objectAtIndex:0];
//            [((PrivateMessageView *)mediaView).privateMessageButton setTitle:privateString forState:UIControlStateNormal];
//            ((PrivateMessageView *)mediaView).privateMessageButton.userInteractionEnabled = false;
//            ((PrivateMessageView *)mediaView).privateMessageButton.tintColor = [UIColor whiteColor];
//            ((PrivateMessageView *)mediaView).privateMessageButton.backgroundColor = [UIColor jsq_messageBubbleBlueColor];
//            self.size = CGSizeMake(_size.width, 42);
//            
//        }else{
//            self.privateMessageView = [[[NSBundle mainBundle] loadNibNamed:@"PrivateMessageView" owner:self options:nil] objectAtIndex:0];
//            [self.privateMessageView.privateMessageButton setTitle:privateString forState:UIControlStateNormal];
//            [self.privateMessageView.privateMessageButton setTitle:NSLocalizedString(@"messageExpired", @"") forState:UIControlStateDisabled];
//            [self.privateMessageView.privateMessageButton addTarget:self action:@selector(didPressEfimero) forControlEvents:UIControlEventTouchUpInside];
//            self.privateMessageView.privateMessageButton.userInteractionEnabled = true;
//            self.privateMessageView.privateMessageButton.enabled = true;
//            self.privateMessageView.backgroundColor = [UIColor jsq_messageBubbleLightGrayColor];
//            self.privateMessageView.privateMessageButton.backgroundColor = [UIColor jsq_messageBubbleLightGrayColor];
//            
//            self.privateMessageView.frame = CGRectMake(0.0f, 0.0f, mediaView.frame.size.width, mediaView.frame.size.height);
//            [mediaView addSubview:self.privateMessageView];
//            [mediaView bringSubviewToFront:self.privateMessageView.privateMessageButton];
//        }
//    }
    
    
    mediaView.frame = CGRectMake(0.0f, 0.0f, self.size.width-7, self.size.height);
    mediaView.contentMode = UIViewContentModeScaleAspectFill;
    mediaView.clipsToBounds = YES;
//    mediaView.autoresizesSubviews = YES;
//    [JSQMessagesMediaViewBubbleImageMasker crp_applyBubbleImageMaskToMediaView:mediaView isOutgoing:self.appliesMediaViewMaskAsOutgoing];
//    
//    self.isFileDownloaded = true;
//    self.cachedMediaView = mediaView;
}
-(void)didPressEfimero{
//    if ([self.delegate respondsToSelector:@selector(openMediaEfimero:)]) {
//        [self.delegate openMediaEfimero:self.delegate];
//    }
}

-(NSString *)documentsDirectory{
    NSString *documentDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return documentDirectory;
}

- (CGSize)mediaViewDisplaySize{
    return self.size;
}

- (void)setMediaViewDisplayHeight:(int)height{
    self.size = CGSizeMake(self.size.width, height);
    self.mediaView.frame = CGRectMake(self.mediaView.frame.origin.x, self.mediaView.frame.origin.y, self.mediaView.frame.size.width, height);
    self.cachedMediaView = self.mediaView;
}

-(UIView *)mediaView{
    return self.cachedMediaView;
}

-(void)reapplyMask{
    [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:self.cachedMediaView isOutgoing:self.appliesMediaViewMaskAsOutgoing];
}
- (UIView *)mediaPlaceholderView
{
    return self.cachedMediaView;
}
-(void)setMediaPath:(NSString*)userId {
    
    UIView *mediaView;
    NSString *privateString = @"";
    
    NSArray *dirArray = [self.mediaName componentsSeparatedByString:@"/"];
    NSString *nameMedia = dirArray[2];
    NSString *newMediaName = [NSString stringWithFormat:@"%@/%@",userId,nameMedia];
    NSString *mediaPath = [[self documentsDirectory] stringByAppendingPathComponent:newMediaName];
    UIImage *imageloaded = [UIImage imageWithData:[NSData dataWithContentsOfFile:mediaPath]];
    
    mediaView = [[UIImageView alloc] initWithImage:imageloaded];
    
    float scaleratio = mediaView.frame.size.width/mediaView.frame.size.height;
    
    if (scaleratio >= 1) {//landscapen
        _size = CGSizeMake(210.0f, 150.0f);
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            _size = CGSizeMake(315.0f, 225.0f);
        }
        
    }else{//portrait
        _size = CGSizeMake(210.0f, 210.0f);
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            _size = CGSizeMake(315.0f, 315.0f);
        }
    }
    
    if (self.appliesMediaViewMaskAsOutgoing) {
        privateString = NSLocalizedString(@"privateImage", @"");
    }else{
        privateString = NSLocalizedString(@"tapToView", @"");
    }
    
//    if (self.isEfimero) {
//        
//        if (self.appliesMediaViewMaskAsOutgoing) {
//            mediaView = [[[NSBundle mainBundle] loadNibNamed:@"PrivateMessageView" owner:self options:nil] objectAtIndex:0];
//            [((PrivateMessageView *)mediaView).privateMessageButton setTitle:privateString forState:UIControlStateNormal];
//            ((PrivateMessageView *)mediaView).privateMessageButton.userInteractionEnabled = false;
//            ((PrivateMessageView *)mediaView).privateMessageButton.tintColor = [UIColor whiteColor];
//            ((PrivateMessageView *)mediaView).privateMessageButton.backgroundColor = [UIColor jsq_messageBubbleBlueColor];
//            _size = CGSizeMake(_size.width, 38);
//            
//        }else{
//            self.privateMessageView = [[[NSBundle mainBundle] loadNibNamed:@"PrivateMessageView" owner:self options:nil] objectAtIndex:0];
//            [self.privateMessageView.privateMessageButton setTitle:privateString forState:UIControlStateNormal];
//            [self.privateMessageView.privateMessageButton setTitle:NSLocalizedString(@"messageExpired", @"") forState:UIControlStateDisabled];
//            self.privateMessageView.privateMessageButton.userInteractionEnabled = true;
//            self.privateMessageView.privateMessageButton.enabled = true;
//            self.privateMessageView.backgroundColor = [UIColor jsq_messageBubbleLightGrayColor];
//            self.privateMessageView.privateMessageButton.backgroundColor = [UIColor jsq_messageBubbleLightGrayColor];
//            
//            self.privateMessageView.frame = CGRectMake(0.0f, 0.0f, mediaView.frame.size.width, mediaView.frame.size.height);
//            [mediaView addSubview:self.privateMessageView];
//            [mediaView bringSubviewToFront:self.privateMessageView.privateMessageButton];
//        }
//    }
    
    mediaView.frame = CGRectMake(0.0f, 0.0f, _size.width, _size.height);
    mediaView.contentMode = UIViewContentModeScaleAspectFill;
    mediaView.clipsToBounds = YES;
    mediaView.autoresizesSubviews = YES;
    [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:mediaView isOutgoing:self.appliesMediaViewMaskAsOutgoing];
    self.cachedMediaView = mediaView;
}

@end