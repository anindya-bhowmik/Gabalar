//
//  CreateNetworkViewController.h
//  social
//
//  Created by Anindya on 6/23/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Group;
@interface CreateNetworkViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>{
    Group *group;
    id currentResponder;
    BOOL isPublic;
    NSData *imageData;
}
- (IBAction)privateBtnAction:(id)sender;

- (IBAction)publicBtnAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *radioButtonView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;
@end
