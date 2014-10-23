//
//  BaseViewController.m
//  social
//
//  Created by Anindya on 7/19/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import "BaseViewController.h"
#import "Utility.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

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
    [self.searchDisplayController setDisplaysSearchBarInNavigationBar:YES];
    self.navigationItem.hidesBackButton = YES;
    disableViewOverlay = [[UIView alloc]
                          initWithFrame:CGRectMake(0.0f,44.0f,320.0f,416.0f)];
    disableViewOverlay.backgroundColor=[UIColor blackColor];
    disableViewOverlay.alpha = 0;
    tableData = [[NSMutableArray alloc]init];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    NSLog(@"foin");
}



- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"er");
    [self searchBar:self.searchDisplayController.searchBar activate:YES];
}

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    // We don't want to do anything until the user clicks
    // the 'Search' button.
    // If you wanted to display results as the user types
    // you would do that here.
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    //    [self filterContentForSearchText:searchString
    //                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
    //                                      objectAtIndex:[self.searchDisplayController.searchBar
    //                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchBar:searchBar activate:NO];
    [self searchUser:searchBar.text];
}


-(void)searchUser:(NSString*)userName{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Name = %@",userName];
    PFQuery *query = [PFQuery queryWithClassName:@"UserInfo" predicate:predicate];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
            dispatch_async(dispatch_get_main_queue(), ^{
                for(int i = 0;i< [objects count];i++){
                    PFObject *obj = [objects objectAtIndex:i];
                    [tableData addObject:[obj valueForKey:@"Name"]];
                }
                
                [self.searchDisplayController.searchResultsTableView reloadData];
            });
        }];
    });
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self searchBar:searchBar activate:NO];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    return NO;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //   if(isSearchButtonPressed){
	static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    return cell;
    //    }
    //    return nil;
}
-(void)searchDisplayController: (UISearchDisplayController*)controller didShowSearchResultsTableView: (UITableView*)tableView{
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor redColor];
    tableView.frame = CGRectMake(0, 0, [Utility getInstance].deviceWidth,[Utility getInstance].deviceHeight - TABBARHEIGHT);
    
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
