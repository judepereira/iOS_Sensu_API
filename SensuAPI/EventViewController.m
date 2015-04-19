//
//  EventViewController.m
//  SensuAPI
//
//  Created by Golan's Mac on 1/18/15.
//  Copyright (c) 2015 AppsFlyer. All rights reserved.
//

#import "EventViewController.h"
#import "EventObjectMapper.h"
#import "PopUpViewController.h"
#import "Utils.h"

@interface EventViewController () {
    PopUpViewController *popup;
}

@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.eventTitle.text = self.event.client[@"name"];
    self.occurances.text = [NSString stringWithFormat:@"%ld", (long)self.event.occurrences];
    self.eventName.text = self.event.check[@"name"];
   
    NSNumber *execTimeinterval =  self.event.check[@"executed"];
    NSDate *execDate = [NSDate dateWithTimeIntervalSince1970:[execTimeinterval doubleValue]];
    
    self.eventExecutionDate.text = [[Utils customDateFormatter] stringFromDate:execDate];
    
    NSNumber *issuedTimeinterval =  self.event.check[@"issued"];
    NSDate *issuedDate = [NSDate dateWithTimeIntervalSince1970:[issuedTimeinterval doubleValue]];

    self.eventIssuedDate.text = [[Utils customDateFormatter] stringFromDate:issuedDate];
    
    NSArray *arrHistory = self.event.check[@"history"];
    NSString *hist = [[NSString alloc] init];
    for (int i = 0; i < arrHistory.count; ++i) {
        NSString *str = arrHistory[i];
        hist = [hist stringByAppendingFormat:@"%@, ",str];
    }
    self.eventHistory.text = hist;
    
    
    NSArray *arrHandlers = self.event.check[@"handlers"];
    NSString *handelers = [[NSString alloc] init];
    for (int i = 0; i < arrHandlers.count; ++i) {
        NSString *str = arrHandlers[i];
        handelers = [handelers stringByAppendingFormat:@"%@, ",str];
    }
    self.handlers.text = handelers;

    
    NSNumber *numStatus = self.event.check[@"status"];

    switch (numStatus.integerValue) {
        default:
        case 0:
            [self.statusIv setImage:[UIImage imageNamed:@"greenV"]];

            break;
        case 1:
            [self.statusIv setImage:[UIImage imageNamed:@"warning_icon"]];
            break;
        case 2:
            [self.statusIv setImage:[UIImage imageNamed:@"error_icon"]];
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void) resolveChecksResponse:(NSArray *) results {
    
    EventObjectMapper *obj = [results firstObject];
    NSLog(@"obj check = %@, action = %@ client = %@ occurrences = %ld, id = %@ ", obj.check, obj.action, obj.client, (long)obj.occurrences, obj.eventId);
}


-(IBAction)onMute:(id)sender {
    
}

-(IBAction)onResolve:(id)sender {
    
    popup = [[PopUpViewController alloc] initWithNibName:@"PopUpViewController" bundle:nil];
    [popup showInView:self.view animated:YES complitionBlock:^(NSDictionary *stashParams) {
    
        NSLog(@"stash params = %@", stashParams);
    
        if (stashParams.count != 0)
            [self stashEvent:stashParams];
    }];

}

-(void) stashEvent:(NSDictionary *) parameters {
    
    
    NSNumber *expire = parameters[@"expire"];
    
    NSString *jsonString = [NSString stringWithFormat:@"{\"path\": \"silence/%@\",\"content\": {\"reason\": \"%@\" },\"expire\": %ld }",self.event.client[@"name"], parameters[@"reason"], (long)expire.integerValue];
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *params = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"paramas: %@", params);

    NSString *username = [Utils getUsername];
    NSString *password = [Utils getPassword];
    
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://sensu-20001.eu1.appsflyer.com:4567"]];
    
    [manager.HTTPClient setAuthorizationHeaderWithUsername:username password:password];

    [manager setRequestSerializationMIMEType:RKMIMETypeJSON];
    
    [manager postObject:nil path:@"/stashes" parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        NSLog(@"Resolve response: %@", [result array]);
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
        [self.navigationController popViewControllerAnimated:YES];

    }];
    
}




@end
