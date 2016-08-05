//
//  MOKPhotoMediaItem.h
//  JSQMessages
//
//  Created by Gianni Carlo on 8/3/16.
//  Copyright © 2016 Hexed Bits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSQMediaItem.h"
@interface MOKPhotoMediaItem : JSQMediaItem <JSQMessageMediaData>
@property (strong, nonatomic) NSString *mediaName;
@property CGSize size;

- (instancetype)initWithMediaName:(NSString *)name asOutgoing:(BOOL)isOutgoing isEfimero:(BOOL)isEfimero readStatus:(BOOL)readByUser;
- (void)loadDownloadedMedia;
- (CGSize)mediaViewDisplaySize;
- (void)setMediaViewDisplayHeight:(int)height;
- (UIView *)mediaView;
- (void)reapplyMask;
- (void)setMediaPath:(NSString*)userId;
@end
