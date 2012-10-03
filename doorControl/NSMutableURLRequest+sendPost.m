//
//  NSMutableURLRequest+sendPost.m
//  doorControl
//
//  Created by user on 10/2/12.
//  Copyright (c) 2012 cse4471. All rights reserved.
//

#import "NSMutableURLRequest+sendPost.h"

@implementation NSMutableURLRequest (sendPost)
-(void)sendPost:(NSString*)urlString :(NSString*)postString delegate:(id)delegate{
    
    NSURL *url = [[NSURL alloc]initWithString:urlString];
    
    NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc]initWithURL:url];
    if(postString){
        NSLog(@"postString is %@", postString);
        [postRequest setHTTPMethod:@"POST"];
        //NSString *postString = [[NSString alloc]initWithFormat:@"showid=%@", showdetailsId];
        [postRequest setValue:[NSString stringWithFormat:@"%d", postString.length] forHTTPHeaderField:@"Content-length"];
        [postRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        postRequest.timeoutInterval = 10;
        
    }
    NSLog(@"sending device id request %@", postRequest);
    [[NSURLConnection alloc]initWithRequest:postRequest delegate:delegate];
}
@end
