//
//  RssChannelViewController.m
//  RSSReaderTest
//
//  Created by VLAD on 27/06/2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import "ChannelViewController.h"
#import "UIViewController+Extension.h"
#import "NewsViewController.h"
#import "NetStatusLabel.h"
#import "NewsTableViewCell.h"

#import "NetworkManager.h"
#import "RSSParser.h"
#import "Item.h"

#import "ViewModel.h"

@interface ChannelViewController () <ParserDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet NetStatusLabel *status;

@property (strong, nonatomic) NSArray *rssFeed;

@end

@implementation ChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.rssChannel.title;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NetworkManager sharedManager] startCheckingExistConnection:^{
        
        [self.status isOnline:YES];
        [self getFeedFromNetwork];
        
    } notExistConnection:^{
        
        [self.status isOnline:NO];
        [self getFeedFromCoreData];
    }];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NetworkManager sharedManager] stopCheckingConnection];
}

- (void)dealloc {
    
    [self stopNetActivity];
}

#pragma mark - Get and save feed methods

- (void) getFeedFromNetwork {
    
    [self startNetActivity];
    [self.activityIndicator startAnimating];
    
    [[NetworkManager sharedManager] getFeedWithUrl:self.rssChannel.url
                                       successHandler:^(NSData *rssData) {
                                           
                                           [self stopNetActivity];
                                           [self.activityIndicator stopAnimating];
                                           
                                           RSSParser *rssParser = [[RSSParser alloc] init];
                                           
                                           rssParser.delegate = self;
                                           [rssParser parseFeed:rssData];
                                       }
                                    andFailureHandler:^(NSError *error) {
                                        
                                        [self alertWithTitle:@"Attention!"
                                                      andMessage:@"Request error. Check  url."];
                                        
                                        [self stopNetActivity];
                                        [self.activityIndicator stopAnimating];
                                    }];
}

- (void) getFeedFromCoreData {
    
    NSArray *rssNews = [[CoreDataManager sharedManager] getFeedChannel:self.rssChannel.url];
    
    self.rssFeed = [ViewModel newsModelsFromNews:rssNews];
    
    [self.tableView reloadData];
}

- (void) saveRssFeedToCoreDataFromRssItems: (NSArray *) rssItems {
    
    [[CoreDataManager sharedManager] saveFeedToChannel:self.rssChannel.url fromItems:rssItems];
}

#pragma mark - RSSParserDelegate

- (void) rssParser: (RSSParser *) rssParser finishFeed: (NSArray *) rssFeed {
    
    self.rssFeed = [ViewModel newsModelsFromItems:rssFeed];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
    });
    
    [self saveRssFeedToCoreDataFromRssItems:rssFeed];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.rssFeed.count;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *identifier = @"newsCell";
    
    NewsTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell){
        
        cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    ViewModel *news = [self.rssFeed objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = news.title;
    cell.detailLabel.text = news.detailText;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ViewModel *news = [self.rssFeed objectAtIndex:indexPath.row];
    
    NewsViewController *newsViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"NewsViewController"];
    
    newsViewController.title = self.title;
    newsViewController.newsModel = news;
    
    [self.navigationController pushViewController:newsViewController animated:YES];
}

#pragma mark - Actions


- (IBAction)backBarButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
