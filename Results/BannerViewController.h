//
//  BannerViewController.h
//  Grass Roots
//
//  Created by Kinman Li on 21/01/2013.
//  Copyright (c) 2013 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

extern NSString * const BannerViewActionWillBegin;
extern NSString * const BannerViewActionDidFinish;

@interface BannerViewController : UIViewController<ADBannerViewDelegate>
- (instancetype)initWithContentViewController:(UIViewController *)contentController;
@property (weak, nonatomic) IBOutlet ADBannerView *adBannerView;
@end
