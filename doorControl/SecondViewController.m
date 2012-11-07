//
//  SecondViewController.m
//  doorControl
//
//  Created by user on 9/27/12.
//  Copyright (c) 2012 cse4471. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

static const UInt8 publicKeyIdentifier[] = "net.theroyalwe.doorControl.publicKey\0";
static const UInt8 privateKeyIdentifier[] = "net.theroyalwe.doorControl.privateKey\0";





- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)generateKeyPairPlease{
    
    OSStatus status = noErr;
    
    NSMutableDictionary *privateKeyAttr = [[NSMutableDictionary alloc]init];
    
    NSMutableDictionary *publicKeyAttr = [[NSMutableDictionary alloc]init];
    
    NSMutableDictionary *keyPairAttr= [[NSMutableDictionary alloc]init];
    
    NSData *publicTag = [NSData dataWithBytes:publicKeyIdentifier length:strlen((const char *)publicKeyIdentifier)];
    NSData *privateTag = [NSData dataWithBytes:privateKeyIdentifier length:strlen((const char *)privateKeyIdentifier)];

    SecKeyRef publicKey = NULL;
    SecKeyRef privateKey = NULL;
    
    [keyPairAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [keyPairAttr setObject:[NSNumber numberWithInt:1024] forKey:(__bridge id)kSecAttrKeySizeInBits];
    
    [privateKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent];
    [privateKeyAttr setObject:privateTag forKey:(__bridge id)kSecAttrApplicationTag];
    
    [publicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrKeyType];
    [publicKeyAttr setObject:publicTag forKey:(__bridge id)kSecAttrApplicationTag];
    
    [keyPairAttr setObject:privateKeyAttr forKey:(__bridge id)kSecPrivateKeyAttrs];
    [keyPairAttr setObject:publicKeyAttr forKey:(__bridge id)kSecPublicKeyAttrs];
    
    status = SecKeyGeneratePair((__bridge CFDictionaryRef)keyPairAttr, &publicKey, &privateKey);
    
    
    
    if(publicKey) CFRelease(publicKey);
    if(privateKey) CFRelease(privateKey);
    
    
}

- (void)encryptWithPublicKey
{
    OSStatus status = noErr;
    
    size_t cipherBufferSize;
    uint8_t *cipherBuffer;                     // 1
    
    // [cipherBufferSize]
    const uint8_t nonce[] = "the quick brown fox jumps over the lazy dog\0"; // 2
    
    SecKeyRef publicKey = NULL;                                 // 3
    
    NSData * publicTag = [NSData dataWithBytes:publicKeyIdentifier length:strlen((const char *)publicKeyIdentifier)]; // 4
    
    NSMutableDictionary *queryPublicKey =
    [[NSMutableDictionary alloc] init]; // 5
    
    [queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryPublicKey setObject:publicTag forKey:(__bridge id)kSecAttrApplicationTag];
    [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [queryPublicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    // 6
    
    status = SecItemCopyMatching
    ((__bridge CFDictionaryRef)queryPublicKey, (CFTypeRef *)&publicKey); // 7
    
    //  Allocate a buffer
    
    cipherBufferSize = cipherBufferSize(publicKey);
    cipherBuffer = malloc(cipherBufferSize);
    
    //  Error handling
    
    if (cipherBufferSize < sizeof(nonce)) {
        // Ordinarily, you would split the data up into blocks
        // equal to cipherBufferSize, with the last block being
        // shorter. For simplicity, this example assumes that
        // the data is short enough to fit.
        printf("Could not decrypt.  Packet too large.\n");
        return;
    }
    
    // Encrypt using the public.
    status = SecKeyEncrypt(    publicKey,
                           kSecPaddingPKCS1,
                           nonce,
                           (size_t) sizeof(nonce)/sizeof(nonce[0]),
                           cipherBuffer,
                           &cipherBufferSize
                           );                              // 8
    
    //  Error handling
    //  Store or transmit the encrypted text
    
    if(publicKey) CFRelease(publicKey);
//    if(queryPublicKey) [queryPublicKey release];                // 9
    free(cipherBuffer);
}

@end
