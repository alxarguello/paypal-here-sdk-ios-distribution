//
//  PPSCryptoUtils.m
//  Here and There
//
//  Created by Metral, Max on 2/25/13.
//  Copyright (c) 2013 PayPal Partner. All rights reserved.
//

/**
 * Test Data:
 
 node cryptoTest.js decrypt test HblrEGaQ16d3tLeTXxfVRaYQGBBUu3a7LADcGEDibRhnKp/Dbf5HVyi9b/1USvXD0Yt8hkqF285+4vIGk7CPCAi5NMk=
 Salt      : HblrEGaQ16d3tLeTXxfVRQ==
 IV        : phAYEFS7drssANwYQOJtGA==
 HMAC      : Zyqfw23+R1covW/9VEr1w9GLfIY=
 Key       : swXeXbOtT4AgebufbrrXAF8s+qO/Dh1/wdM/uATV5aQ=
 Hash Key  : z8QQkV/dbUEEAytQWg/V/K7hxG0=
 HMAC      : Zyqfw23+R1covW/9VEr1w9GLfIY=
 Plain Text: foobar
*/

#import "PPSCryptoUtils.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>

const NSUInteger kAlgorithmKeySize = kCCKeySizeAES256;
const NSUInteger kPBKDFSaltSize = 16;
const NSUInteger kPBKDFRounds = 1000;

void *NewBase64Decode(const char *inputBuffer, size_t length, size_t *outputLength);
char *NewBase64Encode(const void *buffer, size_t length, bool separateLines, size_t *outputLength);

@implementation PPSCryptoUtils

//
// dataFromBase64String:
//
// Creates an NSData object containing the base64 decoded representation of
// the base64 string 'aString'
//
// Parameters:
//    aString - the base64 string to decode
//
// returns the autoreleased NSData representation of the base64 string
//
+ (NSData *)dataFromBase64String:(NSString *)aString
{
	NSData *data = [aString dataUsingEncoding:NSASCIIStringEncoding];
	size_t outputLength;
	void *outputBuffer = NewBase64Decode([data bytes], [data length], &outputLength);
	NSData *result = [NSData dataWithBytes:outputBuffer length:outputLength];
	free(outputBuffer);
	return result;
}

//
// base64EncodedString
//
// Creates an NSString object that contains the base 64 encoding of the
// receiver's data. Lines are broken at 64 characters long.
//
// returns an autoreleased NSString being the base 64 representation of the
//	receiver.
//
+ (NSString *)base64EncodedStringForData: (NSData*)data
{
	size_t outputLength;
	char *outputBuffer =
  NewBase64Encode([data bytes], [data length], true, &outputLength);
	
	NSString *result = [[NSString alloc]
                      initWithBytes:outputBuffer
                      length:outputLength
                      encoding:NSASCIIStringEncoding];
	free(outputBuffer);
	return result;
}

// Replace this with a 10,000 hash calls if you don't have CCKeyDerivationPBKDF
+ (NSData *)AESKeyForPassword:(NSString *)password
                         salt:(NSData *)salt {
  NSMutableData *derivedKey = [NSMutableData dataWithLength:kAlgorithmKeySize];
  
  int result = CCKeyDerivationPBKDF(kCCPBKDF2,                // algorithm
                                    password.UTF8String,      // password
                                    password.length,          // passwordLength
                                    salt.bytes,               // salt
                                    salt.length,              // saltLen
                                    kCCPRFHmacAlgSHA1,        // PRF
                                    kPBKDFRounds,             // rounds
                                    derivedKey.mutableBytes,  // derivedKey
                                    derivedKey.length);       // derivedKeyLen
  
  NSAssert(result == kCCSuccess, @"Unable to create AES key for password: %d", result);
  
  return derivedKey;
}

+(NSString *)AES256Decrypt:(NSString *)inputPacket withPassword:(NSString *)password
{
  NSData *raw = [self dataFromBase64String:inputPacket];
  if (!inputPacket || inputPacket.length <= 52) {
    return nil;
  }
  NSData *salt = [raw subdataWithRange:NSMakeRange(0, 16)];
  NSData *iv = [raw subdataWithRange:NSMakeRange(16, 16)];
  NSData *hmac = [raw subdataWithRange:NSMakeRange(32, 20)];
  NSData *cipher = [raw subdataWithRange:NSMakeRange(52, raw.length - 52)];
  
  // First, derive the key
  NSData *key = [self AESKeyForPassword:password salt:salt];
  
  // Now SHA1 Hash the key to get the HMAC key
  unsigned char hashKey[CC_SHA1_DIGEST_LENGTH];
  if (!CC_SHA1(key.bytes, key.length, hashKey)) {
    return nil;
  }
  
  // Validate the HMAC
  unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
  CCHmac(kCCHmacAlgSHA1, hashKey, CC_SHA1_DIGEST_LENGTH, cipher.bytes, cipher.length, cHMAC);
  
  if (memcmp(cHMAC, hmac.bytes, CC_SHA1_DIGEST_LENGTH) != 0) {
    return nil;
  }
  
  // And finally, decrypt the cipher text
  
  //See the doc: For block ciphers, the output size will always be less than or
	//equal to the input size plus the size of one block.
	//That's why we need to add the size of one block here
	size_t bufferSize = cipher.length + (2*kCCBlockSizeAES128); // not sure the block size is right for 256 --Max
	char *buffer = malloc(bufferSize);

  size_t numBytesDecrypted = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                        key.bytes, kCCKeySizeAES256,
                                        iv.bytes,
                                        [cipher bytes], cipher.length, /* input */
                                        buffer, bufferSize, /* output */
                                        &numBytesDecrypted);
                                              
  if (cryptStatus == kCCSuccess) {
    //the returned NSString takes ownership of the buffer and will free it on deallocation
    NSString *rz = [[NSString alloc] initWithBytesNoCopy:buffer length:numBytesDecrypted encoding:NSUTF8StringEncoding freeWhenDone:YES];
    return rz;
  }
  
  free(buffer);
  return nil;  
}
@end

//
// Definition for "masked-out" areas of the base64DecodeLookup mapping
//
#define xx 65

//
// Mapping from ASCII character to 6 bit pattern.
//
static unsigned char base64DecodeLookup[256] =
{
  xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
  xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
  xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 62, xx, xx, xx, 63,
  52, 53, 54, 55, 56, 57, 58, 59, 60, 61, xx, xx, xx, xx, xx, xx,
  xx,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
  15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, xx, xx, xx, xx, xx,
  xx, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
  41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, xx, xx, xx, xx, xx,
  xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
  xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
  xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
  xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
  xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
  xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
  xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
  xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
};

//
// Fundamental sizes of the binary and base64 encode/decode units in bytes
//
#define BINARY_UNIT_SIZE 3
#define BASE64_UNIT_SIZE 4

//
// Mapping from 6 bit pattern to ASCII character.
//
static unsigned char base64EncodeLookup[65] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

//
// NewBase64Decode
//
// Decodes the base64 ASCII string in the inputBuffer to a newly malloced
// output buffer.
//
//  inputBuffer - the source ASCII string for the decode
//	length - the length of the string or -1 (to specify strlen should be used)
//	outputLength - if not-NULL, on output will contain the decoded length
//
// returns the decoded buffer. Must be free'd by caller. Length is given by
//	outputLength.
//
void *NewBase64Decode(
                      const char *inputBuffer,
                      size_t length,
                      size_t *outputLength)
{
	if (length == -1)
	{
		length = strlen(inputBuffer);
	}
	
	size_t outputBufferSize =
  ((length+BASE64_UNIT_SIZE-1) / BASE64_UNIT_SIZE) * BINARY_UNIT_SIZE;
	unsigned char *outputBuffer = (unsigned char *)malloc(outputBufferSize);
	
	size_t i = 0;
	size_t j = 0;
	while (i < length)
	{
		//
		// Accumulate 4 valid characters (ignore everything else)
		//
		unsigned char accumulated[BASE64_UNIT_SIZE];
		size_t accumulateIndex = 0;
		while (i < length)
		{
			unsigned char decode = base64DecodeLookup[inputBuffer[i++]];
			if (decode != xx)
			{
				accumulated[accumulateIndex] = decode;
				accumulateIndex++;
				
				if (accumulateIndex == BASE64_UNIT_SIZE)
				{
					break;
				}
			}
		}
		
		//
		// Store the 6 bits from each of the 4 characters as 3 bytes
		//
		// (Uses improved bounds checking suggested by Alexandre Colucci)
		//
		if (accumulateIndex >= 2)
			outputBuffer[j] = (accumulated[0] << 2) | (accumulated[1] >> 4);
		if (accumulateIndex >= 3)
			outputBuffer[j + 1] = (accumulated[1] << 4) | (accumulated[2] >> 2);
		if (accumulateIndex >= 4)
			outputBuffer[j + 2] = (accumulated[2] << 6) | accumulated[3];
		j += accumulateIndex - 1;
	}
	
	if (outputLength)
	{
		*outputLength = j;
	}
	return outputBuffer;
}

//
// NewBase64Encode
//
// Encodes the arbitrary data in the inputBuffer as base64 into a newly malloced
// output buffer.
//
//  inputBuffer - the source data for the encode
//	length - the length of the input in bytes
//  separateLines - if zero, no CR/LF characters will be added. Otherwise
//		a CR/LF pair will be added every 64 encoded chars.
//	outputLength - if not-NULL, on output will contain the encoded length
//		(not including terminating 0 char)
//
// returns the encoded buffer. Must be free'd by caller. Length is given by
//	outputLength.
//
char *NewBase64Encode(
                      const void *buffer,
                      size_t length,
                      bool separateLines,
                      size_t *outputLength)
{
	const unsigned char *inputBuffer = (const unsigned char *)buffer;
	
#define MAX_NUM_PADDING_CHARS 2
#define OUTPUT_LINE_LENGTH 64
#define INPUT_LINE_LENGTH ((OUTPUT_LINE_LENGTH / BASE64_UNIT_SIZE) * BINARY_UNIT_SIZE)
#define CR_LF_SIZE 2
	
	//
	// Byte accurate calculation of final buffer size
	//
	size_t outputBufferSize =
  ((length / BINARY_UNIT_SIZE)
   + ((length % BINARY_UNIT_SIZE) ? 1 : 0))
  * BASE64_UNIT_SIZE;
	if (separateLines)
	{
		outputBufferSize +=
    (outputBufferSize / OUTPUT_LINE_LENGTH) * CR_LF_SIZE;
	}
	
	//
	// Include space for a terminating zero
	//
	outputBufferSize += 1;
  
	//
	// Allocate the output buffer
	//
	char *outputBuffer = (char *)malloc(outputBufferSize);
	if (!outputBuffer)
	{
		return NULL;
	}
  
	size_t i = 0;
	size_t j = 0;
	const size_t lineLength = separateLines ? INPUT_LINE_LENGTH : length;
	size_t lineEnd = lineLength;
	
	while (true)
	{
		if (lineEnd > length)
		{
			lineEnd = length;
		}
    
		for (; i + BINARY_UNIT_SIZE - 1 < lineEnd; i += BINARY_UNIT_SIZE)
		{
			//
			// Inner loop: turn 48 bytes into 64 base64 characters
			//
			outputBuffer[j++] = base64EncodeLookup[(inputBuffer[i] & 0xFC) >> 2];
			outputBuffer[j++] = base64EncodeLookup[((inputBuffer[i] & 0x03) << 4)
                                             | ((inputBuffer[i + 1] & 0xF0) >> 4)];
			outputBuffer[j++] = base64EncodeLookup[((inputBuffer[i + 1] & 0x0F) << 2)
                                             | ((inputBuffer[i + 2] & 0xC0) >> 6)];
			outputBuffer[j++] = base64EncodeLookup[inputBuffer[i + 2] & 0x3F];
		}
		
		if (lineEnd == length)
		{
			break;
		}
		
		//
		// Add the newline
		//
		outputBuffer[j++] = '\r';
		outputBuffer[j++] = '\n';
		lineEnd += lineLength;
	}
	
	if (i + 1 < length)
	{
		//
		// Handle the single '=' case
		//
		outputBuffer[j++] = base64EncodeLookup[(inputBuffer[i] & 0xFC) >> 2];
		outputBuffer[j++] = base64EncodeLookup[((inputBuffer[i] & 0x03) << 4)
                                           | ((inputBuffer[i + 1] & 0xF0) >> 4)];
		outputBuffer[j++] = base64EncodeLookup[(inputBuffer[i + 1] & 0x0F) << 2];
		outputBuffer[j++] =	'=';
	} else if (i < length) {
		//
		// Handle the double '=' case
		//
		outputBuffer[j++] = base64EncodeLookup[(inputBuffer[i] & 0xFC) >> 2];
		outputBuffer[j++] = base64EncodeLookup[(inputBuffer[i] & 0x03) << 4];
		outputBuffer[j++] = '=';
		outputBuffer[j++] = '=';
	}
	outputBuffer[j] = 0;
	
	//
	// Set the output length and return the buffer
	//
	if (outputLength)
	{
		*outputLength = j;
	}
	return outputBuffer;
}


// Portions of this code are based on NSData+Base64 as described below
// and obtained via http://projectswithlove.com/projects/NSData_Base64.zip

//
//  NSData+Base64.m
//  base64
//
//  Created by Matt Gallagher on 2009/06/03.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//  arising from the use of this software. Permission is granted to anyone to
//  use this software for any purpose, including commercial applications, and to
//  alter it and redistribute it freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation would be
//     appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source
//     distribution.
//

