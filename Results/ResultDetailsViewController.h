//
//  ResultDetailsViewController.h
//  nel
//
//  Created by Kinman Li on 30/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

@class Result;

@interface ResultDetailsViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) Result *result;
@property (weak, nonatomic) IBOutlet UIWebView *reportWebView;
@property (weak, nonatomic) IBOutlet UILabel *homeLabel;
@property (weak, nonatomic) IBOutlet UILabel *awayLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeScore;
@property (weak, nonatomic) IBOutlet UILabel *awayScore;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end
