//
//  NKCandleGraph.h
//  Just Trade
//
//  Created by Nikita Kolmogorov on 08.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKCandleGraph : UIView

@property (strong,nonatomic) NSMutableArray *allGraphViews;
@property (strong,nonatomic) NSMutableArray *labelViews;
@property (strong,nonatomic) NSMutableArray *timeLabelViews;
@property (strong,nonatomic) NSMutableArray *otherViews;

- (void)drawValues:(NSArray *)valuesToDraw;
- (void)clean;

@end
