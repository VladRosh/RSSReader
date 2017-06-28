//
//  RSSParser.h
//  RSSReaderTest
//
//  Created by VLAD on 27/06/2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@protocol ParserDelegate;

@interface RSSParser : NSObject

@property (weak, nonatomic) id < ParserDelegate > delegate;

- (void) parseChannelInfo: (NSData *) rssData;
- (void) parseFeed: (NSData *) rssData;

@end

@protocol ParserDelegate

- (void) rssParser: (RSSParser *) rssParser finishFeed: (NSArray *) rssFeed;

@end
