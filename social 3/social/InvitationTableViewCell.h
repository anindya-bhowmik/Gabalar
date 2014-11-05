//
//  InvitationTableViewCell.h
//  social
//
//  Created by user on 11/5/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvitationTableViewCell : PFTableViewCell


@property (strong, nonatomic) IBOutlet PFImageView *userPic;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UIButton *sendInvitationBtn;
@end
