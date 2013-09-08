//
//  FPRootViewController.h
//  FunnyPlay
//
//  Created by admin on 8/21/13.
//  Copyright (c) 2013 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FPRootViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tbView;
@end
