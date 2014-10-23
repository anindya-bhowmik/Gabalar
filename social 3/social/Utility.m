//
//  Utility.m
//  social
//
//  Created by Anindya on 7/14/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import "Utility.h"
#import "User.h"

@implementation Utility

static Utility *sharedInstance = nil;
+(Utility*)getInstance {
    @synchronized([Utility class]) {
        if (!sharedInstance)
            sharedInstance = [[self alloc] init];
        return sharedInstance;
    }
    return nil;
}

+(id)alloc{
    sharedInstance = [super alloc];
    return sharedInstance;
}

-(id)init{
    if(self = [super init]){
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        _deviceWidth = screenRect.size.width;
        _deviceHeight = screenRect.size.height;
        
    }
    return self;
}

-(void)setCurrentUser:(User*)user{
    currentUser = user;
}

-(User*)getCurrentUser{
    return currentUser;
}
@end
