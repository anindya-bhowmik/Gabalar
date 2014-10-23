//
//  ActivityIndicator.m
//  social
//
//  Created by Anindya on 7/11/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import "ActivityIndicator.h"

@implementation ActivityIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIActivityIndicatorView *activityIndicatior = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self addSubview:activityIndicatior];
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
