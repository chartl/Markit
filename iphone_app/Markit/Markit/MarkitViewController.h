//
//  MarkitViewController.h
//  Markit
//
//  Created by Ilias Beshimov on 9/22/13.
//  Copyright (c) 2013 Ilias Beshimov. All rights reserved.
//

// These are AWS SimpleDB credentials. FOR TESTINT PURPOSES ONLY. Need to have different system for production system.

#define ACCESS_KEY_ID                @"AKIAJYPI6OKCB7GHTFRQ"
#define SECRET_KEY                   @"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"


#import <UIKit/UIKit.h>
#import <AWSRuntime/AWSRuntime.h>
#import <AWSSimpleDB/AWSSimpleDB.h>
#import <FacebookSDK/FacebookSDK.h>
#import <AWSS3/AWSS3.h>
#import <AWSSES/AWSSES.h>
#import <AWSSQS/AWSSQS.h>
#import <AWSSNS/AWSSNS.h>

@interface MarkitViewController : UIViewController <UITextFieldDelegate>

@property (copy, nonatomic) NSString *userName;
+(AmazonS3Client *)s3;
+(AmazonSimpleDBClient *)sdb;
+(AmazonSQSClient *)sqs;
+(AmazonSNSClient *)sns;

+(bool)hasCredentials;
+(void)validateCredentials;
+(void)clearCredentials;

@end
