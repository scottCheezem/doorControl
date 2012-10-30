//
//  LockToggleButton.m
//  doorControl
//
//  Created by user on 10/29/12.
//  Copyright (c) 2012 cse4471. All rights reserved.
//

#import "LockToggleButton.h"



@implementation LockToggleButton

@synthesize on;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.on = true;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/




@end
