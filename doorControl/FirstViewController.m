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
@synthesize LockButtonOutlet;
//@synthesize gaurdView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    recievedData = [[NSMutableData alloc]init];
    [self hideTheTabBarWithAnimation:YES];

    
}


-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
//    if(self.LockButtonOutlet.on){
//        [self showLocked];
//    }else{
//        [self showUnlocked];
//    }

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
    NSString *statusUrl = [NSString stringWithFormat:@"%@%@", SECURE_SEERVER_ADDRESS, @"status.php"];
    NSString *myDeviceToken = [[UserSettings userSettings]deviceToken];
    NSString *postString = [NSString stringWithFormat:@"&devToken=%@", myDeviceToken];
    [postRequest sendPost:statusUrl :postString delegate:self];
    
    
}

- (IBAction)LockButtonAction:(id)sender{
    
    //ok just track a boolen...probably by extending the button class...
    
    
    
    NSLog(@"toggleState is %d", self.LockButtonOutlet.on);
    
    
    NSString *command;
    if(self.LockButtonOutlet.on){
        //[self showLocked];
        command = @"l";
    }else{
        command = @"u";
        //[self showUnlocked];

    }
    

    
    //later this will be something more secure...like a salted hash of some auth string...
    NSString *myDeviceToken = [[UserSettings userSettings]deviceToken];
    
    NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc]init];
    //[postRequest setTimeoutInterval:30];
    NSString *postString = [NSString stringWithFormat:@"c=%@&devToken=%@", command, myDeviceToken];
    NSString *indexURL = [NSString stringWithFormat:@"%@%@", SECURE_SEERVER_ADDRESS, @"status.php"];
    [postRequest sendPost:indexURL :postString delegate:self];
    
    
    
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
    NSString *postedLockState = [jsonResponse objectForKey:@"lockstate"];
    NSString *isAuthed = [jsonResponse objectForKey:@"isAuthed"];
    NSString *isOwner = [jsonResponse objectForKey:@"isOwner"];
    //this will need to be fixed...move to a toggle lock type thingie...
    
    

    if([postedLockState isEqualToString:@"false"]){
        self.LockButtonOutlet.on = false;
        [self showUnlocked];
    }else if([postedLockState isEqualToString:@"true"]){
        self.LockButtonOutlet.on = true;
        [self showLocked];
    }
    
    if([isAuthed isEqualToString:@"true"]){
        LockButtonOutlet.enabled = YES;
    }else{
        LockButtonOutlet.enabled = NO;
    }
    
    
    if ([isOwner isEqualToString:@"true"]) {
        [self showTheTabBarWithAnimation:YES];
    }else{
        [self hideTheTabBarWithAnimation:YES];
    }
    
    //clear recievedData so its ready for next toggle....
    recievedData = [[NSMutableData alloc]init];
    
    
}




#pragma mark got a push payload
-(void)processesMessage:(NSDictionary *)pushInfo{
    NSLog(@"processing info : %@", pushInfo);
    
    NSDictionary *extra = [pushInfo objectForKey:@"extra"];
    
    NSString *lockState = [extra objectForKey:@"lockstate"];
    
    NSString *isAuthed = [extra objectForKey:@"isAuthed"];
    
    
    
    if(isAuthed!=nil){
        if([isAuthed isEqualToString:@"true"]){
            LockButtonOutlet.enabled = YES;
        }else{
            LockButtonOutlet.enabled = NO;
        }
    }

    if([lockState isEqualToString:@"false"]){
        self.LockButtonOutlet.on = false;
        [self showUnlocked];
    }else if([lockState isEqualToString:@"true"]){
        self.LockButtonOutlet.on = true;
        [self showLocked];
    }
    
}


#pragma mark Lock Animations

-(void)showUnlocked{
    
       
    locktop.layer.masksToBounds = NO;
    locktop.layer.anchorPoint = CGPointMake(0.0f, 0.5f);
    locktop.layer.position = CGPointMake(117, 176);

    
    [UIView animateWithDuration:1 animations:^{
        CATransform3D t = CATransform3DIdentity;
        
        t = CATransform3DRotate(t, M_PI, 0.0f, 1.0f, 0.0f);
        
        locktop.layer.transform = t;
        
    }];
    
}

-(void)showLocked{
    
  
    
    locktop.layer.masksToBounds = NO;
    locktop.layer.anchorPoint = CGPointMake(0.0f, 0.5f);
    locktop.layer.position = CGPointMake(117,176);
    

    
    [UIView animateWithDuration:1 animations:^{
        CATransform3D t = CATransform3DIdentity;
        
        t = CATransform3DRotate(t, M_PI, 0.0f, 0.0f, 0.0f);
        
        locktop.layer.transform = t;
        
        
    }];
    
}
#pragma mark hide/showTabBar
- (void) hideTheTabBarWithAnimation:(BOOL) withAnimation {
    if (NO == withAnimation) {
        [self.tabBarController.tabBar setHidden:YES];
    } else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:nil];
        [UIView setAnimationDuration:0.75];
        
        [self.tabBarController.tabBar setAlpha:0.0];
        
        [UIView commitAnimations];
    }
}

- (void) showTheTabBarWithAnimation:(BOOL) withAnimation {
    if (NO == withAnimation) {
        [self.tabBarController.tabBar setHidden:NO];
    } else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:nil];
        [UIView setAnimationDuration:0.75];
        
        [self.tabBarController.tabBar setAlpha:1.0];
        
        [UIView commitAnimations];
    }
}


@end
