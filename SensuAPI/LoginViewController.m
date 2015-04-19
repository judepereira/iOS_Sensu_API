//
//  LoginViewController.m
//  SensuAPI
//
//  Created by Golan's Mac on 2/4/15.
//  Copyright (c) 2015 AppsFlyer. All rights reserved.
//

#import "LoginViewController.h"
#import "MainTabController.h"
#import "Utils.h"
#import "Defines.h"


static const int three_months = 3600 * 24 * 90;

@interface LoginViewController () <UITextFieldDelegate> {
    NSString *username;
    NSString *password;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   }

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    username = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUsername];
    password = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsPassword];
    
    NSDate *expire = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsLoginExpiration];
    
    if (expire != nil) {
        if ([expire timeIntervalSinceNow] <= 0) {
            //login session has expired, force login prompt.
            [Utils deleteCredentials];
            [_tfUsername becomeFirstResponder];
        }
        else if (username != nil && password != nil){
            [self login:nil];
        }
    }
    else {
        [self.tfUsername becomeFirstResponder];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)shouldEnableLogin {
    if (self.tfUsername.text.length > 0) {
        [_loginButton setEnabled:YES];
        [_loginButton setBackgroundColor:[UIColor colorWithRed:22/255.f green:125/255.f blue:197/255.f alpha:1]];
    }
    else {
        [_loginButton setEnabled:NO];
        [_loginButton setBackgroundColor:[UIColor colorWithRed:111/255.f green:113/255.f blue:121/255.f alpha:1]];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [self shouldEnableLogin];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self shouldEnableLogin];
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)login:(id)sender {
    MainTabController *mainTab = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"maintabar"];
    
    NSDate *expire = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsLoginExpiration];
    
    if (expire == nil) {
        // add 3 months
        expire = [NSDate dateWithTimeInterval:three_months sinceDate:[NSDate date]];
        [[NSUserDefaults standardUserDefaults] setObject:self.tfUsername.text forKey:kUserDefaultsUsername];
        [[NSUserDefaults standardUserDefaults] setObject:self.tfPassword.text forKey:kUserDefaultsPassword];
        [[NSUserDefaults standardUserDefaults] setObject:self.tfSensuServer.text forKey:kUserDefaultsSensuServer];
        [[NSUserDefaults standardUserDefaults] setObject:expire forKey:kUserDefaultsLoginExpiration];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self presentViewController:mainTab animated:YES completion:nil];
}



@end
