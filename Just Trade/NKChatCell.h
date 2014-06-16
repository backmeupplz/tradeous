//
//  NKChatCell.h
//  Just Trade
//
//  Created by Nikita Kolmogorov on 08.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKChatCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bubbleView;
@property (weak, nonatomic) IBOutlet UIImageView *bubbleTail;
@property (weak, nonatomic) IBOutlet UILabel *bubleTextLabel;

@end
