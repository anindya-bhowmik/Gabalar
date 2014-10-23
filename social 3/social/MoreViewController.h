//
//  MoreViewController.h
//  social
//
//  Created by Anindya on 7/17/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreViewController : UITableViewController<UIActionSheetDelegate>{
    UIView *disableViewOverlay;
    NSMutableArray *tableData;
    NSMutableArray *searchData;
    NSData *imageData;
//    UISearchBar *searchBar;
//    UISearchDisplayController *searchBarController;

}

@end
