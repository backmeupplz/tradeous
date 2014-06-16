//
//  NSString+Helper.h
//  DreamBook
//
//  Created by bartleby on 10.10.12.
//  Copyright (c) 2012 iDevs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Helper)

- (CGFloat)textHeightForCustomFont:(UIFont *)font;
- (CGRect)frameForCellLabelWithCustomFont:(UIFont *)font;
- (void)resizeLabel:(UILabel *)aLabel withSystemFontOfSize:(CGFloat)size;
- (void)resizeLabel:(UILabel *)aLabel withCustomFont:(UIFont *)font;

@end
