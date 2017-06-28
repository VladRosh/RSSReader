//
//  NewsViewController.m
//  RSSReaderTest
//
//  Created by VLAD on 27/06/2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import "NewsViewController.h"
#import "BrowserViewController.h"
#import "NetStatusLabel.h"

#import "NetworkManager.h"

@interface NewsViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *openBrowserButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet NetStatusLabel *statusLabel;


@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = self.newsModel.title;
    self.detailLabel.text = self.newsModel.detailText;
    self.dateLabel.text = self.newsModel.date;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NetworkManager sharedManager] startCheckingExistConnection:^{
        
        [self.openBrowserButton setEnabled:YES];
        [self.statusLabel isOnline:YES];
        
    } notExistConnection:^{
        
        [self.openBrowserButton setEnabled:NO];
        [self.statusLabel isOnline:NO];
    }];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NetworkManager sharedManager] stopCheckingConnection];
}



#pragma mark - Actions

- (IBAction)backButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)openBrowserBtn:(UIBarButtonItem *)sender {
    
    NSURL *URL = [NSURL URLWithString:self.newsModel.url];
    
    BrowserViewController *safariViewController =
    [[BrowserViewController alloc] initWithURL:URL];
    
    safariViewController.title = self.title;
    
    [self.navigationController pushViewController:safariViewController animated:YES];
}


@end
