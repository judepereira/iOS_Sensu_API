//
//  EventViewController.h
//  SensuAPI
//
//  Created by Golan's Mac on 1/18/15.
//  Copyright (c) 2015 AppsFlyer. All rights reserved.
//

#import <UIKit/UIKit.h>


@class EventObjectMapper;

@interface EventViewController : UIViewController 

@property (nonatomic, strong) EventObjectMapper *event;
@property (nonatomic, strong) IBOutlet UILabel *eventTitle;
@property (nonatomic, strong) IBOutlet UILabel *eventHistory;
@property (nonatomic, strong) IBOutlet UILabel *occurances;
@property (nonatomic, strong) IBOutlet UILabel *eventName;
@property (nonatomic, strong) IBOutlet UILabel *eventExecutionDate;
@property (nonatomic, strong) IBOutlet UILabel *eventIssuedDate;
@property (nonatomic, strong) IBOutlet UILabel *handlers;
@property (nonatomic, strong) IBOutlet UIImageView *statusIv;


-(IBAction)onMute:(id)sender;
-(IBAction)onResolve:(id)sender;

@end
