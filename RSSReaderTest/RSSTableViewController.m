//
//  RSSTableViewController.m
//  RSSReaderTest
//
//  Created by VLAD on 27/06/2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import "RSSTableViewController.h"
#import "ChannelViewController.h"
#import "AddChannelViewController.h"
#import "UIViewController+Extension.h"
#import "CoreDataManager.h"


@interface RSSTableViewController () < AddChannelViewControllerDelegate >

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addChannelBarButton;

@property (strong, nonatomic) NSArray *channels;

@end

NSString * const openAppKeyPath = @"SecondOpenAppKey";

@implementation RSSTableViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [MagicalRecord setupAutoMigratingCoreDataStack];
        [self checkOpenAppKey];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    
    [self getViewAllRssChannels];
}

- (void) checkOpenAppKey {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:openAppKeyPath]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:openAppKeyPath];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[CoreDataManager sharedManager] addDefaultChannelsWithsuccessHandler:nil
                                                               andFailureHandler:nil];
    }
}

- (void) getViewAllRssChannels {
    
    self.channels =
    [[CoreDataManager sharedManager] getAllChannels];
    
    [self.tableView reloadData];
}

#pragma mark - AddRssChannelViewControllerDelegate

- (void) addChannelViewController: (AddChannelViewController *) addChannelViewController newChannelAdded: (NSString *) rssChannelTitle {
    
    [self getViewAllRssChannels];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.channels.count;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Channel *channel = [self.channels objectAtIndex:indexPath.row];
    
    [[CoreDataManager sharedManager] deleteRssChannel:channel
                                    successHandler:^{
                                        
                                        NSMutableArray *channels =
                                        [[NSMutableArray alloc] initWithArray:self.channels];
                                        
                                        [channels removeObjectAtIndex:indexPath.row];
                                        
                                        self.channels = channels;
                                        
                                        [self.tableView reloadData];
                                        
                                    } andFailureHandler:^(NSError *error) {
                                        
                                        NSLog(@"error: %@", error);
                                    }];
}


#pragma mark - UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NSLocalizedString(@"Delete", nil);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"defaultCell";
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    Channel *channel = [self.channels objectAtIndex:indexPath.row];
    
    cell.textLabel.text = channel.title;
    cell.detailTextLabel.text = channel.url;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Channel *channel = [self.channels objectAtIndex:indexPath.row];
    
    ChannelViewController *channelViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"ChannelViewController"];
    
    channelViewController.rssChannel = channel;
    
    [self.navigationController pushViewController:channelViewController animated:YES];
}

#pragma mark - Actions

- (IBAction)refreshChannels:(UIBarButtonItem *)sender {
    
    [[CoreDataManager sharedManager] addDefaultChannelsWithsuccessHandler:^{
        
        self.channels =
        [[CoreDataManager sharedManager] getAllChannels];
        
        [self.tableView reloadData];
        
    } andFailureHandler:^(NSError *error) {
        
        NSLog(@"error: %@", error);
    }];
    
}


- (IBAction)addChannelBarButtonAction:(UIBarButtonItem *)sender {
    
    AddChannelViewController *addChannelViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"AddChannelViewController"];
    
    addChannelViewController.delegate = self;
    
    CGFloat screenWidth  = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    CGFloat contentHeight = 168.f;
    
    CGSize  contentSize = CGSizeMake(screenWidth, contentHeight);
    CGRect  sourceRect  = CGRectMake(screenWidth - 40.f, 0, 40, 44);
    
    
    [self openViewController:addChannelViewController
             popoverWithSize:contentSize
                    withRect:sourceRect
         navigationBarHidden:NO
          andBackgroundColor:[UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.00]];
    
}

@end
