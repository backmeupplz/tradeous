//
//  NKLoginTextView.h
//  Just Trade
//
//  Created by Nikita Kolmogorov on 14.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKLoginTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

- (void)textChanged:(NSNotification*)notification;

- (void)addRedBorder;
- (void)removeRedBorder;

@end
