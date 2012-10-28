//
//  FirstViewController.m
//  doorControl
//
//  Created by user on 9/27/12.
//  Copyright (c) 2012 cse4471. All rights reserved.
//

#import "FirstViewController.h"
#import "NSMutableURLRequest+sendPost.h"
#import "UserSettings.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

@synthesize lockToggleSwitchOutlet;

- (void)viewDidLoad
{
    [super viewDidLoad];
    recievedData = [[NSMutableData alloc]init];
    
//    NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc]init];
//    [postRequest sendPost:@"http://doorcontrol.theroyalwe.net/" :nil delegate:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"view will appear");
    NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc]init];
    [postRequest sendPost:@"http://doorcontrol.theroyalwe.net/" :nil delegate:self];
    
    
}

- (IBAction)lockToggleSwitchAction:(id)sender {
    
    
    NSString *command;
    if(lockToggleSwitchOutlet.on){
        command = @"l";
    }else{
        command = @"u";
    }
    
    
    //later this will be something more secure...like a salted hash of some auth string...
    NSString *myDeviceToken = [[UserSettings userSettings]deviceToken];
    
    NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc]init];
    //[postRequest setTimeoutInterval:30];
    NSString *postString = [NSString stringWithFormat:@"c=%@&devToken=%@", command, myDeviceToken];
    [postRequest sendPost:@"http://doorcontrol.theroyalwe.net/index.php" :postString delegate:self];
    
    
    
}



//methods for dealing with returned lockstate response...

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
    //NSLog(@"Recieved some data!!! %@", recievedData);
    NSLog(@"data: %@", [[NSString alloc]initWithData:recievedData encoding:NSUTF8StringEncoding]);
    NSDictionary* jsonResponse = [NSJSONSerialization JSONObjectWithData:recievedData options:kNilOptions error:&err];
    if(err){
        NSLog(@"thrr was err: %@", err);
    }
    NSString *lockState = [jsonResponse objectForKey:@"lockstate"];
    if([lockState isEqualToString:@"false"]){
        self.lockToggleSwitchOutlet.on = false;
    }else if([lockState isEqualToString:@"true"]){
        self.lockToggleSwitchOutlet.on = true;
    }
    
    //clear recievedData so its ready for next toggle....
    recievedData = [[NSMutableData alloc]init];
    
    
}

-(void)processesMessage:(NSDictionary *)pushInfo{
    NSLog(@"processing info : %@", pushInfo);
    
    NSDictionary *extra = [pushInfo objectForKey:@"extra"];
    
    NSString *lockState = [extra objectForKey:@"lockstate"];
    
    if([lockState isEqualToString:@"false"]){
        lockToggleSwitchOutlet.on = false;
    }else if([lockState isEqualToString:@"true"]){
        lockToggleSwitchOutlet.on = true;
    }
    
}

@end
