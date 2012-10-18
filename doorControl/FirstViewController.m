//
//  FirstViewController.m
//  doorControl
//
//  Created by user on 9/27/12.
//  Copyright (c) 2012 cse4471. All rights reserved.
//

#import "FirstViewController.h"
#import "NSMutableURLRequest+sendPost.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

@synthesize lockToggleButtonText;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)lockToggleButton:(id)sender {
    //send post to doorlock api...
    
    NSString *toggle = @"t";
    NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc]init];
    NSString *postString = [NSString stringWithFormat:@"c=%@&", toggle];
    [postRequest sendPost:@"http://doorcontrol.theroyalwe.net/index.php" :postString delegate:nil];
    
    
    //part of datarecieved delegate will deal with 
}
@end
