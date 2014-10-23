//
//  GroupCell.h
//  social
//
//  Created by Anindya on 9/14/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import <Parse/Parse.h>

@interface GroupCell : PFTableViewCell

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet PFImageView *groupPic;

@end
