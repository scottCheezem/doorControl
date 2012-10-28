//
//  UserSettings.m
//  doorControl
//
//  Created by user on 10/26/12.
//  Copyright (c) 2012 cse4471. All rights reserved.
//

#import "UserSettings.h"

@implementation UserSettings
//@synthesize deviceName, deviceToken;


-(id)init{
    self = [super init];
    if(self != nil){
        defaults = [NSUserDefaults standardUserDefaults];
        
        
        deviceName = [defaults stringForKey:@"devName"];
        if(deviceName == nil) {
            deviceName = [[NSString alloc]init];
        }
        
        deviceToken = [defaults stringForKey:@"devToken"];
        if(deviceToken == nil){
            deviceToken = [[NSString alloc]init];
        }
        
        
    }
    return self;
}



-(void)setDeviceName:(NSString *)_deviceName{

    [defaults setObject:_deviceName forKey:@"devName"];
    //self.deviceName = _deviceName;
    
    
}


-(void)setDeviceToken:(NSString *)_deviceToken{
    [defaults setObject:_deviceToken forKey:@"devToken"];
    //self.deviceToken = _deviceToken;
    
}

-(NSString*)deviceToken{
    
    return [defaults objectForKey:@"devToken"];
    
}

-(NSString*)deviceName{
    return [defaults objectForKey:@"devName"];
}


+(UserSettings*)userSettings{
    static UserSettings *userSettings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userSettings = [[self alloc]init];
    });
    
    return userSettings;
    
}


@end
