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
    


    
    [self.group.groupImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            groupImage = [UIImage imageWithData:data];
            self.group.groupProfileImage = groupImage;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                });
            // image can now be set on a UIImageView
        }
    }];
   self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIView *postView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    postView.backgroundColor = [UIColor clearColor];
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    postButton.frame = CGRectMake(5, 10, 90, 20);
     postButton.backgroundColor = [UIColor darkGrayColor];
    [postButton setTitle:@"Add Text" forState:UIControlStateNormal];
    postButton.titleLabel.textColor = [UIColor grayColor];
    [postButton addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    [postView addSubview:postButton];
    
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photoButton.frame = CGRectMake(105, 10, 100, 20);
       photoButton.backgroundColor = [UIColor darkGrayColor];
    [photoButton setTitle:@"Add Photo" forState:UIControlStateNormal];
    photoButton.titleLabel.textColor = [UIColor grayColor];
    [photoButton addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
    [postView addSubview:photoButton];
    
    UIButton *videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    videoButton.frame = CGRectMake(215, 10, 100, 20);
    videoButton.backgroundColor = [UIColor darkGrayColor];
    [videoButton setTitle:@"Add Video" forState:UIControlStateNormal];
    videoButton.titleLabel.textColor = [UIColor grayColor];
    [videoButton addTarget:self action:@selector(addVideo) forControlEvents:UIControlEventTouchUpInside];
    [postView addSubview:videoButton];
   
    self.tableView.tableHeaderView = postView;
    if(!self.isLoading)
        [self loadObjects];
}


-(void)post{
    PostViewController *postVc = [self viewController];
    postVc.postType = 0;
    [self.navigationController pushViewController:postVc animated:YES];
}

-(void)addVideo{
    PostViewController *postVc = [self viewController];
    postVc.postType = 2;
    //[self presentViewController:postVc animated:YES completion:nil];
    [self.navigationController pushViewController:postVc animated:YES];
}



-(void)addPhoto{
    PostViewController *postVc = [self viewController];
    postVc.postType = 1;
    //[self presentViewController:postVc animated:YES completion:nil];
     [self.navigationController pushViewController:postVc animated:YES];
}

-(PostViewController*)viewController{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    PostViewController *mainVc = [storyBoard instantiateViewControllerWithIdentifier:@"Post"];
    mainVc.postToGroup = self.group;
    return mainVc;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 1){
        return [self.objects count];
    }
    else
        return 1;
}
//
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

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
    
    [query orderByAscending:@"updatedAt"];
    
    return query;
}

//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if(tableView == self.searchDisplayController.searchResultsTableView){
//        return [searchData count];
//    }
//    return 1;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 1){
        return UITableViewAutomaticDimension+30;
    }
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
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
    }
    return UITableViewAutomaticDimension;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
     int postType =[[object objectForKey:@"feedType"]intValue];
    static NSString *CellIdentifier1 = @"Cell1";
    static NSString *CellIdentifier2 = @"Cell2";
    static NSString *CellIdentifier3 = @"Cell4";
    NSString *cellIdentifier;
    if(postType==0){
        cellIdentifier =CellIdentifier1;
    }
    else if (postType == 1){
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
    if(indexPath.section == 0){
        UIImageView *myImage = [[UIImageView alloc] initWithFrame:CGRectMake(230, 0, 50, 50)];
        myImage.image = groupImage;
        [cell.contentView addSubview:myImage];
        myImage.contentMode = UIViewContentModeScaleAspectFit;
       // cell.backgroundView = [[UIImageView alloc]initWithImage:groupImage];
      //cell.backgroundView.contentMode = UIViewContentModeScaleAspectFit;
        cell.textLabel.text = self.group.groupName;
        cell.textLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:17];
        cell.textLabel.textColor = [UIColor blackColor];

        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else{
        // cell.textLabel.frame
        NSString *text =[object objectForKey:@"feedText"];

        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        PFObject *postOwner = object[@"postOwner"];
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
       // cell.feedLabel.text = text;
        //  cell.detailTextLabel.frame = CGRectMake(0, 0, cell.detailTextLabel.frame.size.width, frame.size.height);
        // cell.textLabel.text = text;
      //  cell.feedLabel.numberOfLines = 100;
       // PFFile *thumbnail = object[@"feedImage"];
//        if(thumbnail)
        
        //cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
       
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
//        if(postType == 2){
//        PFFile *video = object[@"feedVideo"];
//            
//            NSLog(@"video url...%@", video.url);
//            NSURL *videoURL = [NSURL URLWithString:video.url];
//            MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
//            [moviePlayer.moviePlayer setControlStyle:MPMovieControlStyleEmbedded];
//            // moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
//            [moviePlayer.view setFrame:CGRectMake(10, 10, 120, 120)];
//            moviePlayer.moviePlayer.shouldAutoplay = NO;
//            moviePlayer.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
//            [moviePlayer.moviePlayer prepareToPlay];
//
//            [cell.contentView addSubview:moviePlayer.view];
//            [moviePlayer.moviePlayer prepareToPlay];
//           // [moviePlayer play];
//            // }];
//             }
        //}];
//        if(video){
//            NSURL *videoURL = [NSURL URLWithString:video.url];
//            MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
//            [moviePlayer setControlStyle:MPMovieControlStyleNone];
//            moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
//            [moviePlayer.view setFrame:CGRectMake(10.0, 0.0, 50.0 , 300.0)];
//            [cell.contentView addSubview:moviePlayer.view];
//            moviePlayer.view.hidden = NO;
//            [moviePlayer prepareToPlay];
//            [moviePlayer play];
//        }
        //
        //        // cell.imageView.image = [UIImage imageNamed:@"placeholder.jpg"];
        //        cell.imageView.file = thumbnail;
    }
    //
    //    // Configure the cell
    //    if(tableView != self.searchDisplayController.searchResultsTableView){
    //        cell.textLabel.text = [object objectForKey:@"groupName"];
    //        cell.detailTextLabel.text = [NSString stringWithFormat:@"Priority: %@", [object objectForKey:@"groupDescription"]];
    //        PFFile *thumbnail = object[@"groupPic"];
    //
    //        // cell.imageView.image = [UIImage imageNamed:@"placeholder.jpg"];
    //        cell.imageView.file = thumbnail;
    //    }
    //    else{
    //        // if(([searchData count]>0) && (indexPath.row<[searchData count])){
    //      //  PFObject *obj = [searchData objectAtIndex:indexPath.row];
    //        cell.textLabel.text = [obj objectForKey:@"groupName"];
    //        cell.detailTextLabel.text = [NSString stringWithFormat:@"Priority: %@", [obj objectForKey:@"groupDescription"]];
    //        PFFile *thumbnail = obj[@"groupPic"];
    //
    //        // cell.imageView.image = [UIImage imageNamed:@"placeholder.jpg"];
    //        cell.imageView.file = thumbnail;
    //        //  }
    //    }
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
