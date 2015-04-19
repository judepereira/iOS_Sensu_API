//
//  ClientDetailsViewController.m
//  SensuAPI
//
//  Created by Golan's Mac on 1/21/15.
//  Copyright (c) 2015 AppsFlyer. All rights reserved.
//

#import "ClientDetailsViewController.h"
#import "ClientObjectMapper.h"
#import "Utils.h"

@interface ClientDetailsViewController ()

@end

@implementation ClientDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.name.text = self.client.name;
    self.address.text = self.client.address;
    self.subs.text = [self.client.subscriptions objectAtIndex:0];
    self.version.text = self.client.version;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)onDelete:(id)sender {
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    NSString *username = [Utils getUsername];
    NSString *password = [Utils getPassword];
    
    [manager.HTTPClient setAuthorizationHeaderWithUsername:username password:password];

    [manager setRequestSerializationMIMEType:RKMIMETypeJSON];
    
    [manager deleteObject:nil path:[NSString stringWithFormat:@"/clients/%@", self.client.name] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        NSLog(@"Resolve response: %@", [result array]);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
    }];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
