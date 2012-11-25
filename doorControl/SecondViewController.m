/*I love you stackoverflow!!!
 
 http://stackoverflow.com/questions/10072124/iphone-how-to-encrypt-nsdata-with-private-key-and-decrypt-with-public-key
 
 */


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

const size_t BUFFER_SIZE = 64;
const size_t CIPHER_BUFFER_SIZE = 1024;
const uint32_t PADDING = kSecPaddingNone;

static const UInt8 publicKeyIdentifier[] = "net.theroyalwe.doorControl.publicKey\0";
static const UInt8 privateKeyIdentifier[] = "net.theroyalwe.doorControl.privateKey\0";




-(void)generateKeyPair:(NSUInteger)keySize {
    OSStatus sanityCheck = noErr;
    publicKey = NULL;
    privateKey = NULL;
    
    NSMutableDictionary * privateKeyAttr = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * publicKeyAttr = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * keyPairAttr = [[NSMutableDictionary alloc] init];
    
    // Set top level dictionary for the keypair.
    [keyPairAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [keyPairAttr setObject:[NSNumber numberWithUnsignedInteger:keySize] forKey:(__bridge id)kSecAttrKeySizeInBits];
    
    // Set the private key dictionary.
    [privateKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent];
    [privateKeyAttr setObject:privateTag forKey:(__bridge id)kSecAttrApplicationTag];
    // See SecKey.h to set other flag values.
    
    // Set the public key dictionary.
    [publicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent];
    [publicKeyAttr setObject:publicTag forKey:(__bridge id)kSecAttrApplicationTag];
    // See SecKey.h to set other flag values.
    
    // Set attributes to top level dictionary.
    [keyPairAttr setObject:privateKeyAttr forKey:(__bridge id)kSecPrivateKeyAttrs];
    [keyPairAttr setObject:publicKeyAttr forKey:(__bridge id)kSecPublicKeyAttrs];
    
    // SecKeyGeneratePair returns the SecKeyRefs just for educational purposes.

    sanityCheck = SecKeyGeneratePair((__bridge CFDictionaryRef)keyPairAttr, &publicKey, &privateKey);
    if(sanityCheck == noErr  && publicKey != NULL && privateKey != NULL)
    {
        NSLog(@"Successful");
    }
}

-(void)testAsymmetricEncryptionAndDecryption {

    const char inputString[] = "this is a great string to test";
    int len = strlen(inputString);

    // this is a hack since i know inputString length will be less than BUFFER_SIZE
    
    if (len > BUFFER_SIZE) len = BUFFER_SIZE-1;
    
    
    uint8_t *plainBuffer;
    plainBuffer = (uint8_t *)calloc(BUFFER_SIZE, sizeof(uint8_t));
    
    uint8_t *cipherBuffer;
    cipherBuffer = (uint8_t *)calloc(CIPHER_BUFFER_SIZE, sizeof(uint8_t));
    
    uint8_t *decryptedBuffer;
    decryptedBuffer = (uint8_t *)calloc(BUFFER_SIZE, sizeof(uint8_t));
    
    
    strncpy( (char *)plainBuffer, inputString, len);
    
    NSLog(@"init() plainBuffer: %s", plainBuffer);

    [self encryptWithPublicKey:(UInt8 *)plainBuffer cipherBuffer:cipherBuffer];
    NSLog(@"encrypted data: %s", cipherBuffer);

    [self decryptWithPrivateKey:cipherBuffer plainBuffer:decryptedBuffer];
    NSLog(@"decrypted data: %s", decryptedBuffer);

    NSLog(@"====== /second test =======================================");
    
    free(plainBuffer);
    free(cipherBuffer);
    free(decryptedBuffer);
}

- (void)encryptWithPublicKey:(uint8_t *)plainBuffer cipherBuffer:(uint8_t *)cipherBuffer{
    
    NSLog(@"== encryptWithPublicKey()");
    
    OSStatus status = noErr;
    
    NSLog(@"** original plain text 0: %s", plainBuffer);
    
    size_t plainBufferSize = strlen((char *)plainBuffer);
    size_t cipherBufferSize = CIPHER_BUFFER_SIZE;
    
    NSLog(@"SecKeyGetBlockSize() public = %lu", SecKeyGetBlockSize([self getPublicKeyRef]));

    status = SecKeyEncrypt([self getPublicKeyRef],PADDING,plainBuffer,plainBufferSize,&cipherBuffer[0],&cipherBufferSize);
    NSLog(@"encryption result code: %ld (size: %lu)", status, cipherBufferSize);
    NSLog(@"encrypted text: %s", cipherBuffer);
}

- (void)decryptWithPrivateKey:(uint8_t *)cipherBuffer plainBuffer:(uint8_t *)plainBuffer{
    OSStatus status = noErr;
    
    size_t cipherBufferSize = strlen((char *)cipherBuffer);
    
//    NSLog(@"decryptWithPrivateKey: length of buffer: %lu", BUFFER_SIZE);
//    NSLog(@"decryptWithPrivateKey: length of input: %lu", cipherBufferSize);
    
    // DECRYPTION
    size_t plainBufferSize = BUFFER_SIZE;
    
    //  Error handling
    status = SecKeyDecrypt([self getPrivateKeyRef],PADDING,&cipherBuffer[0],cipherBufferSize,&plainBuffer[0],&plainBufferSize);
    NSLog(@"decryption result code: %ld (size: %lu)", status, plainBufferSize);
    NSLog(@"FINAL decrypted text: %s", plainBuffer);
    
}

-(SecKeyRef)getPrivateKeyRef {
    OSStatus resultCode = noErr;
    SecKeyRef privateKeyReference = NULL;
    //    NSData *privateTag = [NSData dataWithBytes:@"ABCD" length:strlen((const char *)@"ABCD")];
    //    if(privateKey == NULL) {
    [self generateKeyPair:512];
    NSMutableDictionary * queryPrivateKey = [[NSMutableDictionary alloc] init];
    
    // Set the private key query dictionary.
    [queryPrivateKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryPrivateKey setObject:privateTag forKey:(__bridge id)kSecAttrApplicationTag];
    [queryPrivateKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [queryPrivateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    
    // Get the key.
    resultCode = SecItemCopyMatching((__bridge CFDictionaryRef)queryPrivateKey, (CFTypeRef *)&privateKeyReference);
    NSLog(@"getPrivateKey: result code: %ld", resultCode);
    
    if(resultCode != noErr)
    {
        privateKeyReference = NULL;
    }
    
    //        [queryPrivateKey release];
    //    } else {
    //        privateKeyReference = privateKey;
    //    }
    
    return privateKeyReference;
}

-(SecKeyRef)getPublicKeyRef {
    
    OSStatus sanityCheck = noErr;
    SecKeyRef publicKeyReference = NULL;
    
    if (publicKeyReference == NULL) {
        [self generateKeyPair:512];
        NSMutableDictionary *queryPublicKey = [[NSMutableDictionary alloc] init];
        
        // Set the public key query dictionary.
        [queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
        [queryPublicKey setObject:publicTag forKey:(__bridge id)kSecAttrApplicationTag];
        [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
        [queryPublicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
        
        
        // Get the key.
        sanityCheck = SecItemCopyMatching((__bridge CFDictionaryRef)queryPublicKey, (CFTypeRef *)&publicKeyReference);
        
        
        if (sanityCheck != noErr)
        {
            publicKeyReference = NULL;
        }
        
        
        //        [queryPublicKey release];
        
    } else { publicKeyReference = publicKey; }
    
    return publicKeyReference;
}

-(void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    privateTag = [[NSData alloc] initWithBytes:privateKeyIdentifier length:sizeof(privateKeyIdentifier)];
    publicTag = [[NSData alloc] initWithBytes:publicKeyIdentifier length:sizeof(publicKeyIdentifier)];
    [self generateKeyPair:1024];
    NSLog(@"publickey: %@", publicKey);
    NSString *testString = @"Hello world!";
    
    uint8_t *cipherBuffer;
    cipherBuffer = (uint8_t *)calloc(CIPHER_BUFFER_SIZE, sizeof(uint8_t));
    
    uint8_t *plainBuffer = (uint8_t*)calloc(CIPHER_BUFFER_SIZE, sizeof(uint8_t));
    
    
    
    [self encryptWithPublicKey:(uint8_t *)[testString UTF8String] cipherBuffer:cipherBuffer];
    
    
    
    [self decryptWithPrivateKey:cipherBuffer plainBuffer:plainBuffer];
    
    NSLog(@"then there was this...%s",plainBuffer);
    
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
