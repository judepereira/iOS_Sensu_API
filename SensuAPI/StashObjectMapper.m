//
//  StashObjectMapper.m
//  SensuAPI
//
//  Created by Golan's Mac on 1/20/15.
//  Copyright (c) 2015 AppsFlyer. All rights reserved.
//

#import "StashObjectMapper.h"

@implementation StashObjectMapper

+(RKMapping *) mappingForObject {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"path"       :  @"path",
                                                  @"content"    :  @"content",
                                                  @"expire"     :  @"expire"
                                                  }];
    
    return mapping;
}


@end
