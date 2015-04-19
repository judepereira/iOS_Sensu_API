//
//  LoginViewController.h
//  SensuAPI
//
//  Created by Golan's Mac on 2/4/15.
//  Copyright (c) 2015 AppsFlyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *tfSensuServer;
@property (weak, nonatomic) IBOutlet UITextField *tfUsername;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

-(IBAction)login:(id)sender;


@end
