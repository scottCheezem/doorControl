//
//  NSMutableURLRequest+sendPost.h
//  doorControl
//
//  Created by user on 10/2/12.
//  Copyright (c) 2012 cse4471. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (sendPost)
-(void)sendPost:(NSString*)urlString :(NSString*)postString delegate:(id)delegate;
@end
