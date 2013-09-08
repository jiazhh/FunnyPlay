//
//  FPRootViewController.m
//  FunnyPlay
//
//  Created by admin on 8/21/13.
//  Copyright (c) 2013 admin. All rights reserved.
//

#import "FPRootViewController.h"

@interface FPRootViewController ()

@end

@implementation FPRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"view load");
    [super viewDidLoad];
    //[self.view setBackgroundColor:[UIColor yellowColor]];
    CGRect frame = self.view.frame;
    frame.origin.x=0;
    frame.origin.y=0;
    self.tbView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
    self.tbView.delegate = self;
    self.tbView.dataSource = self;
    [self.view addSubview:self.tbView];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark
#pragma mark UITableViewDelegate

#pragma mark 
#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    }
    CGRect frame= cell.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    UILabel *aLable=[[UILabel alloc]initWithFrame:frame];
    aLable.text= @"Look at me!";
    [cell addSubview:aLable];
    cell.textLabel.text = @"cell type 1";
    return cell;
}

@end
