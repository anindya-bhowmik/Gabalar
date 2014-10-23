//
//  CreateNetworkViewController.m
//  social
//
//  Created by Anindya on 6/23/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import "CreateNetworkViewController.h"
#import "Group.h"
#import "Utility.h"
#import "User.h"
@interface CreateNetworkViewController ()

@end

@implementation CreateNetworkViewController

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
    // Do any additional setup after loading the view.
    group = [[Group alloc]init];
    _nameField.delegate = self;
    _descriptionField.delegate = self;
    isPublic = TRUE;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];
   // [singleTap release];

    
}

-(void)createRadioButton{
//    NSMutableArray* buttons = [NSMutableArray arrayWithCapacity:3];
//	CGRect btnRect = CGRectMake(25, 320, 100, 30);
//	for (NSString* optionTitle in @[@"Red", @"Green", @"Blue"]) {
//		RadioButton* btn = [[RadioButton alloc] initWithFrame:btnRect];
//		[btn addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
//		btnRect.origin.y += 40;
//		[btn setTitle:optionTitle forState:UIControlStateNormal];
//		[btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//		btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
//		[btn setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
//		[btn setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
//		btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//		btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
//		[self.view addSubview:btn];
//		[buttons addObject:btn];
//	}
//	
//	[buttons[0] setGroupButtons:buttons]; // Setting buttons into the group
//	
//	[buttons[0] setSelected:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)privateBtnAction:(id)sender{
    isPublic = FALSE;
}

- (IBAction)publicBtnAction:(id)sender{
    isPublic = TRUE;

}
- (IBAction)createGroupBtnAction:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:kGroup];
    [query  countObjectsInBackgroundWithBlock:^(int  number, NSError *error){
    if(number <=0){
        PFObject *newGroup = [PFObject objectWithClassName:kGroup];
        [newGroup setObject:_nameField.text forKey:@"groupName"];
        [newGroup setObject:[NSNumber numberWithInt:number+1]forKey:@"groupID"];
        [newGroup setObject:_descriptionField.text forKey:@"groupDescription"];
        [newGroup setObject:[NSNumber numberWithBool:isPublic] forKey:@"isPublic"];
        PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
        [newGroup setObject:imageFile forKey:@"groupPic"];
        [newGroup saveInBackgroundWithBlock:^(BOOL success,NSError *error){
            
        }];
        PFObject *newMember = [PFObject objectWithClassName:kMember];
        [newMember setObject:[NSNumber numberWithInt:number+1] forKey:@"groupID"];
        User *currentUser = [[Utility getInstance]getCurrentUser];
        [newMember setObject:[NSNumber numberWithInt:currentUser.userId] forKey:@"userID"];
        [newMember setObject:[NSNumber numberWithBool:TRUE] forKey:@"isCreator"];
        [newMember setObject:[NSNumber numberWithBool:isPublic] forKey:@"isPublic"];
        [newMember saveInBackgroundWithBlock:^(BOOL succedded,NSError*error){}];
        // [newGroup setObject:]
    }
    }];
}
- (IBAction)selectImageSource:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Select ImageSource" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:@"Library",@"Camera", nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self loadImagePicker:buttonIndex];

}

-(void)loadImagePicker:(int)index {
    NSLog(@"Send Button Pressed");
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
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


-(void)textViewDidBeginEditing:(UITextView *)textView{
    currentResponder = textView;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;{
    return [textField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    currentResponder = textField;
}

- (void)resignOnTap:(id)iSender {
    [currentResponder resignFirstResponder];
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
