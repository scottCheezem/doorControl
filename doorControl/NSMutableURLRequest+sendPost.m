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
    
    NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc]initWithURL:url ];
    if(postString){
        NSLog(@"postString is %@", postString);
        [postRequest setHTTPMethod:@"POST"];
        [postRequest setValue:[NSString stringWithFormat:@"%d", postString.length] forHTTPHeaderField:@"Content-length"];
        [postRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        postRequest.timeoutInterval = 10;
        
    }

    NSLog(@"sending post %@", postRequest);
    [[NSURLConnection alloc]initWithRequest:postRequest delegate:delegate];
}



-(void)sendPostBasicAuth:(NSString*)urlString :(NSString*)userName :(NSString*)passWord :(NSString*)postString  delegate:(id)delegate{

    NSLog(@"Authenticating with %@", userName);
    NSString *authString = [NSString stringWithFormat:@"%@:%@", userName,passWord];
    NSData *authData = [authString dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
    
    NSURL *url = [[NSURL alloc]initWithString:urlString];
    
    NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc]initWithURL:url ];
    [postRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    if(postString){
        NSLog(@"postString is %@", postString);
        [postRequest setHTTPMethod:@"POST"];
        [postRequest setValue:[NSString stringWithFormat:@"%d", postString.length] forHTTPHeaderField:@"Content-length"];
        [postRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        postRequest.timeoutInterval = 10;
        
    }
    
    NSLog(@"sending authedpost %@", postRequest);
    [[NSURLConnection alloc]initWithRequest:postRequest delegate:delegate];
}

@end
