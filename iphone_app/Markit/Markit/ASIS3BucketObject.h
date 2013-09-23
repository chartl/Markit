//
//  ASIS3BucketRequest.h
//  Part of ASIHTTPRequest -> http://allseeing-i.com/ASIHTTPRequest
//
//  Created by Ben Copsey on 16/03/2010.
//  Copyright 2010 All-Seeing Interactive. All rights reserved.
//
//  Use this class to create buckets, fetch a list of their contents, and delete buckets

#import <Foundation/Foundation.h>
#import "ASIS3Request.h"

extern NSString *const ASIS3StorageClassStandard;
extern NSString *const ASIS3StorageClassReducedRedundancy;

@interface ASIS3ObjectRequest : ASIS3Request {
    
	// Name of the bucket to talk to
	NSString *bucket;
    
	// Key of the resource you want to access on S3
	NSString *key;
    
	// The bucket + path of the object to be copied (used with COPYRequestFromBucket:path:toBucket:path:)
	NSString *sourceBucket;
	NSString *sourceKey;
    
	// The mime type of the content for PUT requests
	// Set this if having the correct mime type returned to you when you GET the data is important (eg it will be served by a web-server)
	// Can be autodetected when PUTing a file from disk, will default to 'application/octet-stream' when PUTing data
	NSString *mimeType;
    
	// Set this to specify you want to work with a particular subresource (eg an acl for that resource)
	// See requestWithBucket:key:subResource:, below.
	NSString* subResource;
    
	// The storage class to be used for PUT requests
	// Set this to ASIS3StorageClassReducedRedundancy to save money on storage, at (presumably) a slightly higher risk you will lose the data
	// If this is not set, no x-amz-storage-class header will be sent to S3, and their default will be used
	NSString *storageClass;
}

// Create a request, building an appropriate url
+ (id)requestWithBucket:(NSString *)bucket key:(NSString *)key;

// Create a request for an object, passing a parameter in the query string
// You'll need to parse the response XML yourself
// Examples:
// Fetch ACL:
// ASIS3ObjectRequest *request = [ASIS3ObjectRequest requestWithBucket:@"mybucket" key:@"my-key" parameter:@"acl"];
// Get object torret:
// ASIS3ObjectRequest *request = [ASIS3ObjectRequest requestWithBucket:@"mybucket" key:@"my-key" parameter:@"torrent"];
// See the S3 REST API docs for more information about the parameters you can pass
+ (id)requestWithBucket:(NSString *)bucket key:(NSString *)key subResource:(NSString *)subResource;

// Create a PUT request using the file at filePath as the body
+ (id)PUTRequestForFile:(NSString *)filePath withBucket:(NSString *)bucket key:(NSString *)key;

// Create a PUT request using the supplied NSData as the body (set the mime-type manually with setMimeType: if necessary)
+ (id)PUTRequestForData:(NSData *)data withBucket:(NSString *)bucket key:(NSString *)key;

// Create a DELETE request for the object at path
+ (id)DELETERequestWithBucket:(NSString *)bucket key:(NSString *)key;

// Create a PUT request to copy an object from one location to another
// Clang will complain because it thinks this method should return an object with +1 retain :(
+ (id)COPYRequestFromBucket:(NSString *)sourceBucket key:(NSString *)sourceKey toBucket:(NSString *)bucket key:(NSString *)key;

// Creates a HEAD request for the object at path
+ (id)HEADRequestWithBucket:(NSString *)bucket key:(NSString *)key;

@property (retain, nonatomic) NSString *bucket;
@property (retain, nonatomic) NSString *key;
@property (retain, nonatomic) NSString *sourceBucket;
@property (retain, nonatomic) NSString *sourceKey;
@property (retain, nonatomic) NSString *mimeType;
@property (retain, nonatomic) NSString *subResource;
@property (retain, nonatomic) NSString *storageClass;
@class ASIS3BucketObject;

@interface ASIS3BucketRequest : ASIS3Request {
    
	// Name of the bucket to talk to
	NSString *bucket;
    
	// A parameter passed to S3 in the query string to tell it to return specialised information
	// Consult the S3 REST API documentation for more info
	NSString *subResource;
    
	// Options for filtering GET requests
	// See http://docs.amazonwebservices.com/AmazonS3/2006-03-01/index.html?RESTBucketGET.html
	NSString *prefix;
	NSString *marker;
	int maxResultCount;
	NSString *delimiter;
    
	// Internally used while parsing the response
	ASIS3BucketObject *currentObject;
    
	// Returns an array of ASIS3BucketObjects created from the XML response
	NSMutableArray *objects;
    
	// Will be populated with a list of 'folders' when a delimiter is set
	NSMutableArray *commonPrefixes;
    
	// Will be true if this request did not return all the results matching the query (use maxResultCount to configure the number of results to return)
	BOOL isTruncated;
}

// Fetch a bucket
+ (id)requestWithBucket:(NSString *)bucket;

// Create a bucket request, passing a parameter in the query string
// You'll need to parse the response XML yourself
// Examples:
// Fetch ACL:
// ASIS3BucketRequest *request = [ASIS3BucketRequest requestWithBucket:@"mybucket" parameter:@"acl"];
// Fetch Location:
// ASIS3BucketRequest *request = [ASIS3BucketRequest requestWithBucket:@"mybucket" parameter:@"location"];
// See the S3 REST API docs for more information about the parameters you can pass
+ (id)requestWithBucket:(NSString *)bucket subResource:(NSString *)subResource;

// Use for creating new buckets
+ (id)PUTRequestWithBucket:(NSString *)bucket;

// Use for deleting buckets - they must be empty for this to succeed
+ (id)DELETERequestWithBucket:(NSString *)bucket;

@property (retain, nonatomic) NSString *bucket;
@property (retain, nonatomic) NSString *subResource;
@property (retain, nonatomic) NSString *prefix;
@property (retain, nonatomic) NSString *marker;
@property (assign, nonatomic) int maxResultCount;
@property (retain, nonatomic) NSString *delimiter;
@property (retain, readonly) NSMutableArray *objects;
@property (retain, readonly) NSMutableArray *commonPrefixes;
@property (assign, readonly) BOOL isTruncated;
@end