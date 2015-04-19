//
//  EventTableViewCell.h
//  SensuAPI
//
//  Created by Golan's Mac on 1/18/15.
//  Copyright (c) 2015 AppsFlyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *eventIdLabel;
@property (nonatomic, strong) IBOutlet UIImageView *eventIcon;
@end
