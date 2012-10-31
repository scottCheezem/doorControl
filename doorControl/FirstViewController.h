//
//  FirstViewController.h
//  doorControl
//
//  Created by user on 9/27/12.
//  Copyright (c) 2012 cse4471. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "NSMutableURLRequest+sendPost.h"
#import "UserSettings.h"


@interface FirstViewController : UIViewController{
    NSMutableData *recievedData;
    BOOL isLocked;
}

-(void)processesMessage:(NSDictionary *)pushInfo;

@property (weak, nonatomic) IBOutlet UIImageView *locktop;

- (IBAction)LockToggleAction:(id)sender;









@end
