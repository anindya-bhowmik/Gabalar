//
//  GroupPhotoViewController.h
//  social
//
//  Created by Anindya on 8/9/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupImageCell.h"
@interface GroupPhotoViewController : UIViewController{
    NSArray *imageFilesArray;
    NSMutableArray *imageArray;
}
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollection;
@property (nonatomic,strong)NSString *groupName;
@end
