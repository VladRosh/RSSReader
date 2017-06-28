//
//  BrowserViewController.m
//  RSSReaderTest
//
//  Created by VLAD on 27/06/2017.
//  Copyright © 2017 Vlad. All rights reserved.
//


#import "BrowserViewController.h"
#import "UIViewController+Extension.h"

@interface BrowserViewController () <SFSafariViewControllerDelegate>

@end

@implementation BrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    self.view.tintColor = [UIColor blueColor];
    
    UIBarButtonItem *backBarButton =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(backBarButtonAction:)];
    
    backBarButton.tintColor = [UIColor blueColor];
    
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    [self startNetActivity];
}

- (void)dealloc {
    
    [self stopNetActivity];
}

#pragma mark - SFSafariViewControllerDelegate

- (void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully {
    
    [self stopNetActivity];
}

#pragma mark - Actions

- (void) backBarButtonAction: (id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
