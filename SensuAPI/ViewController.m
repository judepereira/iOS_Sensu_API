//
//  ViewController.m
//  SensuAPI
//
//  Created by Golan's Mac on 1/18/15.
//  Copyright (c) 2015 AppsFlyer. All rights reserved.
//

#import "ViewController.h"
#import "Restkit.h"
#import "ChecksObjectMapper.h"
#import "EventObjectMapper.h"
#import "EventTableViewCell.h"
#import "EventViewController.h"
#import "SVPullToRefresh/SVPullToRefresh.h"
#import "Utils.h"
#import "Defines.h"

@interface ViewController () {
    
    NSArray *events;
}

@end

@implementation ViewController

- (void)getEvents {
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[EventObjectMapper mappingForObject] method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
   
    NSURL *url = [NSURL URLWithString:[Utils getSensuServer]];
    NSString *username = [Utils getUsername];
    NSString *password = [Utils getPassword];

    RKObjectManager* objectManager = [RKObjectManager managerWithBaseURL:url];
    [objectManager.HTTPClient setAuthorizationHeaderWithUsername:username password:password];
    
    NSURLRequest *request = [objectManager requestWithObject:nil method:RKRequestMethodGET path:@"events" parameters:nil];

    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];


    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        NSLog(@"Events: %@", [result array]);
        [self resolveChecksResponse:[result array]];
        [self.tableView.pullToRefreshView stopAnimating];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"mapping results error: %@", error);
        [self.tableView.pullToRefreshView stopAnimating];
        if (operation.HTTPRequestOperation.response.statusCode == 401) {
            //display alert view
            [Utils deleteCredentials];
            
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"login error" message:@"Bad credentials" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [av show];
        }
    }];
    
    [objectRequestOperation start];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:15/255.f green:124/255.f blue:198/255.f alpha:1]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EventTableViewCell" bundle:nil] forCellReuseIdentifier:@"EventTableViewCell"];
   
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIEdgeInsets insets = self.tableView.contentInset;
        insets.top = self.navigationController.navigationBar.bounds.size.height +
        [UIApplication sharedApplication].statusBarFrame.size.height;
        insets.bottom = self.tabBarController.tabBar.frame.size.height;
        self.tableView.contentInset = insets;
        self.tableView.scrollIndicatorInsets = insets;
    }
    
    __typeof (&*self) __weak weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        // prepend data to dataSource, insert cells at top of table view
        [weakSelf getEvents];

    }];
    
    [self.tableView triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) resolveChecksResponse:(NSArray *) results {

    EventObjectMapper *obj = [results firstObject];
    NSLog(@"obj check = %@, action = %@ client = %@ occurrences = %ld, id = %@ ", obj.check, obj.action, obj.client, (long)obj.occurrences, obj.eventId);
    
    events = [results sortedArrayUsingComparator: ^(EventObjectMapper *obj1, EventObjectMapper *obj2) {
        return [obj1.check[@"status"] compare:obj2.check[@"status"]];
    }];

    
    
    self.title = [NSString stringWithFormat:@"Events (%lu)", (unsigned long)events.count];
    [self.tableView reloadData];
    
    
}

#pragma mark uitableviewdelegate

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return events.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *cellIdentifier = @"EventTableViewCell";
    
    EventObjectMapper *event =  [events objectAtIndex:indexPath.row];
    
    EventTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UIView *customColorView = [[UIView alloc] init];
    customColorView.backgroundColor = [UIColor colorWithRed:15/255.0
                                                      green:124/255.0
                                                       blue:198/255.0
                                                      alpha:0.75];
    cell.selectedBackgroundView =  customColorView;
    
    
    cell.backgroundColor = [UIColor clearColor];
    cell.eventIdLabel.text = event.check[@"name"];
    
    NSNumber *numStatus = event.check[@"status"];
    
    
    switch (numStatus.integerValue) {
        default:
        case 0:
            [cell.eventIcon setImage:[UIImage imageNamed:@"greenV"]];
            cell.eventIdLabel.textColor = [UIColor blackColor];

            break;
        case 1:
            [cell.eventIcon setImage:[UIImage imageNamed:@"warning_icon"]];
            cell.eventIdLabel.textColor = [UIColor blackColor];
            break;
        case 2:
            [cell.eventIcon setImage:[UIImage imageNamed:@"error_icon"]];
            cell.eventIdLabel.textColor = [UIColor redColor];

            break;
    }

    return cell;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EventObjectMapper *event = [events objectAtIndex:indexPath.row];
    
    EventViewController *eventVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EventDetails"];
    
    [eventVC setEvent:event];
    [self.navigationController pushViewController:eventVC animated:YES];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
}

@end
