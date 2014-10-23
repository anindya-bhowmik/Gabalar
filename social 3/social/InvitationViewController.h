//
//  InvitationViewController.h
//  social
//
//  Created by user on 7/23/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InvitationViewController : PFQueryTableViewController<UINavigationControllerDelegate>{
    PFUser *currentUser;
}

@end
