//
//  Item+Extension.m
//  RSSReaderTest
//
//  Created by VLAD on 27/06/2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import "Item+Extension.h"

@implementation Item (Extension)

- (NSString *)description
{
    return [NSString stringWithFormat:@"title: %@, description: %@, link: %@, date: %@, imageUrl: %@", self.title, self.descript, self.link, self.date, self.imageUrl];
}

@end
