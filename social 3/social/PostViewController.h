//
//  PostViewController.h
//  social
//
//  Created by user on 7/23/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Group;
@interface PostViewController : UIViewController<UIImagePickerControllerDelegate>{


    IBOutlet UITextView *feedTextView;
   
    IBOutlet UIImageView *feedImage;
    IBOutlet UIView *picBtnContainer;
    BOOL isFirstShown;
    NSData *imageData;
     UIImage *imageToSent;
    NSData *originalFeedFileData;
}


@property (nonatomic,assign)int postType;
@property (nonatomic,strong)Group *postToGroup;
@end
