//
//  NKSideBarOpenButton.m
//  Just Trade
//
//  Created by Nikita Kolmogorov on 23.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import "NKSideBarOpenButton.h"

@implementation NKSideBarOpenButton

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    self.backgroundColor = (selected) ?
    [UIColor colorWithRed:81.0/255.0 green:97.0/255.0 blue:162.0/255.0 alpha:1.0]:
    [UIColor clearColor];
    
    if (selected) {
        CGRect frame = self.frame;
        frame.origin.x = -2;
        frame.origin.y = 20;
        frame.size.height = 44;
        frame.size.width = 40;
        self.frame = frame;
        
        self.imageEdgeInsets = UIEdgeInsetsMake(16, 12, 16, 13);
    } else {
        CGRect frame = self.frame;
        frame.origin.x = -2;
        frame.origin.y = 24;
        frame.size.height = 40;
        frame.size.width = 46;
        self.frame = frame;
        
        self.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 13, 13);
    }
}

@end
