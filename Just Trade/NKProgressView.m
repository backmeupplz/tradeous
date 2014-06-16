//
//  NKProgressView.m
//  Just Trade
//
//  Created by Nikita Kolmogorov on 15.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import "NKProgressView.h"

#define progressViewGreenColor [UIColor colorWithRed:0.44f green:0.76f blue:0.13f alpha:1.00f]
#define progressViewRedColor [UIColor colorWithRed:0.76f green:0.38f blue:0.27f alpha:1.00f]
#define progressViewGreyColor [UIColor colorWithRed:0.51f green:0.51f blue:0.51f alpha:1.00f]

@implementation NKProgressView {
    UIView *progressView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGRect frame = CGRectMake(0, 0, 0, self.frame.size.height);
    progressView = [[UIView alloc] initWithFrame:frame];
    progressView.backgroundColor = progressViewGreenColor;
    
    [self addSubview:progressView];
}

/**
 *  Set progress of the custom progress view in percentage
 *
 *  @param progress Progress in percentage
 */
- (void)setProgress:(float)progress {
    float width = self.frame.size.width * (progress/100);
    
    CGRect frame = progressView.frame;
    frame.size.width = width;
    progressView.frame = frame;
}

- (void)setSucceeded {
    progressView.backgroundColor = progressViewGreenColor;
    
    CGRect frame = progressView.frame;
    frame.size.width = self.frame.size.width;
    progressView.frame = frame;
}

- (void)setError {
    progressView.backgroundColor = progressViewRedColor;
    
    CGRect frame = progressView.frame;
    frame.size.width = self.frame.size.width;
    progressView.frame = frame;
}

- (void)setNoConnection {
    progressView.backgroundColor = progressViewGreyColor;
    
    CGRect frame = progressView.frame;
    frame.size.width = self.frame.size.width;
    progressView.frame = frame;
}


@end
