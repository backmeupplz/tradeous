//
//  NKProgressView.h
//  Just Trade
//
//  Created by Nikita Kolmogorov on 15.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKProgressView : UIView

- (void)setProgress:(float)progress;
- (void)setSucceeded;
- (void)setError;
- (void)setNoConnection;

@end
