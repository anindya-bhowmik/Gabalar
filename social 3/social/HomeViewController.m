//
//  HomeViewController.m
//  social
//
//  Created by Anindya on 6/23/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import "HomeViewController.h"
#import "Utility.h"
#import "User.h"
#import "Group.h"
#import "GroupDetailViewController.h"
#import "GroupCell.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

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
    NSLog(@"Crashing here");
    // Do any additional setup after loading the view.
    currentUser = [[Utility getInstance]getCurrentUser];
    self.parseClassName = kGroup;
    self.pullToRefreshEnabled  = NO;
    groupID = [[NSMutableArray alloc]init];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
   
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!self.isLoading)
        [self loadObjects];
}


//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    if(!self.isLoading)
//        [self loadObjects];
//}


#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    NSLog(@"count = %d",[self.objects count]);
    if ([self.objects count] == 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"This is your home screen!" message:@"Once you've created some networks, they will appear here! How awesome is that!?" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];

    }
    
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}


-(NSPredicate*)getPredicate{
    NSPredicate *firstOne = [NSPredicate predicateWithFormat:@"isPublic = TRUE"];
    NSPredicate *secondOne  = [NSPredicate predicateWithFormat:@"isPublic = FALSE"];
    NSPredicate *thirdOne = [NSCompoundPredicate orPredicateWithSubpredicates:[NSArray arrayWithObjects:firstOne,secondOne, nil]];
    return thirdOne;
}


- (PFQuery *)queryForTable {
//    PFObject *newMember = [PFObject objectWithClassName:kMember];
//    PFRelation *relation = [newMember relationForKey:@"groupInfo"];
    PFQuery *query = [PFQuery queryWithClassName:kMember];
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
//    User *currentuser = [[Utility getInstance]getCurrentUser];
//    PFObject *user = [PFObject objectWithClassName:kUSER];
//    [user setObject:currentuser.userName forKey:@"Name"];
//    [user setObject:[NSNumber numberWithInt:currentuser.userId] forKey:@"user_id"];
//    user.objectId = currentuser.objectID;
    PFUser *user = [PFUser currentUser];
    [query whereKey:@"memberInfo" equalTo:user];
    [query includeKey:@"groupInfo"];
   // NSArray *objects = [query findObjects];
    [query orderByDescending:@"createdAt"];
    return query;
}

//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if(tableView == self.searchDisplayController.searchResultsTableView){
//        return [searchData count];
//    }
//    return 1;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    //UILabel *nameLabel;
    GroupCell *cell = (GroupCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
   PFObject *group = object[@"groupInfo"];
   // nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 50)];
   // }
    cell.name.text = group[@"groupName"];
    
    
   PFFile *thumbnail = group[@"groupPic"];
    cell.groupPic.file = thumbnail;
     if(![cell.groupPic.file isDataAvailable])
       [cell.groupPic loadInBackground];
//    [thumbnail getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
//        
//        NSData *imageFile = [thumbnail getData];
//        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.imageView.frame=CGRectMake(0, 0, 30, 30);
//        //Set the animals Icon Image to what ever is intended.
//        cell.imageView.image = [UIImage imageWithData:imageFile];
//    }];
    // cell.imageView.image = [UIImage imageNamed:@"placeholder.jpg"];
//    [thumbnail getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//        cell.imageView.image = [[UIImage alloc] initWithData:data];
//        [cell setNeedsLayout];
//    }];

    //[cell.imageView loadInBackground];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PFObject *groupObject;
    //if(tableView != self.searchDisplayController.searchResultsTableView){
        groupObject = [self.objects   objectAtIndex:indexPath.row];
    PFObject *selectedGroupObject = groupObject[@"groupInfo"];
//    }
//    else{
//        groupObject = [searchData objectAtIndex:indexPath.row];
//    }
    Group *selectedGroup = [[Group alloc]init];
    selectedGroup.groupID = [[selectedGroupObject objectForKey:@"groupID"]intValue];
    selectedGroup.groupName = [selectedGroupObject objectForKey:@"groupName"];
    selectedGroup.groupImage = selectedGroupObject[@"groupPic"];
    selectedGroup.groupObjectID = selectedGroupObject.objectId;
    selectedGroup.isPublic  = [[selectedGroupObject valueForKey:@"isPublic"]boolValue];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    GroupDetailViewController *mainVc = [storyBoard instantiateViewControllerWithIdentifier:@"GroupDetail"];
    mainVc.group = selectedGroup;
    
    [self.navigationController pushViewController:mainVc animated:YES];
}


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
