//
//  ViewModel.m
//  RSSReaderTest
//
//  Created by VLAD on 27/06/2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import "ViewModel.h"

@implementation ViewModel


- (instancetype)initWithItem: (Item *) item
{
    self = [super init];
    if (self) {
        
        self.title = item.title;
        self.detailText = [self convertUnicodeString:item.descript];
        self.url = item.link;
        self.date = [self convertDateString:item.date];
    }
    return self;
}

- (instancetype)initWithNews: (News *) news
{
    self = [super init];
    if (self) {
        
        self.title = news.title;
        self.detailText = news.detail;
        self.url = news.url;
        self.date = [self convertDateString:news.date];
    }
    return self;
}

+ (NSArray *) newsModelsFromItems: (NSArray *) items {
    
    NSMutableArray *news = [[NSMutableArray alloc] init];
    
    for (Item *anyItem in items) {
        
        ViewModel *newsViewModel = [[ViewModel alloc] initWithItem:anyItem];
        
        [news addObject:newsViewModel];
    }
    
    return news;
}

+ (NSArray *) newsModelsFromNews: (NSArray *) rssNews {
    
    NSMutableArray *news = [[NSMutableArray alloc] init];
    
    for (News *anyNews in rssNews) {
        
        ViewModel *newsViewModel = [[ViewModel alloc] initWithNews:anyNews];
        
        [news addObject:newsViewModel];
    }
    
    return news;
}

- (NSString *) convertDateString: (NSString *) dateString {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EE, dd MMM yyyy HH:mm:ss ZZZ"];
    
    NSDate *date = [dateFormat dateFromString:dateString];
    
    [dateFormat setDateFormat:@"dd.MM.yyyy HH:mm"];
    
    return [dateFormat stringFromDate:date];
}

- (NSString *) convertUnicodeString: (NSString *) unicodeString {
    
    NSError *error = nil;
    
    NSRegularExpression *regex =
    [NSRegularExpression regularExpressionWithPattern:@"\\[?&#[0-9]{1,8};\\]?"
                                              options:NSRegularExpressionCaseInsensitive
                                                error:&error];
    
    if (error) {
        
        return unicodeString;
        
    } else {
        
        NSString *modifiedString =
        [regex stringByReplacingMatchesInString:unicodeString
                                        options:0
                                          range:NSMakeRange(0, [unicodeString length]) withTemplate:@""];
        
        return [modifiedString stringByAppendingString:@" ..."];
    }
}


@end
