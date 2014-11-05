//
//  InvitationViewController.m
//  social
//
//  Created by user on 7/23/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import "InvitationViewController.h"

#import "Utility.h"
@interface InvitationViewController ()

@end

@implementation InvitationViewController

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
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    currentUser = [PFUser currentUser];
    self.parseClassName = kInvitation;
    self.pullToRefreshEnabled  = YES;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // [self.tableView reloadData];
   

}

#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    if ([self.objects count] == 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No invitations yet!" message:@"Don't feel sad. Once you're invited to others' groups, those invitations will appear here!" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        
    }

    
    // This method is called before a PFQuery is fired to get more objects
}

- (PFQuery *)queryForTable {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recieverName = %@",currentUser.username];
    if(predicate){
        PFQuery *query = [PFQuery queryWithClassName:kInvitation predicate:predicate];
        
        // If no objects are loaded in memory, we look to the cache first to fill the table
        // and then subsequently do a query against the network.
        if ([self.objects count] == 0) {
            query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        }
        [query includeKey:@"group"];
        [query orderByAscending:@"updatedAt"];
        
        return  query;
    }
    else
        return Nil;
}

//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if(tableView == self.searchDisplayController.searchResultsTableView){
//        return [searchData count];
//    }
//    return 1;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    // if(tableView != self.searchDisplayController.searchResultsTableView){
    
    PFObject *grp = object[@"group"];
    
    NSString *grpName = [grp objectForKey:@"groupName"];
    NSString *senderName = [object objectForKey:@"senderName"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ invites to join %@",senderName,grpName];
    UIButton * acceptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    acceptBtn.frame = CGRectMake(150, 75, 75, 20);
    acceptBtn.backgroundColor = [UIColor greenColor];
    acceptBtn.tag = indexPath.row;
    [acceptBtn setTitle:@"Accept" forState:UIControlStateNormal];
    [acceptBtn addTarget:self action:@selector(accept:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:acceptBtn];
    
    UIButton * rejectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rejectBtn.frame = CGRectMake(240, 75, 75, 20);
    rejectBtn.backgroundColor = [UIColor redColor];
    rejectBtn.tag = indexPath.row;
    [rejectBtn setTitle:@"Reject" forState:UIControlStateNormal];
    [rejectBtn addTarget:self action:@selector(reject:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:rejectBtn];
    
    
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"Priority: %@", [object objectForKey:@"groupDescription"]];
//    PFFile *thumbnail = object[@"groupPic"];
//    
//    // cell.imageView.image = [UIImage imageNamed:@"placeholder.jpg"];
//    cell.imageView.file = thumbnail;
    //    }
    //    else{
    //        // if(([searchData count]>0) && (indexPath.row<[searchData count])){
    //        PFObject *obj = [searchData objectAtIndex:indexPath.row];
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


-(void)accept:(UIButton*)sender{
    
    PFObject *object = [self.objects objectAtIndex:sender.tag];
    PFObject *newMember = [PFObject objectWithClassName:kMember];
//    PFObject *user = [PFObject objectWithClassName:kUSER];
//    user.objectId = currentUser.objectId;
    PFObject *grp = object[@"group"];
   
  //  [grp fetchIfNeededInBackgroundWithBlock:^(PFObject *groupObject,NSError *error){
       // BOOL isPublic = [[grp valueForKey:@"isPublic"]boolValue];
        [newMember setObject:[NSNumber numberWithBool:FALSE] forKey:@"isCreator"];
        [newMember setObject:[NSNumber numberWithBool:[[grp valueForKey:@"isPublic"]boolValue]] forKey:@"isPublic"];
        newMember[@"memberInfo"] = currentUser;
        newMember[@"groupInfo"] = grp;
        [newMember saveInBackgroundWithBlock:^(BOOL succedded,NSError*error){
            PFObject *object = [self.objects objectAtIndex:sender.tag];
//            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
//            [currentInstallation setObject:[grp objectForKey:@"groupID"] forKey:@"groupID"];
//            [currentInstallation setDeviceToken:currentInstallation.deviceToken];
//            [currentInstallation saveInBackground];

            [object deleteInBackgroundWithBlock:^(BOOL succeeded,NSError *error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadObjects];
                });
            }];
        }];

   // }];
    
}

-(void)reject:(UIButton*)sender{
    PFObject *object = [self.objects objectAtIndex:sender.tag];
    [object deleteInBackgroundWithBlock:^(BOOL succeeded,NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
             [self loadObjects];
        });
    }];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if(!self.isLoading)
        [self loadObjects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
