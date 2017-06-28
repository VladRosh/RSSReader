//
//  UIViewController+Extension.m
//  RSSReaderTest
//
//  Created by VLAD on 27/06/2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import "UIViewController+Extension.h"

@interface UIViewController () <UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate>

@end

@implementation UIViewController (Extension)

#pragma mark - Alert method

- (void) alertWithTitle: (NSString *) title andMessage: (NSString *) message {
    
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle: title
                                        message: message
                                 preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction =
    [UIAlertAction actionWithTitle: @"Ok"
                             style: UIAlertActionStyleDefault
                           handler: nil];
    
    [alertController addAction: okAction];
    
    [self presentViewController: alertController animated: YES completion: nil];
}


#pragma mark - Netwok activity methods

- (void) startNetActivity {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}

- (void) stopNetActivity {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - Popover methods

- (void) openViewController: (UIViewController *) controller popoverWithSize: (CGSize) size withRect: (CGRect) rect navigationBarHidden: (BOOL) hidden andBackgroundColor: (UIColor *) color  {
    
    UINavigationController *navigationCtrl = [[UINavigationController alloc] initWithRootViewController:controller];
    navigationCtrl.modalPresentationStyle = UIModalPresentationPopover;
    navigationCtrl.navigationBarHidden = hidden;
    
    controller.preferredContentSize = size;
    
    UIPopoverPresentationController *popoverCtrl = navigationCtrl.popoverPresentationController;
    popoverCtrl.delegate = self;
    popoverCtrl.sourceView = self.view;
    popoverCtrl.sourceRect = rect;
    popoverCtrl.backgroundColor = color;
    
    [self presentViewController:navigationCtrl animated:YES completion:nil];
}

#pragma mark - UIAdaptivePresentationControllerDelegate

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    
    return UIModalPresentationNone;
}


@end
