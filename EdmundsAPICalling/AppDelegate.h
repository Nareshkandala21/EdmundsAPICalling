//
//  AppDelegate.h
//  EdmundsAPICalling
//
//  Created by Naresh Kandala on 04/12/16.
//  Copyright © 2016 Naresh Kandala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

