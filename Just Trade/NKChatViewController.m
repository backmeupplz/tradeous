//
//  NKChatViewController.m
//  Just Trade
//
//  Created by Nikita Kolmogorov on 08.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import "NKChatViewController.h"
#import "NKChatCell.h"
#import <QuartzCore/QuartzCore.h>
#import "BtceApiHandler.h"
#import "DataFromServerManager.h"
#import "NSString+Helper.h"
#import "GTMNSString+HTML.h"

@implementation NKChatViewController
{
    NSMutableArray *rusTableData;
    NSMutableArray *engTableData;
    
    SRWebSocket *rusSocket;
    SRWebSocket *engSocket;
    
    BOOL isRusOn;
}

#pragma mark - View Controller life cycle -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    rusTableData = [NSMutableArray array];
    engTableData = [NSMutableArray array];
    
    self.screenName = @"Chat View";
    
    [self setupSockets];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    isRusOn = [[[NSUserDefaults standardUserDefaults] objectForKey:@"rusChatIsOn"] boolValue];
    NSString *titleStr = (isRusOn) ? NSLocalizedString(@"Рус",nil) : NSLocalizedString(@"Англ",nil);
    [self.changeLangButton setTitle:titleStr forState:UIControlStateNormal];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [rusSocket close];
    [engSocket close];
}

#pragma mark - UITableViewDataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *tableData = (isRusOn) ? rusTableData : engTableData;
    self.spinner.hidden = (tableData.count);
    return tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *tableData = (isRusOn) ? rusTableData : engTableData;
    
    // Get text
    NSString *text = tableData[[indexPath row]][@"message"];
    NSString *nickname = tableData[[indexPath row]][@"nickname"];
    
    NKChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
    NSString *fontStr = ([nickname isEqualToString:@"system"]) ? @"HelveticaNeue-Medium" : @"HelveticaNeue";
    UIFont *font = [UIFont fontWithName:fontStr size:17];
    UIFont *nicknameFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    
    if ([nickname isEqualToString:@"system"])
        [text stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
    
    NSDictionary *nicknameAttributes = @{NSFontAttributeName : nicknameFont,
                                         NSForegroundColorAttributeName : [UIColor colorWithRed:0.29f green:0.38f blue:0.62f alpha:1.00f]};
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : font}];
    NSMutableAttributedString *attributedNickname = [[NSMutableAttributedString alloc] initWithString:[nickname stringByAppendingString:@": "] attributes:nicknameAttributes];
    [attributedNickname appendAttributedString:attributedText];
    
    // Get height difference
    float heightDifference = [[NSString stringWithFormat:@"%@: %@", nickname, text] textHeightForCustomFont:[UIFont fontWithName:@"HelveticaNeue" size:20]] - 22;
    
    if (heightDifference < 0) heightDifference = 0;
    
    cell.bubbleView.layer.cornerRadius = 20;
    cell.bubbleView.layer.masksToBounds = YES;
    
    cell.bubleTextLabel.frame = CGRectMake(20, 13-2.5, 240, 22+heightDifference);
    cell.bubleTextLabel.numberOfLines = 0;
    cell.bubleTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.bubleTextLabel.attributedText = attributedNickname;
    
    // Resize bubble view
    cell.bubbleView.frame = CGRectMake(24,4,280,48+heightDifference);
    
    // Place bubble tail properly
    cell.bubbleTail.frame = CGRectMake(17,26+heightDifference,17,32);
    
    return cell;
}

#pragma mark - UITableViewDelegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *tableData = (isRusOn) ? rusTableData : engTableData;
    
    // Get height difference
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:20];
    NSString *text = tableData[[indexPath row]][@"message"];
    text = [NSString stringWithFormat:@"%@: %@",tableData[[indexPath row]][@"nickname"],text];
    float heightDifference = [text textHeightForCustomFont:font] - 22;
    
    if (heightDifference < 0) heightDifference = 0;
    
    return 57 + heightDifference;
}

#pragma mark - SRWebSocketDelegate -

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    // Format message string
    message = [[message stringByReplacingOccurrencesOfString:@"///" withString:@""] stringByReplacingOccurrencesOfString:@"\\\\\\" withString:@""];
    message = [message gtm_stringByUnescapingFromHTML];
    
    NSString *convertedString = [message mutableCopy];
    
    CFStringRef transform = CFSTR("Any-Hex/Java");
    CFStringTransform((__bridge CFMutableStringRef)convertedString, NULL, transform, YES);
    
    // Get event
    NSRange range = [convertedString rangeOfString:@"event\":\""];
    convertedString = [convertedString substringFromIndex:range.location+range.length];
    range = [convertedString rangeOfString:@"\""];
    NSString *event = [convertedString substringToIndex:range.location];
    
    // Exit if not message
    if (![event isEqualToString:@"msg"])
        return;
    
    // Get login
    range = [convertedString rangeOfString:@"login\":\""];
    convertedString = [convertedString substringFromIndex:range.location+range.length];
    range = [convertedString rangeOfString:@"\""];
    NSString *login = [convertedString substringToIndex:range.location];
    
    // Get message
    range = [convertedString rangeOfString:@"msg\":\""];
    convertedString = [convertedString substringFromIndex:range.location+range.length];
    range = [convertedString rangeOfString:@"\",\"msg_id\""];
    NSString *msg = [convertedString substringToIndex:range.location];
    
    NSMutableArray *tableData = ([webSocket isEqual:rusSocket]) ? rusTableData : engTableData;
    
    [tableData addObject:@{@"nickname":login,@"message":msg}];
    [self.chatTableView reloadData];
    
    if (([webSocket isEqual:rusSocket]) && isRusOn)
        [self scrollTableViewToTheBottomWithoutCheck:NO];
    else if ((![webSocket isEqual:rusSocket]) && !isRusOn)
        [self scrollTableViewToTheBottomWithoutCheck:NO];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSString *local = ([webSocket isEqual:rusSocket]) ? @"chat_ru" : @"chat_en";
    NSString *helloMsg = [NSString stringWithFormat:@"{\"event\":\"pusher:subscribe\",\"data\":{\"channel\":\"%@\"}}",local];
    [webSocket send:helloMsg];
}

#pragma mark - Buttons methods -

- (IBAction)backTouched:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changeLangTouched:(UIButton *)sender {
    if (isRusOn) {
        [sender setTitle:NSLocalizedString(@"Англ",nil) forState:UIControlStateNormal];
        isRusOn = NO;
    } else {
        [sender setTitle:NSLocalizedString(@"Рус",nil) forState:UIControlStateNormal];
        isRusOn = YES;
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(isRusOn) forKey:@"rusChatIsOn"];
    
    [self.chatTableView reloadData];
    [self scrollTableViewToTheBottomWithoutCheck:YES];
}

#pragma mark - General methods -

- (void)setupSockets
{
    NSURL *url = [NSURL URLWithString:@"wss://ws.pusherapp.com/app/4e0ebd7a8b66fa3554a4?protocol=6&client=js&version=2.0.0&flash=false"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    rusSocket = [[SRWebSocket alloc] initWithURLRequest:request];
    rusSocket.delegate = self;
    [rusSocket open];
    
    NSURLRequest *request2 = [NSURLRequest requestWithURL:url];
    
    engSocket = [[SRWebSocket alloc] initWithURLRequest:request2];
    engSocket.delegate = self;
    [engSocket open];
}

- (void)scrollTableViewToTheBottomWithoutCheck:(BOOL)check
{
    UIScrollView *scrollView = self.chatTableView;
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYoffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
    
    NSMutableArray *tableData = (isRusOn) ? rusTableData : engTableData;
    if (tableData.count > 0 && (distanceFromBottom <= height+200 || check))
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:tableData.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

@end
