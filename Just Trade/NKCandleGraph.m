//
//  NKCandleGraph.m
//  Just Trade
//
//  Created by Nikita Kolmogorov on 08.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import "NKCandleGraph.h"
#import "DataFromServerManager.h"

#define bottomBarHeight 40
#define graphOffset 20

@implementation NKCandleGraph {
    NSArray *values;
    
    float minPrice;
    float maxPrice;
}

@synthesize allGraphViews, labelViews, timeLabelViews, otherViews;

#pragma mark -
#pragma mark Accessors
#pragma mark -

- (NSMutableArray *)allGraphViews {
    if (allGraphViews == nil)
        allGraphViews = [NSMutableArray array];
    return allGraphViews;
}

- (NSMutableArray *)labelViews {
    if (labelViews == nil)
        labelViews = [NSMutableArray array];
    return labelViews;
}

- (NSMutableArray *)timeLabelViews {
    if (timeLabelViews == nil)
        timeLabelViews = [NSMutableArray array];
    return timeLabelViews;
}

- (NSMutableArray *)otherViews {
    if (otherViews == nil)
        otherViews = [NSMutableArray array];
    return otherViews;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self clean];
    [self redrawOtherViews];
}

#pragma mark -
#pragma mark View Lyfe Cycle
#pragma mark -

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self redrawOtherViews];
}

#pragma mark -
#pragma mark Drawing methods
#pragma mark -

/**
 *  Method to clean background static views and redraw them
 */
- (void)redrawOtherViews {
    [self cleanOtherViews];
    [self drawBottomBar];
    [self drawLinesAndLabels];
}

/**
 *  Method to remove all background views
 */
- (void)cleanOtherViews {
    // Clean other views array
    for (UIView *view in self.otherViews) {
        [view removeFromSuperview];
    }
    [self.otherViews removeAllObjects];
    
    // Clean time label views
    for (UILabel *label in self.timeLabelViews) {
        [label removeFromSuperview];
    }
    [self.timeLabelViews removeAllObjects];
    
    // Clean label views
    for (UILabel *label in self.labelViews) {
        [label removeFromSuperview];
    }
    [self.labelViews removeAllObjects];
}

/**
 *  Method to draw bottom bar for graph view
 */
- (void)drawBottomBar {
    // Make a frame
    CGRect frame = CGRectMake(0,
                              self.frame.size.height-bottomBarHeight,
                              self.frame.size.width,
                              bottomBarHeight);
    
    // Make a view with frame
    UIView *bottomBar = [[UIView alloc] initWithFrame:frame];
    
    // Add background color to view
    bottomBar.backgroundColor = [UIColor colorWithRed:80.0/255.0 green:102.0/255.0 blue:160.0/255.0 alpha:1.0];
    
    // Add view to self
    [self addSubview:bottomBar];
    
    // Add bottom bar to other views array
    [self.otherViews addObject:bottomBar];
    
    // Draw time labels
    [self drawLabelToX:(self.frame.size.width-30)];
    [self drawLabelToX:(self.frame.size.width-60)-30];
    [self drawLabelToX:(self.frame.size.width-60)-90];
    [self drawLabelToX:(self.frame.size.width-60)-150];
    [self drawLabelToX:(self.frame.size.width-60)-210];
    [self drawLabelToX:(self.frame.size.width-60)-270];
}

/**
 *  Method to draw time label to bottom view on given x
 *
 *  @param x X coordinate of required label
 */
- (void)drawLabelToX:(float)x {
    // Make a frame
    float height = 20;
    CGRect frame = CGRectMake(x,
                              self.frame.size.height - bottomBarHeight/2-height/2,
                              40,
                              height);
    
    // Make a label from frame
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    
    // Setup label
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 14.0f];
    label.text = @"";
    
    // Add label as a subview
    [self addSubview:label];
    
    // Add label to array of time labels
    [self.timeLabelViews addObject:label];
}

/**
 *  Method to draw separating graph lines and labels to the right side of them
 */
- (void)drawLinesAndLabels {
    // Get section height
    float sectionsHeight = (self.frame.size.height - bottomBarHeight -(graphOffset*2)) / 5;
    
    // Draw lines
    [self drawLineAtY:graphOffset+sectionsHeight/2];
    [self drawLineAtY:graphOffset+sectionsHeight*3/2];
    [self drawLineAtY:graphOffset+sectionsHeight*5/2];
    [self drawLineAtY:graphOffset+sectionsHeight*7/2];
    [self drawLineAtY:graphOffset+sectionsHeight*9/2];

    // Draw labels
    [self drawLabelToY:graphOffset+sectionsHeight/2];
    [self drawLabelToY:graphOffset+sectionsHeight*3/2];
    [self drawLabelToY:graphOffset+sectionsHeight*5/2];
    [self drawLabelToY:graphOffset+sectionsHeight*7/2];
    [self drawLabelToY:graphOffset+sectionsHeight*9/2];
}

/**
 *  Method to draw a separator graph line at given Y
 *
 *  @param y Y coordinate of required line
 */
- (void)drawLineAtY:(float)y {
    // Make a frame
    CGRect frame = CGRectMake(0,y,self.frame.size.width-60,2);
    
    // Make a line from frame
    UIView *line = [[UIView alloc] initWithFrame:frame];
    
    // Setup line
    line.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:227.0/255.0 blue:224.0/255.0 alpha:1.0];
    
    // Add line as a subview
    [self addSubview:line];
    
    // Add line to other views array
    [self.otherViews addObject:line];
}

/**
 *  Method to draw a separator label at given Y
 *
 *  @param y Y coordinate of required label
 */
- (void)drawLabelToY:(float)y {
    // Make a frame
    CGRect frame = CGRectMake(self.frame.size.width - 50, y-10, 50, 20);
    
    // Make a label from frame
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    
    // Setup label
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 12.0f];
    label.text = @"";
    
    // Add label as a subview
    [self addSubview:label];
    
    // Add label to the common array
    [self.labelViews addObject:label];
}

/**
 *  Method to draw array of values
 *
 *  @param valuesToDraw Array of values to draw
 */
- (void)drawValues:(NSArray *)valuesToDraw {
    graphQueueStart
        if (valuesToDraw.count != 0) {
            if ([[valuesToDraw lastObject][@"tid"] intValue] != [[values lastObject][@"tid"] intValue]) {
                values = [self getOnlyLast9HoursFromArray:valuesToDraw];
                [self drawPriceIndicators];
                [self drawCandles];
            }
        }
    graphQueueEnd
}

/**
 *  Method to fill price indicators with proper values
 */
- (void)drawPriceIndicators {
    NSMutableArray *tempValues = [values mutableCopy];
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"price" ascending:YES];
    [tempValues sortUsingDescriptors:@[descriptor]];
    
    minPrice = [[tempValues firstObject][@"price"] floatValue];
    maxPrice = [[tempValues lastObject][@"price"] floatValue];
    
    float step = (maxPrice - minPrice) / 5.0;
    
    mainQueueStart
    for (int i = 0; i < self.labelViews.count; i++) {
        UILabel *label = self.labelViews[i];
        
        switch (dataFromServerManager.pair) {
            case ftc_btc:
                label.text = [NSString stringWithFormat:@"%.4f",maxPrice-(step*i)];
                break;
            case ppc_btc:
                label.text = [NSString stringWithFormat:@"%.4f",maxPrice-(step*i)];
                break;
            case trc_btc:
                label.text = [NSString stringWithFormat:@"%.4f",maxPrice-(step*i)];
                break;
            case eur_usd:
                label.text = [NSString stringWithFormat:@"%.2f",maxPrice-(step*i)];
                break;
            case nvc_btc:
                label.text = [NSString stringWithFormat:@"%.3f",maxPrice-(step*i)];
                break;
            case nmc_usd:
                label.text = [NSString stringWithFormat:@"%.3f",maxPrice-(step*i)];
                break;
            case nmc_btc:
                label.text = [NSString stringWithFormat:@"%.4f",maxPrice-(step*i)];
                break;
            case ltc_eur:
                label.text = [NSString stringWithFormat:@"%.2f",maxPrice-(step*i)];
                break;
            case ltc_usd:
                label.text = [NSString stringWithFormat:@"%.2f",maxPrice-(step*i)];
                break;
            case ltc_btc:
                label.text = [NSString stringWithFormat:@"%.3f",maxPrice-(step*i)];
                break;
            default:
                label.text = [NSString stringWithFormat:@"%.1f",maxPrice-(step*i)];
                break;
        }
    }
    mainQueueEnd
}

- (void)drawCandles {
    // Get current timestamp
    int timestamp = [[NSDate date] timeIntervalSince1970];
    
    // Show time on labels
    [self setTimeToLabels:timestamp - (timestamp % 1800)];
    
    // Make a duplicate array just in case
    NSMutableArray *tempValues = [values mutableCopy];
    
    NSMutableArray *usedXs = [NSMutableArray array];
    
    // Do this untill tempValues is not empty
    int iterator = 0;
    while (tempValues.count > 0) {
        // Get current half hour
        int currentHalfHour = timestamp - (timestamp % 1800);
        timestamp -= (timestamp % 1800) + 1;
        
        // Get only trades for this candle
        NSMutableArray *requiredTrades = [NSMutableArray array];
        for (NSDictionary *trade in tempValues) {
            if ([trade[@"date"] intValue] >= currentHalfHour)
                [requiredTrades addObject:trade];
            else
                break;
        }
        
        if (requiredTrades.count == 0) {
            [requiredTrades addObject:[tempValues lastObject]];
        }
        
        // Remove used trades from tempValues
        [tempValues removeObjectsInArray:requiredTrades];
        
        // Get open and close price
        float openPrice = [[requiredTrades firstObject][@"price"] floatValue];
        float closePrice = [[requiredTrades lastObject][@"price"] floatValue];
        
        // Check if current candle is up
        BOOL isUp = (openPrice <= closePrice);
        
        // Get min and max price for current candle
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"price" ascending:YES];
        [requiredTrades sortUsingDescriptors:@[descriptor]];
        
        float inMinPrice = [[requiredTrades firstObject][@"price"] floatValue];
        float inMaxPrice = [[requiredTrades lastObject][@"price"] floatValue];
        
        // Get candle body frame
        float x = (self.frame.size.width - 70) - (15 * iterator);
        float y = isUp ? closePrice : openPrice;
        
        float graphHeight = (self.frame.size.height - bottomBarHeight - (graphOffset*2));
        float priceDelta = (maxPrice - minPrice);
        if (priceDelta <= 0) priceDelta = 0.00001;
        
        y = graphHeight - (graphHeight * (y - minPrice) / priceDelta) + graphOffset;
        float width = 5;
        float height = isUp ? openPrice : closePrice;
        height = graphHeight - (graphHeight * (height - minPrice) / priceDelta) + graphOffset - y;
        
        // if height is too small we need to make it 1
        if (height <= 0.5) height = 1;
        CGRect frame = CGRectMake(x,y,width,height);
        
        // Make a body from frame
        UIView *body = [[UIView alloc] initWithFrame:frame];
        
        // Setup body background color
        body.backgroundColor = !isUp ? [UIColor colorWithRed:71.0/255.0 green:206.0/255.0 blue:22.0/255.0 alpha:1.0] : [UIColor colorWithRed:222.0/255.0 green:77.0/255.0 blue:57.0/255.0 alpha:1.0];
        
        // Get candle shadow frame
        x += 2;
        width = 1;
        y = graphHeight - (graphHeight * (inMaxPrice - minPrice) / priceDelta) + graphOffset;
        height = graphHeight - (graphHeight * (inMinPrice - minPrice) / priceDelta) + graphOffset - y;
        CGRect frame2 = CGRectMake(x,y,width,height);
        
        // Make a shadow from frame
        UIView *shadow = [[UIView alloc] initWithFrame:frame2];
        
        // Setup shadow background color
        shadow.backgroundColor = body.backgroundColor;
        
        // Increment iterator
        iterator++;
        
        // Draw this candle
        mainQueueStart
        [self removeSimilarViewWithX:shadow.frame.origin.x];
        [self removeSimilarViewWithX:body.frame.origin.x];
        [self addSubview:shadow];
        [self addSubview:body];
        [self.allGraphViews addObject:shadow];
        [self.allGraphViews addObject:body];
        mainQueueEnd
        
        [usedXs addObject:@(shadow.frame.origin.x)];
        [usedXs addObject:@(body.frame.origin.x)];
    }
    mainQueueStart
        NSMutableArray *viewsToRemove = [NSMutableArray array];
        
        for (UIView *view in self.allGraphViews)
            if (![usedXs containsObject:@(view.frame.origin.x)])
                [viewsToRemove addObject:@(view.frame.origin.x)];
        
        for (NSNumber *x in viewsToRemove)
            [self removeSimilarViewWithX:[x floatValue]];
    mainQueueEnd
}

- (void)setTimeToLabels:(int)timestamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    NSArray *dates = @[
                       [formatter stringFromDate:[[NSDate alloc] initWithTimeIntervalSince1970:timestamp+7200]],
                       [formatter stringFromDate:[[NSDate alloc] initWithTimeIntervalSince1970:timestamp]],
                       [formatter stringFromDate:[[NSDate alloc] initWithTimeIntervalSince1970:timestamp-7200]],
                       [formatter stringFromDate:[[NSDate alloc] initWithTimeIntervalSince1970:timestamp-7200*2]],
                       [formatter stringFromDate:[[NSDate alloc] initWithTimeIntervalSince1970:timestamp-7200*3]],
                       [formatter stringFromDate:[[NSDate alloc] initWithTimeIntervalSince1970:timestamp-7200*4]]];
    
    for (int i = 0; i < self.timeLabelViews.count; i++) {
        UILabel *label = self.timeLabelViews[i];
        mainQueueStart
        label.text = dates[i];
        mainQueueEnd
    }
}

- (void)removeSimilarViewWithX:(float)x {
    UIView *viewToRemove;
    
    for (UIView *view in self.allGraphViews) {
        if (view.frame.origin.x == x) {
            viewToRemove = view;
            break;
        }
    }
    
    [self.allGraphViews removeObject:viewToRemove];
    [viewToRemove removeFromSuperview];
}

- (void)clean {
    [self removeAllGraphViews];
    
    for (UILabel *label in self.timeLabelViews) {
        label.text = @"";
    }
    
    for (UILabel *label in self.labelViews) {
        label.text = @"";
    }
    
    values = @[];
}

- (void)removeAllGraphViews {
    for (UIView *view in self.allGraphViews) {
        [view removeFromSuperview];
    }
    [self.allGraphViews removeAllObjects];
}

- (NSArray *)getOnlyLast9HoursFromArray:(NSArray *)array {
    // Get current timestamp
    int timestamp = [[NSDate date] timeIntervalSince1970];
    
    // Get last 9 hours
    int dayAgoTimestamp = timestamp - (60*60*9);
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSDictionary *value in array) {
        if ([value[@"date"] intValue] >= dayAgoTimestamp)
            [result addObject:value];
    }
    
    return result;
}

@end
