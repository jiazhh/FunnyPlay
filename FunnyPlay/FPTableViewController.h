//
//  FPTableViewController.h
//  FunnyPlay
//
//  Created by admin on 9/8/13.
//  Copyright (c) 2013 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPClassInfo.h"
typedef enum{
    ArrayTypeNone = 0,
    arrayTypeProperty,
    arrayTypeMethod
}ArrayListType;

@interface FPTableViewController : UITableViewController

@property(nonatomic,strong) NSMutableArray* arrayList;
@property(nonatomic,strong) NSMutableDictionary* dictionaryList;

-(void)loadData:(id)data withType:(ArrayListType)type;
@end
