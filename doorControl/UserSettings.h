//
//  UserSettings.h
//  doorControl
//
//  Created by user on 10/26/12.
//  Copyright (c) 2012 cse4471. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSettings : NSObject{
    NSUserDefaults *defaults;
    NSString *deviceToken;
    NSString *deviceName;
}


//@property(nonatomic, retain)NSString* deviceToken;
//@property(nonatomic, retain)NSString* deviceName;
-(NSString*)deviceToken;
-(NSString*)deviceName;
-(void)setDeviceName:(NSString *)deviceName;
-(void)setDeviceToken:(NSString *)deviceToken;
+(UserSettings*)userSettings;



@end
