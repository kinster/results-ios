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
#import "AppDelegate.h"

@interface LeagueFixtureDetailsViewController ()

@end

#define METERS_PER_MILE 1609.344

@implementation LeagueFixtureDetailsViewController

@synthesize fixture, mapView, location, mapItem, adBannerView;

- (void)loadNetworkExceptionAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"We are unable to make a internet connection at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)loadGeocodeExceptionAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"No location found for this Fixture" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    DLog(@"bannerViewDidLoadAd loaded %d", banner.isBannerLoaded);
    banner.hidden = NO;
    [self toggleBanner:banner];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    DLog(@"didFailToReceiveAdWithError loaded %d", banner.isBannerLoaded);
    banner.hidden = YES;
    [self toggleBanner:banner];
}

- (void)toggleBanner:(ADBannerView *)banner {
    CGRect bannerFrame = banner.frame;
    CGRect contentFrame = self.view.frame;
    DLog(@"Content height %f %@", contentFrame.size.height, banner);
    if ([banner isBannerLoaded]) {
        DLog(@"Has ad, showing");
        contentFrame.size.height -= banner.frame.size.height;
        bannerFrame.origin.y = contentFrame.size.height;
    } else {
        DLog(@"No ad, hiding");
        bannerFrame.origin.y = contentFrame.size.height;
    }
    banner.frame = bannerFrame;
    self.mapView.frame = CGRectMake(mapView.frame.origin.x,mapView.frame.origin.y,mapView.frame.size.width,contentFrame.size.height);
    
    DLog(@"New content height %@ %f %f %f %f", banner, contentFrame.size.height, banner.frame.origin.y, adBannerView.frame.origin.y, mapView.frame.size.height);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavTitle];
    [self setAdBannerView:AppDelegate.adBannerView];
    DLog(@"LeagueFixtureDetailsViewController viewWillAppear %@", self.adBannerView);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setNavTitle];
    [self setAdBannerView:AppDelegate.adBannerView];
    DLog(@"LeagueFixtureDetailsViewController viewDidAppear %@", adBannerView);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.adBannerView setDelegate:nil];
    [self setAdBannerView:nil];
    [self.adBannerView removeFromSuperview];
    DLog(@"LeagueFixtureDetailsViewController viewWillDisappear %@", self.adBannerView);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.adBannerView setDelegate:nil];
    [self setAdBannerView:nil];
    [self.adBannerView removeFromSuperview];
    DLog(@"LeagueFixtureDetailsViewController viewDidDisappear %@", self.adBannerView);
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self.adBannerView setDelegate:nil];
    [self setAdBannerView:nil];
    DLog(@"LeagueFixtureDetailsViewController viewDidUnload %@", self.adBannerView);
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle];

    adBannerView.delegate = self;
    adBannerView.hidden = YES;

    
    if ([fixture.location caseInsensitiveCompare:@"TBA"] == NSOrderedSame) {
        DLog(@"Fixture Details Location length: %d", fixture.location.length);
        [self loadGeocodeExceptionAlert];
        return;
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.labelText = @"Searching...";
        [self.navigationController.view addSubview:hud];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
    //        [self loadBanner];
            @try {
                NSError *error;
                
                ServerManager *serverManager = [ServerManager sharedServerManager];
                NSString *serverName = [serverManager serverName];
                
                Division *division = [fixture division];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)navigate:(id)sender {
    DLog(@"navigate");
    [mapItem openInMapsWithLaunchOptions:nil];
}

@end
