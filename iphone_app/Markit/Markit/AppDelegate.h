//
//  AppDelegate.h
//  Markit
//
//  Created by the Markit team on 10/11/13.
//  Copyright (c) 2013 Markit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong) NSURLRequest *theRequest;
@property (strong) NSURLConnection *theConnection;
@property (strong) NSMutableArray *receivedData;


- (NSMutableArray *)getBookmarks;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
