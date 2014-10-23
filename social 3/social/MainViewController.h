//
//  MainViewController.h
//  social
//
//  Created by Anindya on 6/23/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainViewController : UITabBarController{
    BOOL isSearchButtonPressed;
    UIView *disableViewOverlay;
    NSMutableArray *tableData;

}
@property (strong, nonatomic) IBOutlet UITabBar *tabBar;

@end
