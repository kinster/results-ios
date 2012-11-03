//
//  ClubDetailsViewController.m
//  Results
//
//  Created by Kinman Li on 25/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "TeamDetailsViewController.h"
#import "Club.h"

@interface TeamDetailsViewController ()

@end

@implementation TeamDetailsViewController

@synthesize position, name, badge, teamId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error;
    
    NSString *restfulUrl = [[NSString alloc]initWithFormat:@"http://localhost:3000/leagues/1/seasons/1/divisions/1/teams/"];
    
    NSString *urlString = [restfulUrl stringByAppendingFormat:@"%@%@", teamId, @".json"];

    NSLog(@"%@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSDictionary *jsonTeam = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

    NSLog(@"jsonTeam: %@", jsonTeam);
    
    NSDictionary *clubJson = [jsonTeam objectForKey:@"club"];
    
    NSLog(@"%@", clubJson);
    
    NSString *clubBadgeJson = [clubJson objectForKey:@"badge"];
    NSString *clubNameJson = [clubJson objectForKey:@"name"];
    
    name.text = clubNameJson;
    
    NSURL *imageUrl = [NSURL URLWithString:clubBadgeJson];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageUrl];
    
    badge.image = [[UIImage alloc]initWithData:imageData];

    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
