//
//  AddChannelViewController.h
//  RSSReaderTest
//
//  Created by VLAD on 28/06/2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddChannelViewControllerDelegate;

@interface AddChannelViewController : UIViewController

@property (weak, nonatomic) id < AddChannelViewControllerDelegate > delegate;

@end


@protocol AddChannelViewControllerDelegate

@required

- (void) addChannelViewController: (AddChannelViewController *) addChannelViewController newChannelAdded: (NSString *) rssChannelTitle;

@end
