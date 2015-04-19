//
//  ClientsViewController.m
//  SensuAPI
//
//  Created by Golan's Mac on 1/20/15.
//  Copyright (c) 2015 AppsFlyer. All rights reserved.
//

#import "ClientsViewController.h"
#import "restkit.h"
#import "ClientObjectMapper.h"
#import "SVPullToRefresh/SVPullToRefresh.h"
#import "ClientDetailsViewController.h"
#import "SWTableViewCell.h"
#import "Utils.h"

@interface ClientsViewController () <SWTableViewCellDelegate>{
    NSMutableArray *clients;
}

@end

@implementation ClientsViewController

- (void)getClients {
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[ClientObjectMapper mappingForObject] method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    
    NSURL *url = [NSURL URLWithString:[Utils getSensuServer]];
    NSString *username = [Utils getUsername];
    NSString *password = [Utils getPassword];
    
    RKObjectManager* objectManager = [RKObjectManager managerWithBaseURL:url];
    [objectManager.HTTPClient setAuthorizationHeaderWithUsername:username password:password];
    
    NSURLRequest *request = [objectManager requestWithObject:nil method:RKRequestMethodGET path:@"clients" parameters:nil];
    
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];

    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        NSLog(@"clients: %@", [result array]);
        [self resolveChecksResponse:[result array]];
        [self.tableView.pullToRefreshView stopAnimating];

        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"mapping results error: %@", error);
        [self.tableView.pullToRefreshView stopAnimating];
    }];
    
    [operation start];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:15/255.f green:124/255.f blue:198/255.f alpha:1]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};

    [self.tableView registerNib:[UINib nibWithNibName:@"ClientTableViewCell" bundle:nil] forCellReuseIdentifier:@"ClientsTableViewCell"];
    
    
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
        // call [tableView.pullToRefreshView stopAnimating] when done
        [weakSelf getClients];
        
    }];
    
    [self.tableView triggerPullToRefresh];

}

-(void) resolveChecksResponse:(NSArray *) results {
    
    clients = [NSMutableArray arrayWithArray:results];

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    self.title = [NSString stringWithFormat:@"Clients (%lu)", (unsigned long)clients.count];

    return clients.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ClientsTableViewCell";
    
    ClientObjectMapper *obj = [clients objectAtIndex:indexPath.row];

    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    cell.textLabel.font = [UIFont systemFontOfSize:12];

    cell.textLabel.text = obj.name;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    ClientObjectMapper *client = [clients objectAtIndex:indexPath.row];
    
    ClientDetailsViewController *clientVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ClientDetails"];
    
    [clientVC setClient:client];
    [self.navigationController pushViewController:clientVC animated:YES];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    
    return NO;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}


-(void)deleteClient:(ClientObjectMapper *) aClient {
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    NSString *username = [Utils getUsername];
    NSString *password = [Utils getPassword];
    
    [manager.HTTPClient setAuthorizationHeaderWithUsername:username password:password];

    [manager setRequestSerializationMIMEType:RKMIMETypeJSON];
    
    [manager deleteObject:nil path:[NSString stringWithFormat:@"/clients/%@", aClient.name] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        NSLog(@"Resolve response: %@", [result array]);
        [self.tableView reloadData];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
    }];
    
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
       [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete Client"];
    
    return rightUtilityButtons;
}


#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            NSLog(@"check button was pressed");
            break;
        case 1:
            NSLog(@"clock button was pressed");
            break;
        case 2:
            NSLog(@"cross button was pressed");
            break;
        case 3:
            NSLog(@"list button was pressed");
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
            NSLog(@"Stash button was pressed");
            break;
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            // Delete the row from the data source
            ClientObjectMapper *clientToDelete = [clients objectAtIndex:cellIndexPath.row];
            [clients removeObject:clientToDelete];
            [self deleteClient:clientToDelete];
            
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        default:
            break;
    }
}

@end
