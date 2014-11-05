//
//  GroupDetailViewController.h
//  social
//
//  Created by Anindya on 7/20/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
@class Group;
@interface GroupDetailViewController : PFQueryTableViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate>{
    UIImage *groupImage;
    UIImageView *myImage;
    UIView *postView;
    UITextView *postTextView;
    CGRect screenRect ;
    CGFloat screenWidth ;
    CGFloat screenHeight;
    
    int postType;
    NSData *originalFeedFileData;
    NSData *imageData;
}
@property (weak, nonatomic) IBOutlet UIImageView *groupImageView;
@property(strong,nonatomic)Group *group;

@end
