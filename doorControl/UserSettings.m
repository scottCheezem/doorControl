//
//  UserSettings.m
//  doorControl
//
//  Created by user on 10/26/12.
//  Copyright (c) 2012 cse4471. All rights reserved.
//

#import "UserSettings.h"

@implementation UserSettings
@synthesize deviceName, deviceToken;


-(id)init{
    self = [super init];
    if(self != nil){
        defaults = [NSUserDefaults standardUserDefaults];
        
        
        deviceName = [defaults stringForKey:@"devName"];
        if(deviceToken == nil) {
            deviceName = [[NSString alloc]init];
        }
        deviceToken = [defaults stringForKey:@"devToken"];
        if(deviceToken == nil){
            deviceToken = [[NSString alloc]init];
        }
        
        
    }
    return self;
}



-(void)setDeviceName:(NSString *)deviceName{

    [defaults setObject:deviceName forKey:@"devName"];
    
    
}


-(void)setDeviceToken:(NSString *)deviceToken{
    [defaults setObject:deviceToken forKey:@"devToken"];
    
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
