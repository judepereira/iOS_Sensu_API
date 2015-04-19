//
//  Utils.m
//  SensuAPI
//
//  Created by Golan's Mac on 1/29/15.
//  Copyright (c) 2015 AppsFlyer. All rights reserved.
//

#import "Utils.h"
#import "Defines.h"

@implementation Utils


+ (NSDateFormatter*)customDateFormatter
{
    static dispatch_once_t once;
    static NSDateFormatter *formatter;
    dispatch_once(&once, ^ {
        formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
    });
    return formatter;

}

+ (void) deleteCredentials {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kUserDefaultsLoginExpiration];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kUserDefaultsUsername];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kUserDefaultsPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *) getUsername {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUsername];
}

+ (NSString *) getPassword {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsPassword];
}

+ (NSString *) getSensuServer {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsSensuServer];
}


@end
