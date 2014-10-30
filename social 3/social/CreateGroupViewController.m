//
//  CreateGroupViewController.m
//  social
//
//  Created by Anindya on 7/20/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import "CreateGroupViewController.h"
#import "User.h"
#import "Utility.h"
#import "UIImage+Resize.h"
@interface CreateGroupViewController ()

@end

@implementation CreateGroupViewController

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
    isTextViewEmpty = TRUE;
    isPublic = _privacySwitch.isOn;
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelOperation)];

    self.navigationItem.leftBarButtonItem = cancel;
    //   self.navigationItem.leftBarButtonItem = cancel;
    //  self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:selectImage,create, nil];
    
    _groupNameTextView.delegate = self;
    _groupDescriptionTextView.delegate = self;
    [_privacySwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    // Do any additional setup after loading the view.
}

-(void)switchChange:(id)sender{
    UISwitch *groupTypeSwitch = (UISwitch*)sender;
    isPublic = groupTypeSwitch.isOn;
}
-(void)cancelOperation{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;{
    return [textField resignFirstResponder];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.textColor = [UIColor blackColor];
    textView.text = @"";
}

- (void)textViewDidChange:(UITextView *)textView{
    if([textView.text length]<=0){
        isTextViewEmpty = TRUE;
        textView.text = @"Description(optional)";
        textView.textColor = [UIColor lightGrayColor];
    }
    else{
        if(isTextViewEmpty){
            isTextViewEmpty = FALSE;
            textView.text = @"";
            textView.textColor = [UIColor blackColor];
        }
    }
}

-(IBAction)createGrouo:(id)sender{
    if([_groupNameTextView.text length]<=0){
        UIAlertView *error = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Group name required" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [error show];
    }
    else{
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupName = %@",_groupNameTextView.text];
        PFQuery *query = [PFQuery queryWithClassName:kGroup predicate:predicate];
        [query  countObjectsInBackgroundWithBlock:^(int  number, NSError *error){
            if(number <=0){
                PFQuery *query = [PFQuery queryWithClassName:kGroup];
                [query  countObjectsInBackgroundWithBlock:^(int  groupNumber, NSError *error){
                    //  groupCount = number;
                    
                    PFObject *newGroup = [PFObject objectWithClassName:kGroup];
                    [newGroup setObject:_groupNameTextView.text forKey:@"groupName"];
                    [newGroup setObject:[_groupNameTextView.text lowercaseString] forKey:@"groupNameLower"];
                    [newGroup setObject:[NSNumber numberWithInt:groupNumber+1]forKey:@"groupID"];
                    //[newGroup setObject:_groupDescriptionTextView.text forKey:@"groupDescription"];
                    [newGroup setObject:[NSNumber numberWithBool:isPublic] forKey:@"isPublic"];
                    if([imageData length]<=0){
                        UIImage *image = [UIImage imageNamed:@"default"];
                        imageData = UIImageJPEGRepresentation(image, 0.05f);
                    }
                    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
                    UIImage *thumbImage = [[UIImage alloc]initWithData:imageData];
                    thumbImage = [thumbImage thumbnailImage:50 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationMedium];
                    PFFile *thumbImageFile = [PFFile fileWithName:@"Imagethumb.jpg" data:UIImageJPEGRepresentation(thumbImage, 0.5)];
                    [newGroup setObject:imageFile forKey:@"groupPic"];
                    [newGroup setObject:thumbImageFile forKey:@"groupPicThumb"];
                    [newGroup saveInBackgroundWithBlock:^(BOOL success,NSError *error){
                        if(success){
                            [newGroup refreshInBackgroundWithBlock:^(PFObject *groupObject,NSError *errror){
                                [newGroup setObject:groupObject.objectId forKey:@"objectId"];
                                PFObject *newMember = [PFObject objectWithClassName:kMember];
                                newMember[@"groupInfo"] = newGroup;
                                PFObject *user = [PFUser currentUser];
                                
                                newMember[@"memberInfo"] = user;
                                // [newMember setObject:currentUser.userName forKey:@"userName"];
                                [newMember setObject:[NSNumber numberWithBool:TRUE] forKey:@"isCreator"];
                                [newMember setObject:[NSNumber numberWithBool:isPublic] forKey:@"isPublic"];
                                [newMember saveInBackgroundWithBlock:^(BOOL succedded,NSError*error){
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        UIAlertView *error = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Group created sucessfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                                        [error show];
                                    });
                                }];
                            }];
                        }
                        else{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                UIAlertView *error = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Group with same name exist" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                                [error show];
                            });
                            
                        }
                    }];
                    
                }];
                
                
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *error = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Group with same name exist" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [error show];
                });
            }
        }];
        
        
    }
}

-(IBAction)selectImageLibrary:(id)sender{
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    imageData = UIImageJPEGRepresentation(image, 0);
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
