//
//  PublicGroupViewController.h
//  social
//
//  Created by Anindya on 6/23/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupCell;
@interface PublicGroupViewController : PFQueryTableViewController<UISearchDisplayDelegate,UITableViewDataSource>{
    UIView *disableViewOverlay;
    NSMutableArray *searchData;
    BOOL isSearchButonPressed;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *descriptionLabel;
    GroupCell *cell;
    UITableViewCell *cell1;
}

@end
