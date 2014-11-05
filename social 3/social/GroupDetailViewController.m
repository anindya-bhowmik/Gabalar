//
//  GroupDetailViewController.m
//  social
//
//  Created by Anindya on 7/20/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import "GroupDetailViewController.h"
#import "Group.h"
#import "Utility.h"
#import "GroupSettingViewController.h"
#import "PostViewController.h"
#import "FeedCell.h"
#import "MovieController.h"
#import "ImageViewController.h"
#import "NSDate+TimeAgo.h"

@interface GroupDetailViewController ()

@end

@implementation GroupDetailViewController
@synthesize group;

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
  
     self.parseClassName = kFeed;
    self.pullToRefreshEnabled  = TRUE;
     screenRect = [[UIScreen mainScreen] bounds];
     screenWidth = screenRect.size.width;
     screenHeight = screenRect.size.height;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:self.view.window];
    
//    self.tableView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height-100);
   
    self.navigationItem.title = self.group.groupName;
    
    [self.group.groupImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            groupImage = [UIImage imageWithData:data];
            self.group.groupProfileImage = groupImage;
            dispatch_async(dispatch_get_main_queue(), ^{
               // [self.tableView reloadData];
                myImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320,100)];
                myImage.image = groupImage;
                //  [cell.contentView addSubview:myImage];
                myImage.contentMode = UIViewContentModeScaleToFill;
                myImage.userInteractionEnabled = YES;
                UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                infoButton.frame = CGRectMake(myImage.frame.size.width-50, myImage.frame.size.height/2, 50, 50);
                [infoButton addTarget:self action:@selector(goToGroupSetting) forControlEvents:UIControlEventTouchUpInside];
                [myImage addSubview:infoButton];
                 self.tableView.tableHeaderView = myImage;
                });
            // image can now be set on a UIImageView
        }
    }];
  // self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.tableView setFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height-100)];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [postView removeFromSuperview];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    UIImage *attchBtnImage = [UIImage imageNamed:@"attach"];
    UIImage *sendBtnImage = [UIImage imageNamed:@"send"];
    postView = [[UIView alloc]initWithFrame:CGRectMake(0, screenHeight-100, screenWidth, 51)];
    postView.backgroundColor = [UIColor grayColor];
    postTextView = [[UITextView alloc]initWithFrame:CGRectMake(40, 10, 200, 30)];
    postTextView.clipsToBounds = YES;
    postTextView.layer.cornerRadius = 10.0f;
    [postView addSubview:postTextView];
    
    UIButton *attachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    attachBtn.frame = CGRectMake(5, 10, attchBtnImage.size.width, attchBtnImage.size.height);
    [attachBtn setImage:attchBtnImage forState:UIControlStateNormal];
    [attachBtn addTarget:self action:@selector(showAttchmentSource) forControlEvents:UIControlEventTouchUpInside];
    [postView addSubview:attachBtn];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(250, 10, sendBtnImage.size.width, sendBtnImage.size.height);
    [sendBtn setImage:sendBtnImage forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(postToGroup) forControlEvents:UIControlEventTouchUpInside];
    [postView addSubview:sendBtn];
    [[UIApplication sharedApplication].keyWindow addSubview:postView];
    if(!self.isLoading)
        [self loadObjects];
}

-(void)postToGroup{
     [postTextView resignFirstResponder];
    [self postToFeed];
   
}

- (void)keyboardWillShow:(NSNotification *)notif
{
     [self.tableView setFrame:CGRectMake(0, 0, self.tableView.frame.size.width, screenHeight-268)];
    [postView setFrame:CGRectMake(0, screenHeight-268, screenWidth, 51)]; //Or where ever you want the view to go
    
    
}

- (void)keyboardWillHide:(NSNotification *)notif
{
      [self.tableView setFrame:CGRectMake(0, 0, self.tableView.frame.size.width, screenHeight-100)];
    [postView setFrame:CGRectMake(0, screenHeight-100, screenWidth, 51)]; //return it to its original position
    
}

-(void)showAttchmentSource{
    [postTextView resignFirstResponder];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Select Source" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:@"Library",@"Camera", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self loadImagePicker:(int)buttonIndex];
    
}

-(void)loadImagePicker:(int)index {
    NSLog(@"Send Button Pressed");
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.mediaTypes =
    [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie,(NSString *) kUTTypeImage, nil];
    imagePicker.delegate = self;
    if(index == 1){
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    }
    else if(index == 2){
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    }
    
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.image"]){
        postType = 1;
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
        originalFeedFileData = UIImageJPEGRepresentation(image, 1);
        imageData = UIImageJPEGRepresentation([self thumbnailFrom:image],0);
    }
    else{
        postType = 2;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[info valueForKey:UIImagePickerControllerMediaURL]]];
        originalFeedFileData = [NSData dataWithContentsOfURL:url];
        
        UIImage *thumbnail = [self thumbnailFromVideo:url];
        imageData = UIImageJPEGRepresentation([self thumbnailFrom:thumbnail],0);
    }
    NSUInteger imageSize   = [originalFeedFileData length];
    if(imageSize>10485760)
    {
        originalFeedFileData = nil;
        imageData = nil;
        postType = 0;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"File size have to be <10MB" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [alert show];
        });
        //return;
    }

}

-(void)postToFeed{
    PFUser *currentUser = [PFUser currentUser];
    PFObject *newGroup = [PFObject objectWithClassName:kFeed];
    [newGroup setObject:self.group.groupName forKey:@"groupName"];
    [newGroup setObject:postTextView.text forKey:@"feedText"];
    newGroup[@"postOwner"] = currentUser;
    
    if([originalFeedFileData length]>0 && [imageData length]>0){
        if(postType == 2){
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
        else if(postType == 1){
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
            NSPredicate *grpPredicate = [NSPredicate predicateWithFormat:@"groupName = %@",self.group.groupName];
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
                NSString *msgStr = [NSString stringWithFormat:@"%@ post to %@",currentUser.username,self.group.groupName];
                [PFPush sendPushMessageToQueryInBackground:pushQuery
                                               withMessage:msgStr];
            }];
            postTextView.text = @"";
           [self.tableView reloadData];
        });
        
    }];
    
    
}

-(PostViewController*)viewController{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    PostViewController *mainVc = [storyBoard instantiateViewControllerWithIdentifier:@"Post"];
    mainVc.postToGroup = self.group;
    return mainVc;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   // if(section == 1){
        return [self.objects count];
//    }
//    else
//        return 1;
}
//
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 2;
//}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}

- (PFQuery *)queryForTable {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupName = %@",self.group.groupName];
    PFQuery *query = [PFQuery queryWithClassName:kFeed predicate:predicate];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"updatedAt"];
    
    return query;
}

//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if(tableView == self.searchDisplayController.searchResultsTableView){
//        return [searchData count];
//    }
//    return 1;
//}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if(section == 1){
//        return UITableViewAutomaticDimension+30;
//    }
//    return UITableViewAutomaticDimension;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   // if(indexPath.section == 1){
        PFObject *obj = [self.objects objectAtIndex:indexPath.row];
        NSString *text = [obj objectForKey:@"feedText"];
        
        UILabel *commentsTextLabel = [[UILabel alloc] init];;
        [commentsTextLabel setNumberOfLines:0];
        commentsTextLabel.textColor = [UIColor blackColor];
        commentsTextLabel.text = text;
        [commentsTextLabel setBackgroundColor:[UIColor clearColor]];
        [commentsTextLabel setFont:[UIFont systemFontOfSize:17.0f]];
        //        labelsize=[commentsTextLabel.text sizeWithFont:commentsTextLabel.font constrainedToSize:CGSizeMake(280, 15000) lineBreakMode:NSLineBreakByWordWrapping];
        
        CGRect frame =  [text boundingRectWithSize:CGSizeMake(280, CGFLOAT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}
                                           context:nil];
        int postType =[[obj objectForKey:@"feedType"]intValue];
        if(postType == 1 || postType == 2){
            // commentsTextLabel.frame=CGRectMake(20, 200, 280, labelsize.height);
            return frame.size.height+87+160;
        }
        else{
            return frame.size.height+100;
        }
  //  }
    return UITableViewAutomaticDimension;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
     int postTypeOFFeed =[[object objectForKey:@"feedType"]intValue];
    static NSString *CellIdentifier1 = @"Cell1";
    static NSString *CellIdentifier2 = @"Cell2";
    static NSString *CellIdentifier3 = @"Cell4";
    NSString *cellIdentifier;
    if(postTypeOFFeed==0){
        cellIdentifier =CellIdentifier1;
    }
    else if (postTypeOFFeed == 1){
        cellIdentifier =CellIdentifier2;
    }
    else{
        cellIdentifier =CellIdentifier3;
    }
    
    FeedCell *cell = (FeedCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[FeedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    // tableView.separatorColor = [UIColor redColor];
        // cell.textLabel.frame
        NSString *text =[object objectForKey:@"feedText"];

        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        PFObject *postOwner = object[@"postOwner"];
    NSDate *date =[object createdAt];
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"EEE, MMM d, h:mm a"];
//   // NSString *timeStr =  [dateFormat stringFromDate:date];
//    NSTimeInterval timeInterval = [date timeIntervalSinceNow];
    NSString *timeStr = [date timeAgo];
        [postOwner fetchIfNeededInBackgroundWithBlock:^(PFObject *obj,NSError* error){
            cell.senderNameLabel.text = [obj objectForKey:@"username"];
            PFFile *img =  obj[@"userPic"];
            if(img){
                cell.senderImageView.file = img;
                [cell.senderImageView loadInBackground];
            }
            else{
                cell.senderImageView.image = [UIImage imageNamed:@"Defailt_pro"];
            }
        }];

    cell.timeLabel.text = timeStr;
        cell.feedLabel.text = text;
        [cell.feedLabel setBackgroundColor:[UIColor clearColor]];
        [cell.feedLabel setFont:[UIFont systemFontOfSize:17.0f]];
        //        labelsize=[commentsTextLabel.text sizeWithFont:commentsTextLabel.font constrainedToSize:CGSizeMake(280, 15000) lineBreakMode:NSLineBreakByWordWrapping];
        
        CGRect frame =  [text boundingRectWithSize:CGSizeMake(280, CGFLOAT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}
                                           context:nil];
        cell.feedLabel.frame = CGRectMake(8,97 , frame.size.width, frame.size.height);
        cell.feedLabel.numberOfLines = 100;

       
        if(postType ==1 || postType ==2){
            PFFile *thumbnail = object[@"feedImage"];
            cell.feedThumbImage.frame = CGRectMake(32, frame.size.height+10+87, 240, 128);
            cell.feedThumbImage.file = thumbnail;
            [cell.feedThumbImage loadInBackground];
//            NSURL *url = [NSURL fileURLWithPath:thumbnail.url];
//            cell.feedThumbImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        }
        if(postType == 1){
            UIImage *btnimage = [UIImage imageNamed:@"play"];
            UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            //[playBtn setBackgroundImage:btnimage forState:UIControlStateNormal];
            playBtn.tag = indexPath.row;
            [playBtn addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];
            playBtn.frame = CGRectMake(60, 50, btnimage.size.width, btnimage.size.height);
            cell.feedThumbImage.userInteractionEnabled = YES;
            [cell.feedThumbImage addSubview:playBtn];

        }
        if(postType == 2){
            UIImage *btnimage = [UIImage imageNamed:@"play"];
            UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [playBtn setBackgroundImage:btnimage forState:UIControlStateNormal];
            playBtn.tag = indexPath.row;
            [playBtn addTarget:self action:@selector(showVideo:) forControlEvents:UIControlEventTouchUpInside];
            playBtn.frame = CGRectMake(60, 50, btnimage.size.width, btnimage.size.height);
            cell.feedThumbImage.userInteractionEnabled = YES;
            [cell.feedThumbImage addSubview:playBtn];
        }

    return cell;
}



-(void)showVideo:(id)sender{
    UIButton *btn = (UIButton*)sender;
    PFObject *obj = [self.objects objectAtIndex:btn.tag];
    PFFile *video = [obj objectForKey:@"feedVideo"];
    MovieController *viewController = [[MovieController alloc]initWithContentURL:[NSURL URLWithString:video.url]];
    [self presentMoviePlayerViewControllerAnimated:viewController];
}


-(void)showImage:(id)sender{
    UIButton *btn = (UIButton*)sender;
    PFObject *obj = [self.objects objectAtIndex:btn.tag];
    PFFile *video = [obj objectForKey:@"feedVideo"];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ImageViewController *mainVc = [storyBoard instantiateViewControllerWithIdentifier:@"ImageView"];
    mainVc.imageFile = video;
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:mainVc];

    [self.navigationController presentViewController:navController animated:YES completion:nil];
}


-(void)goToGroupSetting{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GroupSettingViewController *mainVc = [storyBoard instantiateViewControllerWithIdentifier:@"GroupSetting"];
    mainVc.group = self.group;
    
    [self.navigationController pushViewController:mainVc animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}




-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        GroupSettingViewController *mainVc = [storyBoard instantiateViewControllerWithIdentifier:@"GroupSetting"];
        mainVc.group = self.group;
        
        [self.navigationController pushViewController:mainVc animated:YES];
    }
}


- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    if([self.objects count]>0){
        return [self.objects objectAtIndex:indexPath.row];
    }
    else
        return nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
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
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    if(!self.isLoading)
//        [self loadObjects];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
