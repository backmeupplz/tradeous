//
//  NKSideMenuCell.m
//  Just Trade
//
//  Created by Nikita Kolmogorov on 08.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import "NKSideMenuCell.h"

@implementation NKSideMenuCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.contentView.backgroundColor = (selected) ?
    [UIColor colorWithRed:81.0/255.0 green:97.0/255.0 blue:162.0/255.0 alpha:1.0]:
    [UIColor colorWithRed:28.0/255.0 green:27.0/255.0 blue:32.0/255.0 alpha:1.0];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    self.contentView.backgroundColor = (highlighted) ?
    [UIColor colorWithRed:80.0/255.0 green:102.0/255.0 blue:160.0/255.0 alpha:1.0]:
    [UIColor colorWithRed:37.0/255.0 green:37.0/255.0 blue:43.0/255.0 alpha:1.0];
}

@end
