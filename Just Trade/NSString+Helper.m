//
//  NSString+Helper.m
//  DreamBook
//
//  Created by bartleby on 10.10.12.
//  Copyright (c) 2012 iDevs. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (Helper)

- (CGFloat)textHeightForCustomFont:(UIFont *)font {
	//Calculate the expected size based on the font and linebreak mode of your label
	CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - 40;
	CGFloat maxHeight = 9999;
	CGSize maximumLabelSize = CGSizeMake(maxWidth,maxHeight);
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
	CGSize expectedLabelSize = [self boundingRectWithSize:maximumLabelSize
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:font,
                                                            NSParagraphStyleAttributeName: paragraphStyle.copy}
                                                  context:nil].size;
	
	return expectedLabelSize.height;
}

- (CGRect)frameForCellLabelWithCustomFont:(UIFont *)font {
	CGFloat width = 240;
	CGFloat height = [self textHeightForCustomFont:font] + 10.0;
	return CGRectMake(10.0f, 10.0f, width, height);
}

- (void)resizeLabel:(UILabel *)aLabel withCustomFont:(UIFont *)font {
    aLabel.frame = [self frameForCellLabelWithCustomFont:font];
	aLabel.text = self;
    aLabel.font = font;
	[aLabel sizeToFit];
}

- (void)resizeLabel:(UILabel *)aLabel withSystemFontOfSize:(CGFloat)size {
	[self resizeLabel:aLabel withCustomFont:[UIFont systemFontOfSize:size]];
}

@end
