//
//  ChecksObjectMapper.h
//  SensuAPI
//
//  Created by Golan's Mac on 1/18/15.
//  Copyright (c) 2015 AppsFlyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restkit.h"

@interface ChecksObjectMapper : NSObject

@property (nonatomic, copy) NSArray *handlers;
@property (nonatomic, copy) NSString *command;
@property NSInteger interval;
@property NSInteger occurrences;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray *subscribers;

+(RKMapping *) mappingForObject;

@end
