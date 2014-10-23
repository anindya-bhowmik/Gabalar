//
//  PublicGroupViewController.m
//  social
//
//  Created by Anindya on 6/23/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import "PublicGroupViewController.h"
#import "GroupCell.h"
#import "Group.h"
#import "GroupDetailViewController.h"
#import "PostViewController.h"

@interface PublicGroupViewController ()

@end

@implementation PublicGroupViewController

//-(id)initWithCoder:(NSCoder *)aDecoder{
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        
//        
//        self.parseClassName = kGroup;
//        
//        //self.textKey = KEY_COMMENT;
//        
//        self.pullToRefreshEnabled = YES;
//        
//      //  self.paginationEnabled = NO;
//        
//        //self.objectsPerPage = 10;
//    }
//    return self;
//
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.parseClassName = kGroup;
    self.pullToRefreshEnabled  = YES;
    //[self.searchDisplayController setDisplaysSearchBarInNavigationBar:YES];
    self.searchDisplayController.searchResultsDataSource = self;
    UIView *postView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    postView.backgroundColor = [UIColor clearColor];
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    postButton.frame = CGRectMake(10, 10, 50, 20);
    postButton.backgroundColor = [UIColor blueColor];
    [postButton setTitle:@"Post" forState:UIControlStateNormal];
    [postButton addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    [postView addSubview:postButton];
    
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photoButton.frame = CGRectMake(90, 10, 100, 20);
    photoButton.backgroundColor = [UIColor blueColor];
    [photoButton setTitle:@"Add Photo" forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
    [postView addSubview:photoButton];
    
    UIButton *videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    videoButton.frame = CGRectMake(220, 10, 90, 20);
    videoButton.backgroundColor = [UIColor blueColor];
    [videoButton setTitle:@"Add Video" forState:UIControlStateNormal];
    [videoButton addTarget:self action:@selector(addVideo) forControlEvents:UIControlEventTouchUpInside];
    [postView addSubview:videoButton];
    
   // self.tableView.tableHeaderView = postView;
    searchData = [[NSMutableArray alloc]init];
    isSearchButonPressed = false;
    // Do any additional setup after loading the view.
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    [self.navigationController pushViewController:postVc animated:YES];
}

-(void)addPhoto{
    PostViewController *postVc = [self viewController];
    postVc.postType = 1;
    [self presentViewController:postVc animated:YES completion:nil];
   // [self.navigationController pushViewController:postVc animated:YES];
}

-(PostViewController*)viewController{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    PostViewController *mainVc = [storyBoard instantiateViewControllerWithIdentifier:@"Post"];
    return mainVc;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}

- (PFQuery *)queryForTable {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isPublic = TRUE"];
    PFQuery *query = [PFQuery queryWithClassName:kGroup predicate:predicate];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
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
    static NSString *CellIdentifier1 = @"Cell1";
    if(tableView != self.searchDisplayController.searchResultsTableView){
    cell = (GroupCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    }
    else{
        cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if(cell1 == nil){
            cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        }
    }
    
    if(tableView != self.searchDisplayController.searchResultsTableView){
        cell.name.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:17];
        cell.name.textColor = [UIColor blackColor];
        cell.name.numberOfLines = 3;
        cell.name.text = [object objectForKey:@"groupName"];
        PFFile *thumbnail = object[@"groupPic"];
        cell.groupPic.file = thumbnail;
        [cell.groupPic loadInBackground];
    }
    else{
        PFObject *obj = [searchData objectAtIndex:indexPath.row];
         NSString *stri = [obj objectForKey:@"groupName"];
        cell1.textLabel.text = stri;//[object objectForKey:@"groupName"];
        return cell1;
    }
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PFObject *groupObject;
    if(tableView != self.searchDisplayController.searchResultsTableView){
    groupObject = [self.objects   objectAtIndex:indexPath.row];
    }
    else{
        groupObject = [searchData objectAtIndex:indexPath.row];
    }
    Group *selectedGroup = [[Group alloc]init];
    selectedGroup.groupID = [[groupObject objectForKey:@"groupID"]intValue];
    selectedGroup.groupName = [groupObject objectForKey:@"groupName"];
    selectedGroup.groupImage = groupObject[@"groupPic"];
    selectedGroup.isPublic = [[groupObject objectForKey:@"isPublic"]boolValue];
    selectedGroup.groupObjectID = groupObject.objectId;//[groupObject objectForKey:@"objectId"];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    GroupDetailViewController *mainVc = [storyBoard instantiateViewControllerWithIdentifier:@"GroupDetail"];
    mainVc.group = selectedGroup;

    [self.navigationController pushViewController:mainVc animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchBar:searchBar activate:NO];
    [self searchGroup:searchBar.text];
    if([searchData count]>0){
        [searchData removeAllObjects];
    }
    [searchBar setShowsCancelButton:YES animated:YES];
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



- (void)searchBar:(UISearchBar *)searchBar activate:(BOOL) active{
    //    self.theTableView.allowsSelection = !active;
    //    self.theTableView.scrollEnabled = !active;
    if (!active) {
        [disableViewOverlay removeFromSuperview];
        [searchBar resignFirstResponder];
    } else {
        disableViewOverlay.alpha = 0;
        //  [self.view addSubview:disableViewOverlay];
        [UIView beginAnimations:@"FadeIn" context:nil];
        [UIView setAnimationDuration:0.5];
        disableViewOverlay.alpha = 0.6;
        [UIView commitAnimations];
        
    }
    [searchBar setShowsCancelButton:active animated:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self searchBar:searchBar activate:NO];
}

-(void)searchGroup:(NSString *)groupName{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupNameLower CONTAINS[c] %@",[groupName lowercaseString]];
    NSPredicate *privatePredicate = [NSPredicate predicateWithFormat:@"isPublic = TRUE"];
    //NSPredicate *finalPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:predicate,privatePredicate, nil]];

    PFQuery *query = [PFQuery queryWithClassName:kGroup predicate:privatePredicate];
    [query whereKey:@"groupNameLower" containsString:groupName];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
            dispatch_async(dispatch_get_main_queue(), ^{
                for(int i = 0;i< [objects count];i++){
                    PFObject *obj = [objects objectAtIndex:i];
                    [searchData addObject:obj];
                }
                //  [self searchDisplayControllerDidEndSearch:self.searchDisplayController];
                [self.searchDisplayController.searchResultsTableView reloadData];
            });
        }];
    });

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return self.objects.count;
    } else {
        return [searchData count] ;
    }
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    //    [self filterContentForSearchText:searchString
    //                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
    //                                      objectAtIndex:[self.searchDisplayController.searchBar
    //                                                     selectedScopeButtonIndex]]];
    
    return NO;
}

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    if(!self.isLoading)
//        [self loadObjects];
//}
//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
//    return NO;
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
