//
//  Utils.h
//  SensuAPI
//
//  Created by Golan's Mac on 1/29/15.
//  Copyright (c) 2015 AppsFlyer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (NSDateFormatter*)customDateFormatter;
+ (void) deleteCredentials;

+ (NSString *) getUsername;
+ (NSString *) getPassword;
+ (NSString *) getSensuServer;


@end
