//
//  CreateGroupViewController.h
//  social
//
//  Created by Anindya on 7/20/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateGroupViewController : UITableViewController<UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>{
    BOOL isTextViewEmpty;
    NSData *imageData;
    BOOL isPublic;

}
@property (weak, nonatomic) IBOutlet UITextField *groupNameTextView;
@property (weak, nonatomic) IBOutlet UITextView *groupDescriptionTextView;
@property (weak, nonatomic) IBOutlet UISwitch *privacySwitch;

@end
