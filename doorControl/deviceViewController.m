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
	
	// Do any additional setup after loading the view.
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
	
}
-(void)takeOwnerDevice{
	NSMutableURLRequest *post = [[NSMutableURLRequest alloc]init];
	NSString *postUrl = [NSString stringWithFormat:@"%@%@", SECURE_SEERVER_ADDRESS, @"admin/authorizeDevice.php"];
	NSString *postParams = [NSString stringWithFormat:@"takeowner=%@", self.device.pid];
	[post sendPost:postUrl :postParams delegate:nil];

	
}
-(void)authDevice{
	NSMutableURLRequest *post = [[NSMutableURLRequest alloc]init];
	NSString *postUrl = [NSString stringWithFormat:@"%@%@", SECURE_SEERVER_ADDRESS, @"admin/authorizeDevice.php"];
	NSString *postParams = [NSString stringWithFormat:@"authid=%@", self.device.pid];
	[post sendPost:postUrl :postParams delegate:nil];

}

-(void)deAuthDevice{
	NSMutableURLRequest *post = [[NSMutableURLRequest alloc]init];
	NSString *postUrl = [NSString stringWithFormat:@"%@%@", SECURE_SEERVER_ADDRESS, @"admin/authorizeDevice.php"];
	NSString *postParams = [NSString stringWithFormat:@"deauthid=%@", self.device.pid];
	[post sendPost:postUrl :postParams delegate:nil];

}

@end
