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

@import Photos;

@interface MOKChatViewController ()
@property (strong, nonatomic) NSDateFormatter *curentTimezoneFormatter;

@property (nonatomic, strong) UIBarButtonItem *negativeSpacerButtonItem;
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
  
  /***************** Navigation bar **********************/
  // VIEW - navigation bar - title
  self.descriptionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/1.8, 44)];
  
  self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.descriptionView.frame.size.height - self.descriptionView.frame.size.height/2 - self.descriptionView.frame.size.height/2.5, self.descriptionView.frame.size.width, self.descriptionView.frame.size.height/2)];
  self.nameLabel.textColor = [UIColor blackColor];
  self.nameLabel.font = [UIFont boldSystemFontOfSize:16.0];
  self.nameLabel.textAlignment = NSTextAlignmentCenter;
  
  self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.descriptionView.frame.size.height - self.descriptionView.frame.size.height/2.4 - 2, self.descriptionView.frame.size.width, self.descriptionView.frame.size.height/2.4)];
  self.statusLabel.textColor = [UIColor grayColor];
  self.statusLabel.font = [UIFont systemFontOfSize:11.0];
  self.statusLabel.textAlignment = NSTextAlignmentCenter;
  
  [self.descriptionView addSubview:self.nameLabel];
  [self.descriptionView addSubview:self.statusLabel];
  
  self.navigationItem.titleView = self.descriptionView;
  
  //Leaving this for future reference
  
//  self.descriptionViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.showInfoConversation(_:)))
//  self.descriptionViewTapRecognizer.numberOfTapsRequired = 1
//  self.descriptionView.addGestureRecognizer(self.descriptionViewTapRecognizer)
  
  // VIEW - navigation bar - right button
  self.negativeSpacerButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
  self.negativeSpacerButtonItem.width = -12;
  
  self.avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Profile_imgDefault.png"]];
  
  self.avatarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
  [self.avatarButton setImage:self.avatarImageView.image forState:UIControlStateNormal];
  self.avatarButton.layer.cornerRadius = 18;
  self.avatarButton.layer.masksToBounds = true;
  
  
  self.avatarBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.avatarButton];
  
  self.navigationItem.rightBarButtonItems = @[self.negativeSpacerButtonItem, self.avatarBarButtonItem];
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

#pragma mark - Default Media
-(void)defaultMedia {
  UIAlertController *alertcontroller= [UIAlertController alertControllerWithTitle:nil
                                                                          message:nil
                                                                   preferredStyle:UIAlertControllerStyleActionSheet];
  
  UIAlertAction* pickPhoto = [UIAlertAction
                              actionWithTitle:@"Choose existing picture"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                
                                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                    switch (status) {
                                      case PHAuthorizationStatusAuthorized:{
                                        [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                        UIImagePickerController *imagePicker = [UIImagePickerController new];
                                        imagePicker.delegate = self;
                                        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                        
                                        [self presentViewController:imagePicker animated:true completion:nil];
                                        break;
                                      }
                                      case PHAuthorizationStatusRestricted:
                                      case PHAuthorizationStatusDenied:
                                      default:{
                                        [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                        
                                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Maduro" preferredStyle:UIAlertControllerStyleAlert];
                                        
                                        [alert addAction:[UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                          [[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString:UIApplicationOpenSettingsURLString]];
                                        } ]];
                                        
                                        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
                                        
                                        alert.popoverPresentationController.sourceView = self.view;
                                        alert.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height-45, 1.0, 1.0);
                                        
                                        
                                        [self presentViewController:alert animated:true completion:nil];
                                        break;
                                      }
                                    }
                                  });
                                  
                                }];
                              }];
  
  UIAlertAction* cancel = [UIAlertAction
                           actionWithTitle: @"Cancel"
                           style:UIAlertActionStyleCancel
                           handler:^(UIAlertAction * action)
                           {
                             [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                             
                           }];
  
  if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    UIAlertAction* takePhoto = [UIAlertAction
                                actionWithTitle:@"Take Picture"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                  
                                  [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                      if (!granted) {
                                        [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                        
                                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"We need access" preferredStyle:UIAlertControllerStyleAlert];
                                        
                                        [alert addAction:[UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                          [[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString:UIApplicationOpenSettingsURLString]];
                                        } ]];
                                        
                                        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
                                        
                                        alert.popoverPresentationController.sourceView = self.view;
                                        alert.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height-45, 1.0, 1.0);
                                        
                                        
                                        [self presentViewController:alert animated:true completion:nil];
                                      }else{
                                        [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                        
                                        UIImagePickerController *imagePicker = [UIImagePickerController new];
                                        imagePicker.delegate = self;
                                        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                        
                                        [self presentViewController:imagePicker animated:true completion:nil];
                                      }
                                    });
                                  }];
                                  
                                  
                                }];
    [alertcontroller addAction:takePhoto];
  }
  
  [alertcontroller addAction:pickPhoto];
  [alertcontroller addAction:cancel];
  
  alertcontroller.popoverPresentationController.sourceView = self.view;
  alertcontroller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height-45, 1.0, 1.0);
  [self presentViewController:alertcontroller animated:YES completion:nil];
}

#pragma mark - Image delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *,id> *)editingInfo{
  
  [self dismissViewControllerAnimated:true completion:^{
    if ([self.mediaDataDelegate respondsToSelector:@selector(selectedImage:)]) {
      [self.mediaDataDelegate selectedImage:[[NSData alloc] initWithData:UIImageJPEGRepresentation(image, 0.6)]];
    }
  }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
  [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - JSQMessagesViewController method overrides
-(void)didPressAccessoryButton:(UIButton *)sender {
  [self defaultMedia];
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
