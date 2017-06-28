//
//  FramedTextfield.m
//  RSSReaderTest
//
//  Created by VLAD on 27/06/2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import "CustomTextfield.h"

@interface CustomTextfield ()

@property (strong, nonatomic) UIView* marginView;

@end

@implementation CustomTextfield

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        self.layer.borderWidth = 0.5f;
        self.layer.cornerRadius = 5.f;
        
        [self setNormState];
    }
    return self;
}

- (void) setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    
    self.marginView.backgroundColor = backgroundColor;
}

#pragma mark - State methods

- (void) setNormState {
    
    self.layer.borderColor =
    [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.00].CGColor;
}

- (void) setWarnState {
    
    self.layer.borderColor =
    [UIColor colorWithRed:0.96 green:0.02 blue:0.08 alpha:1.00].CGColor;
    
    [self shake];
}

- (void) shake {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    animation.duration = 0.05f;
    animation.repeatCount = 5;
    animation.autoreverses = YES;
    
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x - 4, self.center.y)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x + 4, self.center.y)];
    
    [self.layer addAnimation:animation forKey:@"position"];
}

@end
