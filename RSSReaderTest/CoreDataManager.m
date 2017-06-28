//
//  CoreDataManager.m
//  RSSReaderTest
//
//  Created by VLAD on 27/06/2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import "CoreDataManager.h"
#import "Item.h"

@implementation CoreDataManager

+ (instancetype) sharedManager {
    
    static CoreDataManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[CoreDataManager alloc] init];
    });
    
    return manager;
}

#pragma mark - RssChannel methods

- (void) addDefaultChannelsWithsuccessHandler: (void(^) ()) success andFailureHandler: (void(^) (NSError *error)) failure {
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        
        NSDictionary *defaultChannels =
        @{@"Business": @"http://feeds.nytimes.com/nyt/rss/Business", @"Travel": @"http://www.nytimes.com/services/xml/rss/nyt/Travel.xml", @"BBC": @"http://feeds.bbci.co.uk/news/world/rss.xml"};
       
        NSArray *keys = [defaultChannels allKeys];
        
        for (NSString *key in keys) {
            
            NSString *url = [defaultChannels objectForKey:key];
            
            Channel *channel = [Channel MR_findFirstByAttribute:@"url"
                                                            withValue:url
                                                            inContext:localContext];
            
            if (!channel) {
                
                [self createRssChannelWithTitle:key
                                      andUrl:url
                              inLocalContext:localContext];
            }
        }
        
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
        if (error) {
            
            if (failure) {
                
                failure(error);
            }
            
        } else {
            
            if (success) {
                
                success();
            }
        }
    }];
}

- (void) addRssChannelWithTitle: (NSString *) title andUrl: (NSString *) url successHandler: (void(^) ()) success andFailureHandler: (void(^) (NSError *error)) failure {
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        
        [self createRssChannelWithTitle:title
                              andUrl:url
                      inLocalContext:localContext];
        
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
        if (error) {
            
            if (failure) {
                
                failure(error);
            }
            
        } else {
            
            if (success) {
                
                success();
            }
        }
    }];
}

- (void) createRssChannelWithTitle: (NSString *) title andUrl: (NSString *) url inLocalContext: (NSManagedObjectContext *) localContext {
    
    Channel *channel = [Channel MR_createEntityInContext:localContext];
    
    channel.title = title;
    channel.url = url;
}

- (NSArray *) getAllChannels {
    
    return [Channel MR_findAllSortedBy:@"title" ascending:YES];
}

- (void) deleteRssChannel: (Channel *) channel successHandler: (void(^) ()) success andFailureHandler: (void(^) (NSError *error)) failure {
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        
        [channel MR_deleteEntityInContext:localContext];
        
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
        if (error) {
            
            if (failure) {
                
                failure(error);
            }
            
        } else {
            
            if (success) {
                
                success();
            }
        }
    }];
}

#pragma mark - RssFeed methods

- (void) saveFeedToChannel: (NSString *) urlChannel fromItems: (NSArray *) rssItems {
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        
        Channel *channel = [Channel MR_findFirstByAttribute:@"url"
                                                        withValue:urlChannel
                                                        inContext:localContext];
        
        NSArray *rssFeedArray = [channel.news allObjects];
        
        for (News *rssNews in rssFeedArray) {
            
            [rssNews MR_deleteEntityInContext:localContext];
        }
        
        for (Item *anyRssItem in rssItems) {
            
            News *rssNews = [News MR_createEntityInContext:localContext];
            
            rssNews.title = anyRssItem.title;
            rssNews.detail = anyRssItem.descript;
            rssNews.url = anyRssItem.link;
            rssNews.date = anyRssItem.date;
            
            [channel addNewsObject:rssNews];
        }
    }];
}

- (NSArray *) getFeedChannel: (NSString *) urlChannel {
    
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"channel.url == %@", urlChannel];
    
    return [News MR_findAllWithPredicate:predicate];
}


@end
