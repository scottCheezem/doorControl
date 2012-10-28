//
//  FirstViewController.h
//  doorControl
//
//  Created by user on 9/27/12.
//  Copyright (c) 2012 cse4471. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController{
    NSMutableData *recievedData;

}

-(void)processesMessage:(NSDictionary *)pushInfo;
- (IBAction)lockToggleSwitchAction:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *lockToggleSwitchOutlet;

@end
