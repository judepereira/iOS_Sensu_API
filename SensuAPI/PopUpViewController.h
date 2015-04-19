//
//  PopUpViewController.h
//  SensuAPI
//
//  Created by Golan's Mac on 1/19/15.
//  Copyright (c) 2015 AppsFlyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopUpViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UITextField *reasonTF;
@property (weak, nonatomic) IBOutlet UISegmentedControl *expirationSC;

- (void)showInView:(UIView *)aView animated:(BOOL)animated complitionBlock:(void (^)(NSDictionary *stashParams))aComplitionBlock;
- (IBAction)valueChanged:(id)sender;

@end