//
//  NKTextFieldWithPadding.m
//
//  Created by Nikita Kolmogorov on 24.07.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import "NKTextFieldWithPadding.h"
#import <QuartzCore/QuartzCore.h>

#define textFieldWithPaddingBorderColor [UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1.0f]
#define textFieldWithPaddingBorderWidth 1.0
#define textFieldWithPaddingPadding 5.0

@implementation NKTextFieldWithPadding

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.borderColor = textFieldWithPaddingBorderColor.CGColor;
    self.layer.borderWidth = textFieldWithPaddingBorderWidth;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + textFieldWithPaddingPadding,
                      bounds.origin.y,
                      bounds.size.width - textFieldWithPaddingPadding,
                      bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + textFieldWithPaddingPadding,
                      bounds.origin.y,
                      bounds.size.width - textFieldWithPaddingPadding,
                      bounds.size.height);
}

- (void)addRedBorder {
    self.layer.borderColor = [UIColor redColor].CGColor;
    self.layer.borderWidth = 1.0f;
}

- (void)removeRedBorder {
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.borderWidth = 0.0f;
}

@end
