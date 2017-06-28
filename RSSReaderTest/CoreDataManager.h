//
//  CoreDataManager.h
//  RSSReaderTest
//
//  Created by VLAD on 27/06/2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MagicalRecord/MagicalRecord.h>

#import "Channel+CoreDataClass.h"
#import "News+CoreDataClass.h"


@interface CoreDataManager : NSObject

+ (instancetype) sharedManager;

- (void) addDefaultChannelsWithsuccessHandler: (void(^) ()) success andFailureHandler: (void(^) (NSError *error)) failure;

- (void) addRssChannelWithTitle: (NSString *) title andUrl: (NSString *) url successHandler: (void(^) ()) success andFailureHandler: (void(^) (NSError *error)) failure;

- (NSArray *) getAllChannels;

- (void) deleteRssChannel: (Channel *) channel successHandler: (void(^) ()) success andFailureHandler: (void(^) (NSError *error)) failure;

- (void) saveFeedToChannel: (NSString *) urlChannel fromItems: (NSArray *) rssItems;

- (NSArray *) getFeedChannel: (NSString *) urlChannel;

@end
