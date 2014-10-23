//
//  PostViewController.m
//  social
//
//  Created by user on 7/23/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import "PostViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "Utility.h"
#import "User.h"
#import "Group.h"
#import <AVFoundation/AVFoundation.h>
@interface PostViewController ()

@end

@implementation PostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIBarButtonItem *post = [[UIBarButtonItem alloc]initWithTitle:@"Post" style:UIBarButtonItemStyleDone target:self action:@selector(postToFeed)];
    self.navigationItem.rightBarButtonItem = post;
    isFirstShown = FALSE;
    //   [feedTextView becomeFirstResponder];
    //if(post)
    //    if(_postType ==1){
    //        [self showImagePicker];
    //    }
    //    else{
    //        [feedTextView becomeFirstResponder];
    //    }
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(_postType == 1 || _postType == 2){
        if(!isFirstShown){
            isFirstShown = TRUE;
            [self showImagePicker:_postType];
        }
    }
    else{
        picBtnContainer.hidden = NO;
        [feedTextView becomeFirstResponder];
    }
}

//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//     [self showImagePicker];
//}

-(void)showImagePicker:(int)type{
    _postType = type;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if (type==1) {
         imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    }
    else{
         imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
    }
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
   // imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    //if(index == 1){
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}
- (IBAction)videoBtnAction:(id)sender {
    [self showImagePicker:2];
}

- (IBAction)picBtnAction:(id)sender {
    [self showImagePicker:1];
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if(_postType == 1){
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
        originalFeedFileData = UIImageJPEGRepresentation(image, 1);
        imageData = UIImageJPEGRepresentation([self thumbnailFrom:image],0);
        feedImage.image = [UIImage imageWithData:imageData];
      
        picBtnContainer.hidden = YES;
    }
    else if (_postType == 2){
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[info valueForKey:UIImagePickerControllerMediaURL]]];
       originalFeedFileData = [NSData dataWithContentsOfURL:url];
        
        UIImage *thumbnail = [self thumbnailFromVideo:url];
        imageData = UIImageJPEGRepresentation([self thumbnailFrom:thumbnail],0);
//        imageData = UIImageJPEGRepresentation([self loadImage:url], 0.05f);
    }
     NSUInteger imageSize   = [originalFeedFileData length];
    if(imageSize>10485760)
    {
        originalFeedFileData = nil;
        imageData = nil;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"File size have to be <10MB" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
            });
        //return;
    }
      [picker dismissViewControllerAnimated:YES completion:nil];
    [feedTextView becomeFirstResponder];
}

- (UIImage*)thumbnailFromVideo:(NSURL*)vidURL {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:vidURL options:nil];
    AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    NSError *err = NULL;
    CMTime time = CMTimeMake(1, 60);
    CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
    NSLog(@"err==%@, imageRef==%@", err, imgRef);
    
    return [[UIImage alloc] initWithCGImage:imgRef];
    
}



-(UIImage*)thumbnailFrom:(UIImage*)sourceImage{
    UIImage *originalImage = sourceImage;
    CGSize destinationSize = CGSizeMake(240, 128);
    UIGraphicsBeginImageContext(destinationSize);
    [originalImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    picBtnContainer.hidden = NO;
    [picker dismissViewControllerAnimated:YES completion:nil];
    [feedTextView becomeFirstResponder];
}


- (void)keyboardDidShow:(NSNotification *)notification
{
    //Assign new frame to your view
    [picBtnContainer setFrame:CGRectMake(0,200,320,460)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
    
}

-(void)postToFeed{
   PFUser *currentUser = [PFUser currentUser];
    PFObject *newGroup = [PFObject objectWithClassName:kFeed];
    [newGroup setObject:_postToGroup.groupName forKey:@"groupName"];
    [newGroup setObject:feedTextView.text forKey:@"feedText"];
    newGroup[@"postOwner"] = currentUser;

    if([originalFeedFileData length]>0 && [imageData length]>0){
        if(_postType == 2){
            PFFile *file = [PFFile fileWithName:@"video.mov" data:originalFeedFileData];
            PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
            [newGroup setObject:imageFile forKey:@"feedImage"];
            //  [file save];
            [file saveInBackgroundWithBlock:^(BOOL succeeded,NSError *error){
                [newGroup setObject:file forKey:@"feedVideo"];
                [newGroup setObject:[NSNumber numberWithInt:2] forKey:@"feedType"];
                [self postAndSendNotification:newGroup];
            }];
            
        }
        else if(_postType == 1){
            PFFile *file = [PFFile fileWithName:@"OriginalImage.jpg" data:originalFeedFileData];
            PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
            [newGroup setObject:imageFile forKey:@"feedImage"];
            [newGroup setObject:file forKey:@"feedVideo"];
            [newGroup setObject:[NSNumber numberWithInt:1] forKey:@"feedType"];
            [self postAndSendNotification:newGroup];
        }
    }
    else{
        [newGroup setObject:[NSNumber numberWithInt:0] forKey:@"feedType"];
        [self postAndSendNotification:newGroup];
    }        // if([originalFeedFileData length]>0){
      //  PFFile *imageFile = [PFFile fileWithData:originalFeedFileData];
            }
    // [newGroup setObject:_groupDescriptionTextView.text forKey:@"groupDescription"];
    
-(void)postAndSendNotification:(PFObject*)newGroup{
     PFUser *currentUser = [PFUser currentUser];
    [newGroup saveInBackgroundWithBlock:^(BOOL succeeded,NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"username != %@",currentUser.username];
            PFQuery *userQuery = [PFQuery queryWithClassName:kUSER predicate:userPredicate];
            NSPredicate *grpPredicate = [NSPredicate predicateWithFormat:@"groupName = %@",_postToGroup.groupName];
            PFQuery *grpQuery = [PFQuery queryWithClassName:kGroup predicate:grpPredicate];
            PFQuery *memberQuery = [PFQuery queryWithClassName:kMember];
            [memberQuery whereKey:@"groupInfo" matchesQuery:grpQuery];
            [memberQuery whereKey:@"memberInfo" matchesQuery:userQuery];
            [memberQuery includeKey:@"memberInfo"];
            [memberQuery findObjectsInBackgroundWithBlock:^(NSArray *objects,NSError *error){
                NSMutableArray *memberArray = [[NSMutableArray alloc]init];
                for (int i = 0; i<[objects count]; i++) {
                    PFObject *obj  = [objects objectAtIndex:i];
                    PFUser *user = obj[@"memberInfo"];
                    [memberArray addObject:user.username];
                }
                PFQuery *pushQuery = [PFInstallation query];
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                
                [pushQuery whereKey:@"userName" containedIn:memberArray];
                [pushQuery whereKey:@"deviceToken" notEqualTo:currentInstallation.deviceToken];
                // Send push notification to query
                NSString *msgStr = [NSString stringWithFormat:@"%@ post to %@",currentUser.username,_postToGroup.groupName];
                [PFPush sendPushMessageToQueryInBackground:pushQuery
                                               withMessage:msgStr];
            }];
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }];


}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
