//
//  FPAppDelegate.h
//  FunnyPlay
//
//  Created by admin on 8/21/13.
//  Copyright (c) 2013 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPRootViewController.h"

@interface FPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FPRootViewController *fpRootController;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
