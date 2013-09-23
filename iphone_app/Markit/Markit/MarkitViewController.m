//
//  MarkitViewController.m
//  Markit
//
//  Created by Ilias Beshimov on 9/22/13.
//  Copyright (c) 2013 Ilias Beshimov. All rights reserved.
//

#import "MarkitViewController.h"
#import "ASIS3BucketObject.h"

static AmazonS3Client       *s3  = nil;
static AmazonSimpleDBClient *sdb = nil;
static AmazonSQSClient      *sqs = nil;
static AmazonSNSClient      *sns = nil;

@interface MarkitViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;
- (IBAction)changeGreeting:(id)sender;

@end

@implementation MarkitViewController

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

- (IBAction)changeGreeting:(id)sender {
    
    self.userName = self.textField.text;
    
    NSString *nameString = self.userName;
    if ([nameString length] == 0) {
        nameString = @"World";
    }
    NSString *greeting = [[NSString alloc] initWithFormat:@"Hello, %@!", nameString];
    self.label.text = greeting;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.textField) {
        [theTextField resignFirstResponder];
    }
    return YES;
}


// AWS S3 Connection Objects

+(AmazonS3Client *)s3
{
    [MarkitViewController validateCredentials];
    return s3;
}

+(AmazonSimpleDBClient *)sdb
{
    [MarkitViewController validateCredentials];
    return sdb;
}

+(AmazonSQSClient *)sqs
{
    [MarkitViewController validateCredentials];
    return sqs;
}

+(AmazonSNSClient *)sns
{
    [MarkitViewController validateCredentials];
    return sns;
}

+(bool)hasCredentials
{
    return (![ACCESS_KEY_ID isEqualToString:@"CHANGE ME"] && ![SECRET_KEY isEqualToString:@"CHANGE ME"]);
}

+(void)validateCredentials
{
    if ((sdb == nil) || (s3 == nil) || (sqs == nil) || (sns == nil)) {
        [MarkitViewController clearCredentials];
        
        s3  = [[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
        s3.endpoint = [AmazonEndpoints s3Endpoint:US_WEST_2];
        
        sdb = [[AmazonSimpleDBClient alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
        sdb.endpoint = [AmazonEndpoints sdbEndpoint:US_WEST_2];
        
        sqs = [[AmazonSQSClient alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
        sqs.endpoint = [AmazonEndpoints sqsEndpoint:US_WEST_2];
        
        sns = [[AmazonSNSClient alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
        sns.endpoint = [AmazonEndpoints snsEndpoint:US_WEST_2];
    }
}

+(void)clearCredentials
{
    s3  = nil;
    sdb = nil;
    sqs = nil;
    sns = nil;
}




@end
