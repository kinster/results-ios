//
//  LeagueFixtureDetailsViewController.h
//  Results
//
//  Created by Kinman Li on 03/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <MapKit/MapKit.h>

@class Division, Fixture;

@interface LeagueFixtureDetailsViewController : UIViewController<ADBannerViewDelegate, MKMapViewDelegate> {
    ADBannerView *bannerView;
}
@property (weak, nonatomic) Division *division;
@property (weak, nonatomic) Fixture *fixture;
@property (weak, nonatomic) NSString *location;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)navigate:(id)sender;
@property (retain, nonatomic) MKMapItem *mapItem;
@end
