//
//  ClientObjectMapper.m
//  SensuAPI
//
//  Created by Golan's Mac on 1/20/15.
//  Copyright (c) 2015 AppsFlyer. All rights reserved.
//

#import "ClientObjectMapper.h"

@implementation ClientObjectMapper


+(RKMapping *) mappingForObject {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"name"           :  @"name",
                                                  @"address"        :  @"address",
                                                  @"subscriptions"  :  @"subscriptions",
                                                  @"version"        :  @"version",
                                                  @"timestamp"      :  @"timestamp"
                                                  }];
    
    return mapping;
}

@end
