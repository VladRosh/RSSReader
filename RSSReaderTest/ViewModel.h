//
//  ViewModel.h
//  RSSReaderTest
//
//  Created by VLAD on 27/06/2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Item.h"
#import "News+CoreDataClass.h"

@interface ViewModel : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *detailText;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *date;

- (instancetype)initWithItem: (Item *) item;
- (instancetype)initWithNews: (News *) news;

+ (NSArray *) newsModelsFromItems: (NSArray *) items;
+ (NSArray *) newsModelsFromNews: (NSArray *) rssNews;


@end
