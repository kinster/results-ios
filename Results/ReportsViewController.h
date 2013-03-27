//
//  ReportsViewController.h
//  Grass Roots Premium
//
//  Created by Kinman Li on 26/03/2013.
//  Copyright (c) 2013 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Division, Result;

@interface ReportsViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) Division *division;
@property (weak, nonatomic) Result *result;
@property (weak, nonatomic) IBOutlet UIWebView *detailView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end
