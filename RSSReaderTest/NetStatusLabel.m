//
//  NetworkStatusLabel.m
//  RSSReaderTest
//
//  Created by VLAD on 27/06/2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import "NetStatusLabel.h"

@implementation NetStatusLabel

- (void) isOnline: (BOOL) onLine {
    
    if (onLine) {
        
        self.text = @"OnLine";
        self.textColor = [UIColor colorWithRed:0.00 green:0.85 blue:0.27 alpha:1.00];
        
    } else {
        
        self.text = @"OffLine";
        self.textColor = [UIColor colorWithRed:0.96 green:0.02 blue:0.08 alpha:1.00];
    }
}

@end
