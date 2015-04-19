//
//  EventObjectMapper.h
//  SensuAPI
//
//  Created by Golan's Mac on 1/18/15.
//  Copyright (c) 2015 AppsFlyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restkit.h"

@interface EventObjectMapper : NSObject

@property (nonatomic, copy) NSString *eventId;
@property (nonatomic, copy) NSDictionary *client;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSDictionary *check;
@property NSInteger occurrences;

+(RKMapping *) mappingForObject;

@end
