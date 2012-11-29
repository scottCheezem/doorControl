//
//  DevicesTableViewController.m
//  doorControl
//
//  Created by user on 11/28/12.
//  Copyright (c) 2012 cse4471. All rights reserved.
//

#import "DevicesTableViewController.h"

@interface DevicesTableViewController ()

@end

@implementation DevicesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	
	recievedData = [[NSMutableData alloc]init];
	devices = [[NSMutableArray alloc]init];
	
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc]init];
	NSString *deviceListUrl = [NSString stringWithFormat:@"%@%@", SECURE_SEERVER_ADDRESS, @"admin/deviceList.php"];
	[postRequest sendPost:deviceListUrl :nil delegate:self];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"deviceCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
	cell.textLabel.text = [[devices objectAtIndex:indexPath.row]deviceName];
	
	
    
    return cell;
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


#pragma mark connection methods

-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error{
    
    NSLog(@"Error %@ when connecting", error);
    
    //put an alert box here to alert user!
}
-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data{
    //append some data
    
	
    [recievedData appendData:data];
    
    
}
-(void)connectionDidFinishLoading:(NSURLConnection*)connection{
    
    NSError *err;
    
    NSLog(@"finished loading");
    NSLog(@"Recieved some data!!! %@", recievedData);
    NSLog(@"data: %@", [[NSString alloc]initWithData:recievedData encoding:NSUTF8StringEncoding]);
    NSDictionary* jsonResponse = [NSJSONSerialization JSONObjectWithData:recievedData options:kNilOptions error:&err];
    if(err){
        NSLog(@"thrr was err: %@", err);
    }
    

	NSArray* devicesJson =[jsonResponse objectForKey:@"devices"];
	
	for (NSDictionary *jsonDeviceDictioanry in devicesJson){
		
		//so you or anyone else can't deauthorized your self from your own handset
		if(![[jsonDeviceDictioanry objectForKey:@"deviceToken"] isEqualToString:[[UserSettings userSettings]deviceToken]]){
		
			doorControlDevice *dcDevice = [[doorControlDevice alloc]init];
			dcDevice.pid = [jsonDeviceDictioanry objectForKey:@"pid"];
			dcDevice.deviceName = [jsonDeviceDictioanry objectForKey:@"devicename"];
			dcDevice.deviceType = [jsonDeviceDictioanry objectForKey:@"devicetype"];
			NSNumber *isOwner = (NSNumber*)[jsonDeviceDictioanry objectForKey:@"isOwner"];
			if(isOwner && [isOwner boolValue]){
				dcDevice.isOwner = YES;
			}else{
				dcDevice.isOwner = NO;
			}
			if([[jsonDeviceDictioanry objectForKey:@"pid"] isEqualToString:[jsonDeviceDictioanry objectForKey:@"aid"]] ){
				dcDevice.isAuthed = YES;
			}else{
				dcDevice.isAuthed = NO;
			}
			[devices addObject:dcDevice];

		}
		
	}
    
    
	
        
    //clear recievedData so its ready for next toggle....
    recievedData = [[NSMutableData alloc]init];
    [self.tableView reloadData];
    
}






@end
