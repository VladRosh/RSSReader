//
//  RSSParser.m
//  RSSReaderTest
//
//  Created by VLAD on 27/06/2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import "RSSParser.h"

@interface RSSParser () <NSXMLParserDelegate>

@property (strong, nonatomic) NSXMLParser *xmlParser;

@property (assign, nonatomic) BOOL isChannel;
@property (assign, nonatomic) BOOL isItem;
@property (assign, nonatomic) BOOL isTitle;
@property (assign, nonatomic) BOOL isDescription;
@property (assign, nonatomic) BOOL isLink;
@property (assign, nonatomic) BOOL isDate;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *anyDescription;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *imageUrl;

@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSURL *url;

@property (strong, nonatomic) NSString *elementName;


@end

@implementation RSSParser

- (void) parseChannelInfo: (NSData *) rssData {
    
    self.elementName = @"channel";
    
    [self parse:rssData];
}

- (void) parseFeed: (NSData *) rssData {
    
    self.elementName = @"item";
    
    [self parse:rssData];
}

- (void) parse: (NSData *) rssData {
    
    self.xmlParser = [[NSXMLParser alloc] initWithData:rssData];
    
    self.xmlParser.delegate = self;
    self.xmlParser.shouldResolveExternalEntities = NO;
    
    [self.xmlParser parse];
    
}

#pragma mark - <NSXMLParserDelegate>

- (void) parserDidStartDocument:(NSXMLParser *)parser {
    
    self.items = [[NSMutableArray alloc] init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    [self didStartRssFeedElement:elementName attributes:attributeDict];
}

- (void) didStartRssFeedElement:(NSString *)elementName  attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqualToString:self.elementName]) {
        
        self.isItem = YES;
        
        self.title = @"";
        self.anyDescription = @"";
        self.link = @"";
        self.date = @"";
    }
    
    if (self.isItem) {
        
        if ([elementName isEqualToString:@"title"]) {
            
            self.isTitle = YES;
        }
        
        if ([elementName isEqualToString:@"description"]) {
            
            self.isDescription = YES;
        }
        
        if ([elementName isEqualToString:@"link"]) {
            
            self.isLink = YES;
        }
        
        if ([elementName isEqualToString:@"pubDate"]) {
            
            self.isDate = YES;
        }
        
        if ([elementName isEqualToString:@"enclosure"]) {
            
            self.imageUrl = [attributeDict objectForKey:@"url"];
        }
    }
}

-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if (self.isItem) {
        
        if (self.isTitle) {
            
            self.title = [NSString stringWithFormat:@"%@%@", self.title, string];
        }
        
        if (self.isDescription) {
            
            self.anyDescription = [NSString stringWithFormat:@"%@%@", self.anyDescription, string];
        }
        
        if (self.isLink) {
            
            self.link = [NSString stringWithFormat:@"%@%@", self.link, string];
        }
        
        if (self.isDate) {
            
            self.date = [NSString stringWithFormat:@"%@%@", self.date, string];
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:self.elementName]) {
        
        self.isItem = NO;
        
        Item *rssItem = [[Item alloc] init];
        
        rssItem.title = self.title;
        rssItem.descript = self.anyDescription;
        rssItem.link = self.link;
        rssItem.date = self.date;
        rssItem.imageUrl = self.imageUrl;
        
        [self.items addObject:rssItem];
    }
    
    if (self.isItem) {
        
        if ([elementName isEqualToString:@"title"]) {
            
            self.isTitle = NO;
        }
        
        if ([elementName isEqualToString:@"description"]) {
            
            self.isDescription = NO;
        }
        
        if ([elementName isEqualToString:@"link"]) {
            
            self.isLink = NO;
        }
        
        if ([elementName isEqualToString:@"pubDate"]) {
            
            self.isDate = NO;
        }
    }
}

- (void) parserDidEndDocument:(NSXMLParser *)parser {
    
    [self.delegate rssParser:self finishFeed:self.items];
}


@end
