//
//  GroupSettingViewController.h
//  social
//
//  Created by Anindya on 7/21/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import <UIKit/UIKit.h>
#define JOINTAG  0
#define LEAVETAG 1
#define DELETETAG 2

@class Group;
@interface GroupSettingViewController : UIViewController{
    BOOL isMember;
}
@property (strong, nonatomic) IBOutlet UIButton *joinLeaveBtn;
@property (strong, nonatomic) IBOutlet UIButton *addMemberBtn;
@property (weak, nonatomic) IBOutlet UIImageView *groupProfilePic;
@property (nonatomic,strong) Group *group;

@end
