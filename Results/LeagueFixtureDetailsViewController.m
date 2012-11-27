//
//  LeagueFixtureDetailsViewController.m
//  Results
//
//  Created by Kinman Li on 03/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "LeagueFixtureDetailsViewController.h"
#import "League.h"
#import "Season.h"
#import "Division.h"
#import "Team.h"
#import "Fixture.h"
#import "ServerManager.h"
#import "MBProgressHUD.h"

@interface LeagueFixtureDetailsViewController ()

@end

#define METERS_PER_MILE 1609.344

@implementation LeagueFixtureDetailsViewController {
    ADBannerView *_bannerView;
}

@synthesize division, fixture, mapView, location, mapItem;

- (void)loadNetworkExceptionAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"We are unable to make a internet connection at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)loadBanner {
    _bannerView = [[ADBannerView alloc] init];
    _bannerView.delegate = self;
    
    [self.view addSubview:_bannerView];
}

- (void)loadGeocodeExceptionAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"No location found for this Fixture" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle];
    [self loadBanner];

    if ([fixture.location caseInsensitiveCompare:@"TBA"] == NSOrderedSame) {
        DLog(@"Fixture Details Location length: %d", fixture.location.length);
        [self loadGeocodeExceptionAlert];
        return;
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.labelText = @"Searching...";
        [self.navigationController.view addSubview:hud];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            @try {
                NSError *error;
                
                ServerManager *serverManager = [ServerManager sharedServerManager];
                NSString *serverName = [serverManager serverName];
                
                Season *season = [division season];

                NSString *fixtureUrlString = [serverName stringByAppendingFormat:@"/leagues/%@/seasons/%@/divisions/%@/fixtures/%@.json", [season league].leagueId, season.seasonId, division.divisionId, fixture.fixtureId];
                
                DLog(@"Fixture url: %@", fixtureUrlString);
                
                NSURL *fixtureUrl = [NSURL URLWithString:fixtureUrlString];
                NSData *fixtureData = [NSData dataWithContentsOfURL:fixtureUrl];
                
                
                NSArray *fixtureJsonData = [NSJSONSerialization JSONObjectWithData:fixtureData options:NSJSONReadingMutableContainers error:&error];
                
                location = [fixtureJsonData objectAtIndex:0];
                
                CLGeocoder *geocoder = [[CLGeocoder alloc] init];
                
                [geocoder geocodeAddressString:location
                    completionHandler:^(NSArray *placemarks, NSError *error) {
        
                    if (error) {
                        NSLog(@"Geocode failed with error: %@", error);
                        [self loadGeocodeExceptionAlert];
                        return;
                    }

                    DLog(@"location %@:", [self location]);

                    if (placemarks && placemarks.count > 0) {
                        CLPlacemark *placemark = placemarks[0];
                        CLLocation *newLocation = placemark.location;
                        CLLocationCoordinate2D coords = newLocation.coordinate;
                        DLog(@"Location = %@, Latitude = %f, Longitude = %f", [self location],
                            coords.latitude, coords.longitude);
                        MKPlacemark *mkPlacemark = [[MKPlacemark alloc] initWithPlacemark:placemark];

                        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coords, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
                        [mapView setRegion:viewRegion animated:YES];
                        [mapView addAnnotation:mkPlacemark];
                        
                        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                        annotation.coordinate = coords;
                        [mapView addAnnotation:annotation];


                        mapItem = [[MKMapItem alloc] initWithPlacemark:mkPlacemark];
                    }
                }];
                // done
            } @catch (NSException *exception) {
                NSLog(@"Exception: %@ %@", [exception name], [exception reason]);
                [self loadNetworkExceptionAlert];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            });
        });
    }
}

- (MKAnnotationView *) mapView:(MKMapView *)aMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    NSString *title = annotation.title;
    MKPinAnnotationView *pinView=(MKPinAnnotationView *)[aMapView dequeueReusableAnnotationViewWithIdentifier:title];
    
    if (pinView == nil) {
        pinView=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:title];
    }
    pinView.canShowCallout=YES;
    pinView.animatesDrop=YES;
    
    
    return pinView;

}

- (void)setNavTitle {
    self.tabBarController.title = @"Fixture Details";
}

- (void)viewWillAppear:(BOOL)animated {
    [self setNavTitle];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)navigate:(id)sender {
    DLog(@"navigate");
    [mapItem openInMapsWithLaunchOptions:nil];
}

- (void)viewDidLayoutSubviews {
    [_bannerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    CGRect contentFrame = self.view.bounds;
    CGRect bannerFrame = _bannerView.frame;
    if (_bannerView.bannerLoaded) {
        contentFrame.size.height -= _bannerView.frame.size.height;
        bannerFrame.origin.y = contentFrame.size.height;
    } else {
        bannerFrame.origin.y = contentFrame.size.height;
    }
    _bannerView.frame = bannerFrame;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [UIView animateWithDuration:0.25 animations:^{
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    [UIView animateWithDuration:0.25 animations:^{
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BannerViewActionWillBegin" object:self];
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BannerViewActionDidFinish" object:self];
}

@end
