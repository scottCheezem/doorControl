//
//  deviceViewController.h
//  doorControl
//
//  Created by user on 11/28/12.
//  Copyright (c) 2012 cse4471. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "doorControlDevice.h"
#import "NSMutableURLRequest+sendPost.h"
@interface deviceViewController : UIViewController
	
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *deviceTypeImageView;

@property (weak, nonatomic) IBOutlet UIButton *ownerButtonOutlet;
- (IBAction)ownerButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *authButtonOutlet;
- (IBAction)authButton:(id)sender;

@property(nonatomic, retain)doorControlDevice *device;
@end
