//
//  EventObjectMapper.m
//  SensuAPI
//
//  Created by Golan's Mac on 1/18/15.
//  Copyright (c) 2015 AppsFlyer. All rights reserved.
//

#import "EventObjectMapper.h"

@implementation EventObjectMapper

+(RKMapping *) mappingForObject {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"id"   :  @"eventId",
                                                  @"client"    :  @"client",
                                                  @"check"   :  @"check",
                                                  @"occurrences":  @"occurrences",
                                                  @"action"       :  @"action"
                                                  }];
    
    return mapping;
}

@end
