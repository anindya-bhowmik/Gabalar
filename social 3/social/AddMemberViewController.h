//
//  AddMemberViewController.h
//  social
//
//  Created by Anindya on 7/23/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Group;
@interface AddMemberViewController : UIViewController<UISearchDisplayDelegate>{
    NSMutableArray *searchData;
}
@property (weak, nonatomic) IBOutlet UITextField *memberNameField;
@property (nonatomic,strong)Group *group;
@end
