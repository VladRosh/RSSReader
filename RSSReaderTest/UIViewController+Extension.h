//
//  UIViewController+Extension.h
//  RSSReaderTest
//
//  Created by VLAD on 27/06/2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extension)

- (void) alertWithTitle: (NSString *) title andMessage: (NSString *) message;

- (void) startNetActivity;
- (void) stopNetActivity;

- (void) openViewController: (UIViewController *) controller popoverWithSize: (CGSize) size withRect: (CGRect) rect navigationBarHidden: (BOOL) hidden andBackgroundColor: (UIColor *) color;


@end
