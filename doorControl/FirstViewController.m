//
//  FirstViewController.m
//  doorControl
//
//  Created by user on 9/27/12.
//  Copyright (c) 2012 cse4471. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

@synthesize locktop;


- (void)viewDidLoad
{
    [super viewDidLoad];
    recievedData = [[NSMutableData alloc]init];
    
    
    
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

- (IBAction)LockToggleAction:(id)sender {
    
    //ok just track a boolen...probably by extending the button class...
    
    isLocked = !isLocked;
    
    NSLog(@"toggleState is %d", isLocked);
    
    
    NSString *command;
    if(isLocked){
        [self showLocked];
        command = @"l";
    }else{
        command = @"u";
        [self showUnlocked];

    }
    

    
    //later this will be something more secure...like a salted hash of some auth string...
    NSString *myDeviceToken = [[UserSettings userSettings]deviceToken];
    
    NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc]init];
    //[postRequest setTimeoutInterval:30];
    NSString *postString = [NSString stringWithFormat:@"c=%@&devToken=%@", command, myDeviceToken];
    [postRequest sendPost:@"http://doorcontrol.theroyalwe.net/index.php" :postString delegate:self];
    
    
    
}



//methods for dealing with returned lockstate response...
/*
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
    NSString *postedLockState = [jsonResponse objectForKey:@"lockstate"];
    
    //this will need to be fixed...move to a toggle lock type thingie...
    
    

    if([postedLockState isEqualToString:@"false"]){
        self.lockToggleSwitchOutlet.on = false;
    }else if([postedLockState isEqualToString:@"true"]){
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

*/


-(void)showLocked{
    
    NSLog(@"Locked position : %f, %f", locktop.layer.position.x, locktop.layer.position.y);
    NSLog(@"Locked anchor: %f, %f", locktop.layer.anchorPoint.x, locktop.layer.anchorPoint.y);
    
    
    //locktop.layer.bounds = CGRectMake(0, 0, locktop.layer.bounds.size.width+100, locktop.layer.bounds.size.height);
    locktop.layer.anchorPoint = CGPointMake(0.120f, 0.5f);
    locktop.layer.position = CGPointMake(117, 177);
    
//    NSLog(@"dim %f, %f", locktop.bounds.size.width, locktop.bounds.size.height);
    
    [UIView animateWithDuration:1 animations:^{
        CATransform3D t = CATransform3DIdentity;
        
        t = CATransform3DRotate(t, M_PI, 0.0f, 1.0f, 0.0f);
        
        locktop.layer.transform = t;
        
        //        locktop.layer.transform = CATransform3DIdentity;
        
        
        
    }];
    
}

-(void)showUnlocked{
    
    NSLog(@"unLocked position : %f, %f", locktop.layer.position.x, locktop.layer.position.y);
    NSLog(@"unlocked anchor: %f, %f", locktop.layer.anchorPoint.x, locktop.layer.anchorPoint.y);
    
    locktop.layer.anchorPoint = CGPointMake(0.120f, 0.5f);
    locktop.layer.position = CGPointMake(119,177);
    
//    NSLog(@"dim %f, %f", locktop.bounds.size.width, locktop.bounds.size.height);
    
    [UIView animateWithDuration:1 animations:^{
        CATransform3D t = CATransform3DIdentity;
        
        t = CATransform3DRotate(t, M_PI, 0.0f, 0.0f, 0.0f);
        
        locktop.layer.transform = t;
        
        //        locktop.layer.transform = CATransform3DIdentity;
        
        
        
    }];
    
}


@end
