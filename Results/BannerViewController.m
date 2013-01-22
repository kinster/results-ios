//
//  BannerViewController.m
//  Grass Roots
//
//  Created by Kinman Li on 21/01/2013.
//  Copyright (c) 2013 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "AppDelegate.h"
#import "BannerViewController.h"

NSString * const BannerViewActionWillBegin = @"BannerViewActionWillBegin";
NSString * const BannerViewActionDidFinish = @"BannerViewActionDidFinish";

@interface BannerViewController ()

@end

@implementation BannerViewController {
    UIViewController *_contentController;
}

@synthesize adBannerView;

- (instancetype)initWithContentViewController:(UIViewController *)contentController {
    self = [super init];
    [self setAdBannerView:AppDelegate.adBannerView];
    if (self != nil) {
        // On iOS 6 ADBannerView introduces a new initializer, use it when available.
        adBannerView.delegate = self;
        _contentController = contentController;
        NSLog(@"bannerView & contentController: %@ %@", adBannerView, _contentController);
    }
    return self;
}

- (void)loadView {
    UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [contentView addSubview:adBannerView];
    [self addChildViewController:_contentController];
    [contentView addSubview:_contentController.view];
    [_contentController didMoveToParentViewController:self];
    self.view = contentView;
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [_contentController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}
#endif

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [_contentController preferredInterfaceOrientationForPresentation];
}

- (NSUInteger)supportedInterfaceOrientations {
    return [_contentController supportedInterfaceOrientations];
}

- (void)viewDidLayoutSubviews {
    [self toggleBanner:adBannerView];
}

- (void)toggleBanner:(ADBannerView *)banner {
    CGRect bannerFrame = banner.frame;
    CGRect contentFrame = [UIScreen mainScreen].bounds;
    CGFloat height = contentFrame.size.height-banner.frame.size.height-25;

    NSLog(@"Content height %f %@", height, _contentController);
    if ([banner isBannerLoaded]) {
        NSLog(@"Has ad, showing");
        contentFrame.size.height -= banner.frame.size.height+25;
        bannerFrame.origin.y = height;
    } else {
        NSLog(@"No ad, hiding");
        contentFrame.size.height -= banner.frame.size.height-25;
        bannerFrame.origin.y = height-25;
    }
    _contentController.view.frame = contentFrame;
    banner.frame = bannerFrame;
    NSLog(@"toggleBanner %@", banner);
}



- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    NSLog(@"bannerViewDidLoadAd ad");
    [self toggleBanner:banner];
    NSLog(@"bannerViewDidLoadAd ad inside %f", _contentController.view.bounds.size.height);
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"didFailToReceiveAdWithError no ad");
    [self toggleBanner:banner];
    NSLog(@"didFailToReceiveAdWithError no ad inside %f", _contentController.view.bounds.size.height);
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    NSLog(@"bannerViewActionShouldBegin");
    [[NSNotificationCenter defaultCenter] postNotificationName:BannerViewActionWillBegin object:self];
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
    NSLog(@"bannerViewActionDidFinish");
    [[NSNotificationCenter defaultCenter] postNotificationName:BannerViewActionDidFinish object:self];
}

@end