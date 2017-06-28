//
//  NetworkManager.h
//  RSSReaderTest
//
//  Created by VLAD on 27/06/2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

+ (instancetype) sharedManager;

- (void) startCheckingExistConnection: (void (^)()) existConnection notExistConnection: (void (^)()) notExistConnection;

- (void) stopCheckingConnection;

- (void) getFeedWithUrl: (NSString *) URLStrng successHandler: (void(^) (NSData *rssData)) success andFailureHandler: (void(^) (NSError *error)) failure;


@end
