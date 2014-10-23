//
//  Utility.h
//  social
//
//  Created by Anindya on 7/14/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@interface Utility : NSObject{
    User *currentUser;
}

@property (nonatomic,assign)CGFloat deviceWidth;
@property (nonatomic,assign)CGFloat deviceHeight;
+(Utility*)getInstance;
-(void)setCurrentUser:(User*)user;
-(User*)getCurrentUser;
@end
