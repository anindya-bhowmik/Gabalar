//
//  AddMemberViewController.m
//  social
//
//  Created by Anindya on 7/23/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import "AddMemberViewController.h"
#import "Utility.h"
#import "User.h"
#import "Group.h"
@interface AddMemberViewController ()

@end

@implementation AddMemberViewController

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
    self.searchDisplayController.delegate = self;
    //self.searchDisplayController.searchResultsDataSource = self;
     // UIBarButtonItem *send = [[UIBarButtonItem alloc]initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(sendInvitation)];
   // self.navigationItem.rightBarButtonItem = send;
    // Do any additional setup after loading the view.
}


-(NSInteger)tableView:(UITableView*)numberofRowsInSection{
   return  [searchData count];
}

-(IBAction)sendInvitation:(id)sender{
    if([_memberNameField.text length]>0){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username = %@",_memberNameField.text];
        PFQuery *query = [PFQuery queryWithClassName:kUSER predicate:predicate];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects,NSError *error){
            if([objects count]>0){
                NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"username = %@",_memberNameField.text];
                PFQuery *userQuery = [PFQuery queryWithClassName:kUSER predicate:userPredicate];
                NSPredicate *grpPredicate = [NSPredicate predicateWithFormat:@"groupID = %d",self.group.groupID];
                PFQuery *groupQuery = [PFQuery queryWithClassName:kGroup predicate:grpPredicate];
                
                PFQuery *grpQuery = [PFQuery queryWithClassName:kMember];
                [grpQuery whereKey:@"groupInfo" matchesQuery:groupQuery];
                [grpQuery whereKey:@"memberInfo" matchesQuery:userQuery];
                [grpQuery findObjectsInBackgroundWithBlock:^(NSArray *members,NSError *error){
                    if([members count]>0){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Already member" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                            [alert show];
                        });
                    }
                    else{
                        PFUser *currentUser = [PFUser currentUser];
                      
                        NSPredicate *recieverName = [NSPredicate predicateWithFormat:@"recieverName = %@",_memberNameField.text];
                       
                        PFQuery *inviteQuery = [PFQuery queryWithClassName:kInvitation predicate:recieverName];
                        [inviteQuery findObjectsInBackgroundWithBlock:^(NSArray *invitations,NSError *error){
                            if([invitations count]<=0){
                                PFObject *newGroup = [PFObject objectWithClassName:kInvitation];
                                [newGroup setObject:_memberNameField.text forKey:@"recieverName"];
                                [newGroup setObject:currentUser.username forKey:@"senderName"];
                                [newGroup setObject:[NSNumber numberWithInt:[currentUser[@"user_id"]intValue]]forKey:@"senderID"];
                                PFObject *grp = [PFObject objectWithClassName:kGroup];
                                grp.objectId = self.group.groupObjectID;
                                [grp setObject:[NSNumber numberWithBool:self.group.isPublic] forKey:@"isPublic"];
                                newGroup[@"group"] = grp;
//                                [newGroup setObject:self.groupname forKey:@"groupName"];
//                                [newGroup setObject:[NSNumber numberWithInt:self.groupID] forKey:@"groupID"];
//                                [newGroup setObject:[NSNumber numberWithBool:self.isPublic] forKey:@"isPublic"];
                                [newGroup saveInBackgroundWithBlock:^(BOOL succeeded,NSError *error){
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"SucceesFul" message:@"Invitation sent " delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                        [alert show];
                                    });
                                }];
                            }
                            else{
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"User Already Invited" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                    [alert show];
                                });
                            }
                        }];

                    }
                }];
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"User not Exist" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                });
            }
        }];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    [self searchBar:searchBar activate:NO];
//    [self searchGroup:searchBar.text];
//    if([searchData count]>0){
//        [searchData removeAllObjects];
//    }
    [searchBar setShowsCancelButton:YES animated:YES];
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
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
