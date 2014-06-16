/*
 * Copyright (c) 2013 Martin Hartl
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "MHCustomTabBarController.h"
#import "GADBannerView.h"

@implementation MHCustomTabBarController {
    GADBannerView *bannerView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _viewControllers = [NSMutableDictionary dictionary];
    
    if (!isPurchased) {
        [self setupAds];
        [self showAd];
    }
}

- (void)setupAds {
    // Create a view of the standard size at the top of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
    bannerView.frame = self.adView.frame;
    [self.adView removeFromSuperview];
    
    // Specify the ad's "unit identifier". This is your AdMob Publisher ID.
    bannerView.adUnitID = @"ca-app-pub-9811965100164265/3990299035";
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView.rootViewController = self;
    [self.view addSubview:bannerView];
    
    // Initiate a generic request to load it with an ad.
    GADRequest *request = [GADRequest request];
    //request.testDevices = [NSArray arrayWithObjects:@"d34c821dedbafd833c95d7d311739d66", nil];
    [bannerView loadRequest:request];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.presentingViewController beginAppearanceTransition: YES animated: animated];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.presentingViewController endAppearanceTransition];
    
    if (self.childViewControllers.count < 1) {
        [self performSegueWithIdentifier:@"SegueToMarket" sender:[_buttonView.subviews objectAtIndex:0]];
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self.presentingViewController beginAppearanceTransition: NO animated: animated];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [self.presentingViewController endAppearanceTransition];
}



#pragma mark - Rotation

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    for (UIViewController *vc  in self.childViewControllers) {
        [vc.view setFrame:self.container.bounds];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   
    self.oldViewController = self.destinationViewController;
    
    //if view controller isn't already contained in the viewControllers-Dictionary
    if (![[self.viewControllers allKeys] containsObject:segue.identifier]) {
        [self.viewControllers setObject:segue.destinationViewController forKey:segue.identifier];
    }
    
    for (UIView *subview in _buttonView.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            [((UIButton *)subview) setSelected:NO];
        }
    }
        
    UIButton *button = (UIButton *)sender;
    [button setSelected:YES];
    self.destinationIdentifier = segue.identifier;
    self.destinationViewController = [self.viewControllers objectForKey:self.destinationIdentifier];

    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([self.destinationIdentifier isEqual:identifier]) {
        //Dont perform segue, if visible ViewController is already the destination ViewController
        return NO;
    }
    
    return YES;
}

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [[self.viewControllers allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        if (![self.destinationIdentifier isEqualToString:key]) {
            [self.viewControllers removeObjectForKey:key];
        }
    }];
}

#pragma mark -
#pragma mark Added by Nikita Kolmogorov
#pragma mark -

- (void)showAd {
    // Change application view
    CGRect frame = self.container.frame;
    frame.size.height -= 50;
    self.container.frame = frame;
    
    // Change tabbar separator image view
    frame = self.tabbarSeparatorImageView.frame;
    frame.origin.y -= 50;
    self.tabbarSeparatorImageView.frame = frame;
    
    // Change tabbar view
    frame = self.buttonView.frame;
    frame.origin.y -= 50;
    self.buttonView.frame = frame;
    
    // Change add view
    frame = bannerView.frame;
    frame.origin.y -= 50;
    bannerView.frame = frame;
}

- (void)hideAd {
    // Change application view
    CGRect frame = self.container.frame;
    frame.size.height += 50;
    self.container.frame = frame;
    
    // Change tabbar separator image view
    frame = self.tabbarSeparatorImageView.frame;
    frame.origin.y += 50;
    self.tabbarSeparatorImageView.frame = frame;
    
    // Change tabbar view
    frame = self.buttonView.frame;
    frame.origin.y += 50;
    self.buttonView.frame = frame;
    
    // Change add view
    frame = bannerView.frame;
    frame.origin.y += 50;
    bannerView.frame = frame;
}

@end
