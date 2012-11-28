//
//  doorControlDevice.h
//  doorControl
//
//  Created by user on 11/28/12.
//  Copyright (c) 2012 cse4471. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface doorControlDevice : NSObject


@property(nonatomic, retain)NSString* pid;
@property(nonatomic, retain)NSString* aid;
@property(nonatomic)BOOL isOwner;
@property(nonatomic, retain)NSString* deviceName;
@property(nonatomic, retain)NSString* deviceType;

@end
