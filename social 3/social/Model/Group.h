//
//  Group.h
//  social
//
//  Created by Anindya on 7/12/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Group : NSObject
@property (nonatomic,strong)NSString *groupName;
@property (nonatomic,strong)NSString *groupDescription;
@property (nonatomic,assign)int groupType;
@property (nonatomic,assign)int groupID;
@property (nonatomic,strong)PFFile *groupImage;
@property (nonatomic,strong)UIImage *groupProfileImage;
@property (nonatomic,assign)BOOL isPublic;
@property (nonatomic,strong)NSString *groupObjectID;
@end
