//
//  ClientObjectMapper.h
//  SensuAPI
//
//  Created by Golan's Mac on 1/20/15.
//  Copyright (c) 2015 AppsFlyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "restkit.h"

@interface ClientObjectMapper : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSArray *subscriptions;
@property (nonatomic, copy) NSString *version;
@property NSTimeInterval timestamp;

+(RKMapping *) mappingForObject;

@end
