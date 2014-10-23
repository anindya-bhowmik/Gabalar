//
//  FeedCell.h
//  social
//
//  Created by Anindya on 9/13/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import <Parse/Parse.h>

@interface FeedCell : PFTableViewCell
@property (strong, nonatomic) IBOutlet PFImageView *senderImageView;
@property (strong, nonatomic) IBOutlet UILabel *senderNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *feedLabel;
@property (strong, nonatomic) IBOutlet PFImageView *feedThumbImage;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
