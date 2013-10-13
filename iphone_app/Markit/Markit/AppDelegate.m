//
//  AppDelegate.m
//  Markit
//
//  Created by the Markit team on 10/11/13.
//  Copyright (c) 2013 Markit. All rights reserved.
//

#import "AppDelegate.h"
#import <Foundation/Foundation.h>

#import "MasterViewController.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize receivedData = _receivedData;
@synthesize theConnection = _theConnection;

- (NSMutableArray *)getBookmarks {
    NSMutableArray* myArray;
    NSString *url1 = @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=533451786&mt=8";
    NSString *url2 = @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=447188370&mt=8";
    NSString *url3 = @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=525818839&mt=8";
    myArray = [NSMutableArray arrayWithObjects: url1,url2,url3,nil];
    
    
    // ESTABLISHING CONNECTION WITH SERVER
    static NSMutableURLRequest *theRequest = nil;
    if (theRequest == nil) {
        theRequest = [NSMutableURLRequest
                       requestWithURL:[NSURL
                        URLWithString:@"http://ec2-54-200-16-176.us-west-2.compute.amazonaws.com:80?user=beshim&pass=foo"]
                          cachePolicy:NSURLRequestUseProtocolCachePolicy
                      timeoutInterval:60.0];
    };

    // ec2-54-200-16-176.us-west-2.compute.amazonaws.com - Ilias
    // ec2-54-200-56-45.us-west-2.compute.amazonaws.com - Chris
    
//    NSString *myGetString = @"THIS IS A GET STRING";
//    NSData *myGetData = [ NSData dataWithBytes: [ myGetString UTF8String ] length: [ myGetString length ] ];
//    [theRequest setHTTPMethod:@"GET"];
//    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
//    [theRequest setHTTPBody: myGetData];
//    NSURLResponse *getResponse;
//    NSError *getErr;
//    NSData *getReturnData = [ NSURLConnection sendSynchronousRequest:theRequest returningResponse:&getResponse error:&getErr];
//    NSString *getContent = [NSString stringWithUTF8String:[getReturnData bytes]];
//    NSLog(@"getReturnData: %@, and getResponse: %@" , getReturnData, getResponse);
//    NSLog(@"getErr: %@", getErr);
  
    //
    // - (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response {
    //    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    //    int responseStatusCode = [httpResponse statusCode];
    //
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest
                                           delegate:self];
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        NSLog(@"Connection was established. Fuck yeah!");
    } else {
        NSLog(@"Connection fucking failed. Fuck no!");
    };
    
    
    /// START OF TEST CODE
//    NSString *myRequestString = @"I AM FUCKING SENDING SHIT, YOU SEXY CUNT";
//    NSData *myRequestData = [ NSData dataWithBytes: [ myRequestString UTF8String ] length: [ myRequestString length ] ];
//    NSMutableURLRequest *request = [ [ NSMutableURLRequest alloc ] initWithURL: [ NSURL URLWithString: @"http://ec2-54-200-56-45.us-west-2.compute.amazonaws.com:80/" ] ];
//    [ request setHTTPMethod: @"POST" ];
//    [ request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
//    [ request setHTTPBody: myRequestData ];
//    NSURLResponse *response;
//    NSError *err;
//    NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&err];
//    NSString *content = [NSString stringWithUTF8String:[returnData bytes]];
//    NSLog(@"responseData: %@", content);
    
    /// END OF TEST CODE
    
    return myArray;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    MasterViewController *controller = (MasterViewController *)navigationController.topViewController;
    controller.managedObjectContext = self.managedObjectContext;
    controller.bookmarks = self.getBookmarks;
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Markit" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Markit.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge previousFailureCount] == 0) {
        NSLog(@"received authentication challenge");
        NSURLCredential *newCredential = [NSURLCredential credentialWithUser:@"USER"
                                                                    password:@"PASSWORD"
                                                                 persistence:NSURLCredentialPersistenceForSession];
        NSLog(@"credential created");
        [[challenge sender] useCredential:newCredential forAuthenticationChallenge:challenge];
        NSLog(@"responded to authentication challenge");
    }
    else {
        NSLog(@"previous authentication failure");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int responseStatusCode = [httpResponse statusCode];
    NSLog(@"httpResponse is: %@", httpResponse);
    NSLog(@"responseStatusCode is: %d", responseStatusCode);
    NSLog(@"didReceiveResponse worked!");
    //[_receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    NSLog(@"data is: %@!", data);
    NSLog(@"didReceiveData worked!");
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"response is: %@!", response);
    
    
    // Response parsing into individual app strings
    // This will need to be in the future made into separate function
    NSString *testString = @"(app_name1,1111111,http://app_name1.com),(app_name2,2222222,http://app_name2.com)";
    NSLog(@"String is: %@", testString);
    
    NSRange openBracket = [testString rangeOfString:@"("];
    NSRange closeBracket = [testString rangeOfString:@")"];
    NSRange numberRange = NSMakeRange(openBracket.location + 1, closeBracket.location - openBracket.location - 1);
    NSString *numberString = [testString substringWithRange:numberRange];
    NSLog(@"Substring is: %@", numberString);
    
    NSString *remainder = [testString substringFromIndex:closeBracket.location + 2];
    NSLog(@"Remainder is: %@", remainder);
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    // receivedData is declared as a method instance elsewhere
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received XXXXXX bytes of data");
    
    // release the connection, and the data object
}


@end;
