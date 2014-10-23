//
//  ImageViewController.h
//  social
//
//  Created by Anindya on 8/9/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController
@property (nonatomic,strong) PFFile *imageFile;
@property (strong, nonatomic) IBOutlet PFImageView *imageView;

@end
