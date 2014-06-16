//
//  NKChatViewController.h
//  Just Trade
//
//  Created by Nikita Kolmogorov on 08.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "SRWebSocket.h"

@interface NKChatViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate, SRWebSocketDelegate>

@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *changeLangButton;

- (IBAction)backTouched:(id)sender;
- (IBAction)changeLangTouched:(UIButton *)sender;

@end
