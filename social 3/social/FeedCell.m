//
//  FeedCell.m
//  social
//
//  Created by Anindya on 9/13/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import "FeedCell.h"

@implementation FeedCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.senderImageView = [[PFImageView alloc]init];
        self.senderImageView.frame = CGRectMake(8, 7, 80, 80);
        [self.contentView addSubview:self.senderImageView];
        self.senderNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(97, 7, 218, 25)];
        [self.senderNameLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [self.contentView addSubview:self.senderNameLabel];
        
        self.feedLabel = [[UILabel alloc] init ];//WithFrame:CGRectMake(8.0, 8.0, self.frame.size.width, self.frame.size.height - 16.0)];
        
        // Configure Main Label
        
        [self.feedLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [self.feedLabel setTextAlignment:NSTextAlignmentLeft];
        // Add Main Label to Content View
        [self.contentView addSubview:self.feedLabel];
        self.feedThumbImage = [[PFImageView alloc]init];
        [self.contentView addSubview:self.feedThumbImage];
        
    
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
