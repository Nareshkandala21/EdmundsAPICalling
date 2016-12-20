//
//  ViewController.h
//  EdmundsAPICalling
//
//  Created by Naresh Kandala on 04/12/16.
//  Copyright © 2016 Naresh Kandala. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic)IBOutlet UITableView *tableVc;
@property (strong, nonatomic) IBOutlet UIView *searchview;
@property (nonatomic) BOOL shouldRefresh; // in .h file

@end

