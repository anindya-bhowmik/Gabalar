//
//  GroupSettingViewController.m
//  social
//
//  Created by Anindya on 7/21/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import "GroupSettingViewController.h"
#import "Group.h"
#import "User.h"
#import "Utility.h"
#import "GroupMemberViewController.h"
#import "AddMemberViewController.h"
#import "GroupPhotoViewController.h"
@interface GroupSettingViewController ()

@end

@implementation GroupSettingViewController

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
    _groupProfilePic.image = self.group.groupProfileImage;
    if(self.group.isPublic){
        NSPredicate *groupPredicate = [NSPredicate predicateWithFormat:@"groupID= %d",self.group.groupID];
        PFQuery *groupQuery = [PFQuery queryWithClassName:kGroup predicate:groupPredicate];
        PFQuery *query = [PFQuery queryWithClassName:kMember];
        [query whereKey:@"groupInfo" matchesQuery:groupQuery];
        [query whereKey:@"memberInfo" equalTo:[PFUser currentUser]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects,NSError *error){
            if([objects count]>0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_joinLeaveBtn setTitle:@"Leave Group" forState:UIControlStateNormal];
                    _joinLeaveBtn.tag = LEAVETAG;
                    isMember = TRUE;
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_joinLeaveBtn setTitle:@"Join Group" forState:UIControlStateNormal];
                    _joinLeaveBtn.tag = JOINTAG;
                    isMember = FALSE;
                    _addMemberBtn.hidden = YES;
                });
            }
            
            
        }];
    }
    else{
        [_joinLeaveBtn setTitle:@"Leave Group" forState:UIControlStateNormal];
        _joinLeaveBtn.tag = LEAVETAG;
        isMember = TRUE;
    }
    // Do any additional setup after loading the view.
}
- (IBAction)joinLeaveBtnAction:(id)sender {
    UIButton *btn = (UIButton*)sender;
    if(btn.tag == LEAVETAG){
        PFUser *currentUser = [PFUser currentUser];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_id = %d",[currentUser[@"user_id"]intValue]];
        PFQuery *userQuery = [PFQuery queryWithClassName:kUSER predicate:predicate];
        NSPredicate *groupPredicate = [NSPredicate predicateWithFormat:@"groupID= %d",self.group.groupID];
        PFQuery *grpQuery = [PFQuery queryWithClassName:kGroup predicate:groupPredicate];
        // NSPredicate *finalPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:predicate,groupPredicate, nil]];
        PFQuery *query = [PFQuery queryWithClassName:kMember];
        [query whereKey:@"groupInfo" matchesQuery:grpQuery];
        [query whereKey:@"memberInfo" matchesQuery:userQuery];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                NSLog(@"Successfully retrieved %d scores.", objects.count);
                // Do something with the found objects
                for (PFObject *object in objects) {
                    [object deleteInBackgroundWithBlock:^(BOOL succeeded,NSError *error){
                        [_joinLeaveBtn setTitle:@"Join Group" forState:UIControlStateNormal];
                        _joinLeaveBtn.tag = JOINTAG;
                        isMember = FALSE;
                        _addMemberBtn.hidden = YES;
                    }];
                }
            }
            
        }];
    }
    else{
        PFObject *newMember = [PFObject objectWithClassName:kMember];
        //[newMember setObject:[NSNumber numberWithInt:self.group.groupID] forKey:@"groupID"];
        //        User *currentUser = [[Utility getInstance]getCurrentUser];
        //        PFObject *user = [PFObject objectWithClassName:kUSER];
        //        user.objectId = currentUser.objectID;
        PFObject *grp = [PFObject objectWithClassName:kGroup];
        grp.objectId = self.group.groupObjectID;
        newMember[@"groupInfo"] = grp;
        newMember[@"memberInfo"] = [PFUser currentUser];
        //        [newMember setObject:[NSNumber numberWithInt:currentUser.userId] forKey:@"userID"];
        //        [newMember setObject:currentUser.userName forKey:@"userName"];
        [newMember setObject:[NSNumber numberWithBool:FALSE] forKey:@"isCreator"];
        [newMember setObject:[NSNumber numberWithBool:self.group.isPublic] forKey:@"isPublic"];
        [newMember saveInBackgroundWithBlock:^(BOOL succedded,NSError*error){
            [_joinLeaveBtn setTitle:@"Leave Group" forState:UIControlStateNormal];
            _joinLeaveBtn.tag = LEAVETAG;
            isMember = TRUE;
            _addMemberBtn.hidden = NO;
        }];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showMembers:(id)sender {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GroupMemberViewController *mainVc = [storyBoard instantiateViewControllerWithIdentifier:@"GroupMember"];
    mainVc.groupId = self.group.groupID;
    [self.navigationController pushViewController:mainVc animated:YES];
}
- (IBAction)showGroupPhotos:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GroupPhotoViewController *mainVc = [storyBoard instantiateViewControllerWithIdentifier:@"GroupPhoto"];
    mainVc.groupName = self.group.groupName;
    [self.navigationController pushViewController:mainVc animated:YES];
}
- (IBAction)showGroupVideos:(id)sender {
}
- (IBAction)addMember:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddMemberViewController *mainVc = [storyBoard instantiateViewControllerWithIdentifier:@"AddMember"];
    mainVc.group = self.group;
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
