//
//  FirstViewController.h
//  doorControl
//
//  Created by user on 9/27/12.
//  Copyright (c) 2012 cse4471. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "LockToggleButton.h"

@interface FirstViewController : UIViewController{
    NSMutableData *recievedData;

}

-(void)processesMessage:(NSDictionary *)pushInfo;


- (IBAction)LockToggleAction:(id)sender;



@property (weak, nonatomic) IBOutlet UIImageView *locktop;

@property (weak, nonatomic) IBOutlet LockToggleButton *lockToggleSwitchOutlet;



@end
