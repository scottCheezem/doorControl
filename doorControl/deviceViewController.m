//
//  deviceViewController.m
//  doorControl
//
//  Created by user on 11/28/12.
//  Copyright (c) 2012 cse4471. All rights reserved.
//

#import "deviceViewController.h"

@interface deviceViewController ()

@end

@implementation deviceViewController


@synthesize deviceNameLabel,deviceTypeImageView,ownerButtonOutlet,authButtonOutlet,device;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	recievedData = [[NSMutableData alloc]init];
	
	//can we do something with the date here? a better time representation.
	self.deviceNameLabel.text=self.device.registereTime;
	
	if([self.device.deviceType isEqualToString:@"iPhone"]){
	self.deviceTypeImageView.image = [UIImage imageNamed:@"iphoneDevice.png"];
	}
	
	//if([self.device.deviceType isEqualToString:@"iPad"]){
	else{
		self.deviceTypeImageView.image = [UIImage imageNamed:@"ipadDevice.png"];
	}
	//you can't make someone an owner who isn't an authorized device...
	//I'm pretty sure that how I set it up in the API...but just in case we'll try to cover it here..
	[self refreshView];
		
	// Do any additional setup after loading the view.
}

-(void)refreshView{
	//self.ownerButtonOutlet.enabled = NO;
	if(self.device.isAuthed){
		self.authButtonOutlet.titleLabel.text = @"DeAuthorize";
		
	}else{
		self.authButtonOutlet.titleLabel.text = @"Authorize";
	}
	if(self.device.isOwner){
		self.ownerButtonOutlet.titleLabel.text = @"Take OwnerShip";
	}else{
		self.ownerButtonOutlet.titleLabel.text = @"Make Owner Device";
	}

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ownerButton:(id)sender {
 
	if(self.device.isOwner){
		[self takeOwnerDevice];
	}else{
		[self makeOwnerDevice];
	}
	
	
}
- (IBAction)authButton:(id)sender {
	if(self.device.isAuthed){
		[self deAuthDevice];
	}else{
		[self authDevice];
	}
}

#pragma mark OwnerShip API methods
-(void)makeOwnerDevice{
	NSMutableURLRequest *post = [[NSMutableURLRequest alloc]init];
	NSString *postUrl = [NSString stringWithFormat:@"%@%@", SECURE_SEERVER_ADDRESS, @"admin/authorizeDevice.php"];
	NSString *postParams = [NSString stringWithFormat:@"makeowner=%@", self.device.pid];
	[post sendPost:postUrl :postParams delegate:nil];
	[self refreshDevice];
	
}
-(void)takeOwnerDevice{
	NSMutableURLRequest *post = [[NSMutableURLRequest alloc]init];
	NSString *postUrl = [NSString stringWithFormat:@"%@%@", SECURE_SEERVER_ADDRESS, @"admin/authorizeDevice.php"];
	NSString *postParams = [NSString stringWithFormat:@"takeowner=%@", self.device.pid];
	[post sendPost:postUrl :postParams delegate:nil];
	[self refreshDevice];

	
}
-(void)authDevice{
	NSMutableURLRequest *post = [[NSMutableURLRequest alloc]init];
	NSString *postUrl = [NSString stringWithFormat:@"%@%@", SECURE_SEERVER_ADDRESS, @"admin/authorizeDevice.php"];
	NSString *postParams = [NSString stringWithFormat:@"authid=%@", self.device.pid];
	[post sendPost:postUrl :postParams delegate:nil];
	[self refreshDevice];

}

-(void)deAuthDevice{
	NSMutableURLRequest *post = [[NSMutableURLRequest alloc]init];
	NSString *postUrl = [NSString stringWithFormat:@"%@%@", SECURE_SEERVER_ADDRESS, @"admin/authorizeDevice.php"];
	NSString *postParams = [NSString stringWithFormat:@"deauthid=%@", self.device.pid];
	[post sendPost:postUrl :postParams delegate:nil];
	[self refreshDevice];

}

-(void)refreshDevice{

	NSMutableURLRequest *post = [[NSMutableURLRequest alloc]init];
	NSString *postUrl = [NSString stringWithFormat:@"%@%@", SECURE_SEERVER_ADDRESS, @"admin/deviceList.php"];
	NSString *postParams = [NSString stringWithFormat:@"id=%@", self.device.pid];
	[post sendPost:postUrl :postParams delegate:self];

	
}

#pragma mark Connection Delegate Methods

//methods for dealing with returned lockstate response...


/*
 //other delegate methods...
 -(BOOL)connection:(NSURLConnection*)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace{
 
 return YES;
 }
 
 -(void)connection:(NSURLConnection*)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
 
 }*/


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
	
	//this post will only ever return one device...
	for (NSDictionary *jsonDeviceDictioanry in devicesJson){
		
		//so you or anyone else can't deauthorized your self from your own handset
		
		
		doorControlDevice *dcDevice = [[doorControlDevice alloc]init];
		dcDevice.pid = [jsonDeviceDictioanry objectForKey:@"pid"];
		dcDevice.deviceName = [jsonDeviceDictioanry objectForKey:@"devicename"];
		dcDevice.deviceType = [jsonDeviceDictioanry objectForKey:@"devicetype"];
		dcDevice.registereTime = [jsonDeviceDictioanry objectForKey:@"registertime"];
		
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
		self.device = dcDevice;
			
		
		
	}
	
        
    //clear recievedData so its ready for next toggle....
    recievedData = [[NSMutableData alloc]init];
    [self refreshView];
    
}





@end
