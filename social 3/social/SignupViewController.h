//
//  SignupViewController.h
//  social
//
//  Created by Anindya on 6/21/14.
//  Copyright (c) 2014 Anindya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController<UITextFieldDelegate>{
    __weak IBOutlet UITextField *userNameTextField;
    __weak IBOutlet UITextField *cityTextField;
    
    __weak IBOutlet UITextField *emailTextField;
    __weak IBOutlet UITextField *passwordTextField;
    
    NSData *imageData;
}


@end
