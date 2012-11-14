//
//  SecondViewController.h
//  doorControl
//
//  Created by user on 9/27/12.
//  Copyright (c) 2012 cse4471. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Security/Security.h>

@interface SecondViewController : UIViewController
{
    SecKeyRef publicKey;
    SecKeyRef privateKey;
    NSData *publicTag;
    NSData *privateTag;
}



- (void)encryptWithPublicKey:(uint8_t *)plainBuffer cipherBuffer:(uint8_t *)cipherBuffer;
- (void)decryptWithPrivateKey:(uint8_t *)cipherBuffer plainBuffer:(uint8_t *)plainBuffer;
- (SecKeyRef)getPublicKeyRef;
- (SecKeyRef)getPrivateKeyRef;
- (void)testAsymmetricEncryptionAndDecryption;
- (void)generateKeyPair:(NSUInteger)keySize;

@end
