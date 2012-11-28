//
//  FirstViewController.h
//  doorControl
//
//  Created by user on 9/27/12.
//  Copyright (c) 2012 cse4471. All rights reserved.
//


#define SECURE_SEERVER_ADDRESS @"http://192.168.2.1/"
#define SERVER_ADDRESS @"http://doorcontrol.theroyalwe.net/"


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "NSMutableURLRequest+sendPost.h"
#import "UserSettings.h"
#import "LockButton.h"


@interface FirstViewController : UIViewController{
    NSMutableData *recievedData;
}

-(void)processesMessage:(NSDictionary *)pushInfo;

@property (weak, nonatomic) IBOutlet UIView *locktop;




- (IBAction)LockButtonAction:(id)sender;


@property (weak, nonatomic) IBOutlet LockButton *LockButtonOutlet;


//@property (weak, nonatomic) IBOutlet UIView *gaurdView;





@end
