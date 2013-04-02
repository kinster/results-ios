//
//  ReportsViewController.h
//  Grass Roots Premium
//
//  Created by Kinman Li on 26/03/2013.
//  Copyright (c) 2013 Kinman Li. All rights reserved.
//

@class Division, Result, Report;

@interface ReportsViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) Report *report;
@property (weak, nonatomic) IBOutlet UIWebView *detailView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end
