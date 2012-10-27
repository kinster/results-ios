//
//  ResultsViewController.m
//  Results
//
//  Created by Kinman Li on 20/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "ResultsViewController.h"
#import "Club.h"
#import "CustomTableCell.h"
#import "ClubDetailsViewController.h"

@interface ResultsViewController ()

@end

@implementation ResultsViewController

@synthesize clubList;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    clubList = [[NSMutableArray alloc] init];
    Club *club = nil;

    NSString *urlString = [NSString stringWithFormat:@"http://relatething.com/clubs.json"];
    
    NSLog(@"%@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSError *error;
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if (!jsonArray) {
        NSLog(@"%@", error);
    } else {
        NSLog(@"How many? %d", [jsonArray count]);

        for (NSDictionary *item in jsonArray) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                NSString *name = [item objectForKey:@"name"];
                NSString *badge = [item objectForKey:@"badge"];
                NSLog(@"%@ - %@", name, badge);
                club = [[Club alloc] initWithName:name AndBadge:badge];
                [clubList addObject: club];
            }
        }
    }
    [self loadView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [clubList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"CustomClubCell";
    
    CustomTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CustomTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    NSURL *imageUrl = [NSURL URLWithString:[[clubList objectAtIndex:indexPath.row]badge]];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageUrl];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.position.text = [NSString stringWithFormat:@"%d", indexPath.row+1];
    cell.badge.image = [[UIImage alloc]initWithData:imageData];
    cell.name.text = [[clubList objectAtIndex:indexPath.row]name];
    
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"In prepareForSegue");
    
    if ([[segue identifier] isEqualToString:@"ShowClubDetails"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"%d", indexPath.row);
        Club *selectedClub = [clubList objectAtIndex:indexPath.row];
        NSLog(@"%@", selectedClub.name);
        NSLog(@"%@", segue.destinationViewController);
        [segue.destinationViewController setClub:selectedClub];
    }
}

@end
