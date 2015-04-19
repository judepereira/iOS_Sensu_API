//
//  StashObjectMapper.h
//  SensuAPI
//
//  Created by Golan's Mac on 1/20/15.
//  Copyright (c) 2015 AppsFlyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restkit.h"

@interface StashObjectMapper : NSObject

@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSDictionary *content;
@property NSInteger expire;

+(RKMapping *) mappingForObject;

@end
