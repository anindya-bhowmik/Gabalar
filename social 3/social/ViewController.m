//
//  ViewController.m
//  social
//
//  Created by Anindya on 6/21/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import "MainViewController.h"
#import "Utility.h"
#import "User.h"
#import "AppDelegate.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    userNameField.delegate = self;
    passwordField.delegate = self;
//    if([PFUser currentUser] != nil){
//       // ViewController *vc =[[ViewController alloc]init];
//        [self loadMainView];
//    }

    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)loginAction:(id)sender {
    [PFUser logInWithUsernameInBackground:userNameField.text password:passwordField.text block:^(PFUser *user,NSError *error){
        if(user){
           
          //  PFObject *obj = [objects objectAtIndex:0];
            User *currentuser = [[User alloc]init];
            currentuser.userId = [user[@"user_id"]intValue];//[[obj valueForKey:@"user_id"]intValue];
            currentuser.userName = user.username;
            currentuser.objectID = user.objectId;//[obj valueForKey:@"objectId"];
            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            [currentInstallation setObject:currentuser.userName forKey:@"userName"];
            [currentInstallation setDeviceToken:currentInstallation.deviceToken];
            [currentInstallation saveInBackground];

            dispatch_async(dispatch_get_main_queue(), ^{
                //[self loadMainView];
                AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                [appDelegate loadMainView];
                // [self.navigationController pushViewController:mainVc animated:YES];
            });
            
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *message = [error.userInfo valueForKey:@"error"];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            });
        }
    
    }];
//    NS[]Predicate *userIDPredicate = [NSPredicate predicateWithFormat:
//                              @"Name = %@",userNameField.text];
//    NSPredicate *passwordPredicate = [NSPredicate predicateWithFormat:@"Password = %@",passwordField.text];
//    NSArray *predicateArray = [NSArray arrayWithObjects:userIDPredicate,passwordPredicate,nil];
//    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateArray];
//    PFQuery *query = [PFQuery queryWithClassName:@"UserInfo" predicate:predicate];
//     [query countObjectsInBackgroundWithBlock:^(int  number, NSError *error) {
//        if(!error){
//            if(number ==1){
//                
//                PFQuery *getUser = [PFQuery queryWithClassName:kUSER predicate:predicate];
//                [getUser findObjectsInBackgroundWithBlock:^(NSArray *objects,NSError*error){
//                    PFObject *obj = [objects objectAtIndex:0];
//                    User *user = [[User alloc]init];
//                    user.userId = [[obj valueForKey:@"user_id"]intValue];
//                    user.userName = [obj valueForKey:@"Name"];
//                    user.objectID = [obj valueForKey:@"objectId"];
//                    [[Utility getInstance]setCurrentUser:user];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                        
//                        MainViewController *mainVc = [storyBoard instantiateViewControllerWithIdentifier:@"Main"];
//                        [self presentViewController:mainVc animated:YES completion:Nil];
//                       // [self.navigationController pushViewController:mainVc animated:YES];
//                    });
//
//                
//                } ];
//                           }
//            else{
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Invalid username/password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//                    [alert show];
//                });
//            }
//        }
//    }];
         // [self.navigationController presentViewController:mainVc animated:YES completion:nil];
}
- (IBAction)retrievePasswod:(id)sender {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please enter your email address!" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;

                [alert show];
        });
    
}
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    if (buttonIndex == 1) {
        UITextField *title = [alertView textFieldAtIndex:0];
        [PFUser requestPasswordResetForEmailInBackground:title.text block:^(BOOL suceeded,NSError*error){
            if(suceeded){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Send" message:@"A link to reset your password has been sent to your registered email address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
               // alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                
                [alert show];
            });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                     NSString *message = [error.userInfo valueForKey:@"error"];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 //   alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                    
                    [alert show];
                });
            }

        }];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}
@end
