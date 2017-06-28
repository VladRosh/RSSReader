//
//  Item.h
//  RSSReaderTest
//
//  Created by VLAD on 27/06/2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *descript;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *imageUrl;

@end
