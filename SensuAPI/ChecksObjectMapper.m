//
//  ChecksObjectMapper.m
//  SensuAPI
//
//  Created by Golan's Mac on 1/18/15.
//  Copyright (c) 2015 AppsFlyer. All rights reserved.
//

#import "ChecksObjectMapper.h"

@implementation ChecksObjectMapper


+(RKMapping *) mappingForObject {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"handlers"   :  @"handlers",
                                                  @"command"    :  @"command",
                                                  @"interval"   :  @"interval",
                                                  @"occurrences":  @"occurrences",
                                                  @"name"       :  @"name",
                                                  @"subscribers":  @"subscribers"
                                                  }];
    
    return mapping;
}


@end
