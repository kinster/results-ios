//
//  LeagueFixtureDetailsViewController.h
//  Results
//
//  Created by Kinman Li on 03/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class Fixture;

@interface LeagueFixtureDetailsViewController : UIViewController<MKMapViewDelegate, ADBannerViewDelegate>
@property (weak, nonatomic) Fixture *fixture;
@property (weak, nonatomic) NSString *location;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)navigate:(id)sender;
@property (retain, nonatomic) MKMapItem *mapItem;
@property (weak, nonatomic) IBOutlet ADBannerView *adBannerView;
@end
