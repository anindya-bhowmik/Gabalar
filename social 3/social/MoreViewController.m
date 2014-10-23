//
//  MoreViewController.m
//  social
//
//  Created by Anindya on 7/17/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import "MoreViewController.h"
#import "Utility.h"
#import "User.h"
#import "CreateGroupViewController.h"
#import "AppDelegate.h"
@interface MoreViewController ()

@end

@implementation MoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    [super viewDidLoad];
//   self.searchDisplayController.searchBar.delegate = self;
    // self.searchDisplayController.searchContentsController.view.backgroundColor = [UIColor yellowColor];
    self.navigationItem.hidesBackButton = YES;
   // self.searchDisplayController.delegate = self;
    tableData = [[NSMutableArray alloc]init];
    searchData = [[NSMutableArray alloc]init];
   // PFUser *currentUser = [PFUser currentUser];
    [tableData addObject:@"Change/Upload profile pic"];
    [tableData addObject:@"Create New Group"];
    [tableData addObject:@"Log Out"];
    // Do any additional setup after loading the view.
    
    
//    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//    searchBarController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
//    /*contents controller is the UITableViewController, this let you to reuse
//     the same TableViewController Delegate method used for the main table.*/
//    
//    searchBarController.delegate = self;
//    searchBarController.searchResultsDataSource = self;
//    //set the delegate = self. Previously declared in ViewController.h
//    
//    tableView.tableHeaderView = searchBar;
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.searchDisplayController.searchResultsTableView)
        return [searchData count];
    else{
        return 1;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView != self.searchDisplayController.searchResultsTableView){
        return 3;
    }
    else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   // if(tableView != self.searchDisplayController.searchResultsTableView){
        if(section == 0)
        {
            return @"Profile";
        }
        else if(section == 1)
        {
            return @"Group";
        }
   
    
    return nil;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //   if(isSearchButtonPressed){
	static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if(tableView == self.searchDisplayController.searchResultsTableView){
        cell.textLabel.text = [searchData objectAtIndex:indexPath.row];
    }
    else{
        cell.textLabel.text = [tableData objectAtIndex:indexPath.section];
    }
    return cell;
    //    }
    //    return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView != self.searchDisplayController.searchResultsTableView){
        NSLog(@"Indexpath = %ld",(long)indexPath.section);
        if(indexPath.section == 0){
            if(indexPath.row == 0){
                [self selectImageLibrary];
            }
        }
        else if (indexPath.section == 1){
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            CreateGroupViewController *mainVc = [storyBoard instantiateViewControllerWithIdentifier:@"GroupCreate"];
            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:mainVc];
            [self.navigationController presentViewController:navController animated:YES completion:nil];
            //[self presentViewController:navController animated:YES completion:Nil];
        }
        else if (indexPath.section == 2){
            [PFUser logOut];
            [[Utility getInstance]setCurrentUser:nil];
           // [self dismissViewControllerAnimated:YES completion:nil];
            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            [appDelegate showLogInView];
        }
    }
    else{
        
    }
}


-(void)selectImageLibrary{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Select ImageSource" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:@"Library",@"Camera", nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self loadImagePicker:(int)buttonIndex];
    
}

-(void)loadImagePicker:(int)index {
    NSLog(@"Send Button Pressed");
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    if(index == 1){
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
          [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else if(index == 2){
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
  
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    imageData = UIImageJPEGRepresentation([self thumbnailFrom:image], 0.05f);
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
    [imageFile saveInBackground];
    
    PFUser *user = [PFUser currentUser];
    [user setObject:imageFile forKey:@"userPic"];
    [user saveInBackground];
    [user refresh];
 
}
-(UIImage*)thumbnailFrom:(UIImage*)sourceImage{
    UIImage *originalImage = sourceImage;
    CGSize destinationSize = CGSizeMake(100, 100);
    UIGraphicsBeginImageContext(destinationSize);
    [originalImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
