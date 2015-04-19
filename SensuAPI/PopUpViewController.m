//
//  PopUpViewController.m
//  SensuAPI
//
//  Created by Golan's Mac on 1/19/15.
//  Copyright (c) 2015 AppsFlyer. All rights reserved.
//

#import "PopUpViewController.h"

static const int fifteen_minutes = 15*60;
static const int one_hour = 60*60;
static const int one_year = 60*60*24*365;

@interface PopUpViewController () {
    
    NSMutableDictionary *stashParameters;
}

@property (copy) void (^complitionBlock)(NSDictionary *params);

@end

@implementation PopUpViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];
    self.popUpView.layer.cornerRadius = 5;
    self.popUpView.layer.shadowOpacity = 0.8;
    self.popUpView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
    [_expirationSC addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    stashParameters = [NSMutableDictionary new];
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

- (IBAction)closePopup:(id)sender {
    [self removeAnimate];
}

-(IBAction)cancel:(id)sender {
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];

}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
            self.complitionBlock(stashParameters);
        }
    }];
}

- (void)showInView:(UIView *)aView animated:(BOOL)animated complitionBlock:(void (^)(NSDictionary *stashParams)) aComplitionBlock
{
    self.complitionBlock = aComplitionBlock;
    dispatch_async(dispatch_get_main_queue(), ^{
        [aView addSubview:self.view];
        if (animated) {
            [self showAnimate];
        }
    });
}

- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}

- (IBAction)valueChanged:(id)sender {
  
    NSInteger exp = 15*60;
    switch([_expirationSC selectedSegmentIndex])
    {
        case 0:
            exp = fifteen_minutes;
            break;
            
        case 1:
            exp = one_hour;
            break;
            
        case 2:
            exp = one_year;
            break;
            
        case 3:
            exp = -1;
        default:
            break;
    }
    
    [stashParameters setObject:[NSNumber numberWithInteger:exp] forKey:@"expire"];
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField {

    NSLog(@"text = %@", textField.text);
    [stashParameters setObject:textField.text forKey:@"reason"];
    
}

- (BOOL)textFieldShouldReturn:(UITextField*)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}
@end
