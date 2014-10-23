//
//  HomeViewController.h
//  social
//
//  Created by Anindya on 6/23/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;
@class GroupCell;
@interface HomeViewController : PFQueryTableViewController{
    User *currentUser;
    NSMutableArray *groupID;
    
}

@end
