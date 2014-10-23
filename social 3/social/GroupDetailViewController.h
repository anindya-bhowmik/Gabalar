//
//  GroupDetailViewController.h
//  social
//
//  Created by Anindya on 7/20/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@class Group;
@interface GroupDetailViewController : PFQueryTableViewController{
    UIImage *groupImage;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *groupImageView;
@property(strong,nonatomic)Group *group;

@end
