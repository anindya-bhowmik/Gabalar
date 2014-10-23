//
//  SignupViewController.m
//  social
//
//  Created by Anindya on 6/21/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import "SignupViewController.h"
#import "MainViewController.h"
#import "User.h"
#import "AppDelegate.h"
#import "Utility.h"
@interface SignupViewController ()

@end

@implementation SignupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)signupAction:(id)sender {
   // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSPredicate *userIDPredicate = [NSPredicate predicateWithFormat:
                                    @"username = %@",userNameTextField.text];
    PFQuery *query = [PFQuery queryWithClassName:@"User" predicate:userIDPredicate];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects,NSError *error){
        if([objects count]<=0){
            PFQuery *query = [PFQuery queryWithClassName:@"User"];
            [query  countObjectsInBackgroundWithBlock:^(int  number, NSError *error){
                if(!error){
                    PFUser *newUser = [PFUser user];
                    newUser.username = userNameTextField.text;
                    newUser.password = passwordTextField.text;
                    newUser[@"city"] = cityTextField.text;
                    newUser[@"user_id"] = [NSNumber numberWithInt:number+1];
                    newUser.email = emailTextField.text;
                 //   newUser[@"emailVerified"] = [NSNumber numberWithBool:FALSE];
//                    PFObject *anotherPlayer = [PFObject objectWithClassName:@"_User"];//1;
//                    [anotherPlayer setObject:userNameTextField.text forKey:@"username"];
//                    [anotherPlayer setObject:passwordTextField.text forKey:@"password"];
//                    [anotherPlayer setObject:cityTextField.text forKey:@"city"];
//                    [anotherPlayer setValue:[NSNumber numberWithInt:number+1] forKey:@"user_id"];
//                    [anotherPlayer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded,NSError *error){
                        if (succeeded){
//                            NSLog(@"Object Uploaded!");
//                            User *user = [[User alloc]init];
//                            user.userId = number+1;
//                            user.userName = userNameTextField.text;
//                            user.objectID = newUser.objectId;
//                            [[Utility getInstance]setCurrentUser:user];
                            [PFUser logInWithUsernameInBackground:userNameTextField.text password:passwordTextField.text block:^(PFUser* user,NSError *error){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                                [appDelegate loadMainView];
//                                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                                
//                                MainViewController *mainVc = [storyBoard instantiateViewControllerWithIdentifier:@"Main"];
//                                [self presentViewController:mainVc animated:YES completion:nil];
                            });
                            }];
                        }
                        else{
                            NSString *errorString = [[error userInfo] objectForKey:@"error"];
                            NSLog(@"Error: %@", errorString);
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops" message:errorString delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                            [alert show];
                        }
                    }];
                }
            }];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Somebody's already nabbed that username! Please think of another!" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
                });
        }
    }];
     
}


-(BOOL)userExist{
    BOOL userNameAlreadyexist = FALSE;
    NSPredicate *userIDPredicate = [NSPredicate predicateWithFormat:
                                    @"Name = %@",userNameTextField.text];
    PFQuery *query = [PFQuery queryWithClassName:@"UserInfo" predicate:userIDPredicate];
    NSArray *objects = [query findObjects];
    if([objects  count]>0){
        userNameAlreadyexist = TRUE;
    }
    else if ([objects count]<=0){
        userNameAlreadyexist = FALSE;
    }
    return userNameAlreadyexist;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    userNameTextField.delegate = self;
    passwordTextField.delegate = self;
    cityTextField.delegate = self;
     UIBarButtonItem *selectImage = [[UIBarButtonItem alloc]initWithTitle:@"Select image" style:UIBarButtonItemStyleDone target:self action:@selector(selectImageLibrary)];
    self.navigationItem.rightBarButtonItem = selectImage;
    
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
    }
    else{
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    imageData = UIImageJPEGRepresentation(image, 0.05f);
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
