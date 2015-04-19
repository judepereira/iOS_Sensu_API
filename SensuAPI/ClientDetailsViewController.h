//
//  ClientDetailsViewController.h
//  SensuAPI
//
//  Created by Golan's Mac on 1/21/15.
//  Copyright (c) 2015 AppsFlyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClientObjectMapper;

@interface ClientDetailsViewController : UIViewController

@property (nonatomic, strong) ClientObjectMapper *client;
@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *address;
@property (nonatomic, strong) IBOutlet UILabel *subs;
@property (nonatomic, strong) IBOutlet UILabel *version;


-(IBAction)onDelete:(id)sender;
@end
