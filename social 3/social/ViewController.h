//
//  ViewController.h
//  social
//
//  Created by Anindya on 6/21/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>{

    __weak IBOutlet UITextField *passwordField;
    __weak IBOutlet UITextField *userNameField;
}

- (IBAction)loginAction:(id)sender;
-(void)loadMainView;
@end
