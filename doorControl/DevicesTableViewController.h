//
//  DevicesTableViewController.h
//  doorControl
//
//  Created by user on 11/28/12.
//  Copyright (c) 2012 cse4471. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"
#import "NSMutableURLRequest+sendPost.h"
#import "doorControlDevice.h"
#import "deviceViewController.h"
#import "UserSettings.h"

@interface DevicesTableViewController : UITableViewController<UITableViewDelegate>{
	NSMutableData *recievedData;
	NSMutableArray *devices;

}

@end
