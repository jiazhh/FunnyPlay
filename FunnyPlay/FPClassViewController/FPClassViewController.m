//
//  FPClassViewController.m
//  FunnyPlay
//
//  Created by admin on 8/24/13.
//  Copyright (c) 2013 admin. All rights reserved.
//

#define kCellName       @"classInfoCell"
#import "FPTableViewController.h"
#import "FPClassViewController.h"
#import <objc/runtime.h>
@interface FPClassViewController ()
@property (nonatomic,strong) NSMutableArray* methodsModel;
@property(nonatomic,strong) UITextField* tfClassName;
@property(nonatomic,strong) UITableView* tbMethods;
@property(nonatomic,strong) UILabel* lbBasicInfo;
@property(nonatomic,strong) FPClassInfo *classInfo;
@end

@implementation FPClassViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"类结构";
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"%@",[self.classInfo.info description]);
    
    self.title = @"";
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor redColor];
	// Do any additional setup after loading the view.
    self.tfClassName = [[UITextField alloc]initWithFrame:CGRectMake(5, 5, 200, 25)];
    [self.tfClassName setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:self.tfClassName];
    UIButton* btnCheck = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCheck.frame = CGRectMake(220, 10, 90, 25);
    [btnCheck setTitle:@"给爷瞅瞅" forState:UIControlStateNormal];
    [btnCheck addTarget:self action:@selector(btnCheckClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnCheck];
     self.tbMethods = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, 320, 420)];
    self.tbMethods.delegate = self;
    self.tbMethods.dataSource = self;
    [self.view addSubview:self.tbMethods];
    
    self.lbBasicInfo = [[UILabel alloc]initWithFrame:CGRectMake(5, 35, 320, 25)];
    self.lbBasicInfo.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.lbBasicInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark Event Handler
- (void)btnCheckClicked:(id)sender
{
    [self.tfClassName resignFirstResponder];
    self.classInfo = [[FPClassInfo alloc]initWithClassName:self.tfClassName.text];
    self.title = [self.classInfo.info objectForKey:kClassName];
    [self.tbMethods reloadData];
}

#pragma mark 
#pragma mark -UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* key = [self.classInfo.info.allKeys objectAtIndex:indexPath.row];
    id data = [self.classInfo.info objectForKey:key];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryDetailDisclosureButton) {
        FPTableViewController *subTableView = [[FPTableViewController alloc]initWithNibName:nil bundle:nil];
        [subTableView loadData:data withType:ArrayTypeNone];
        subTableView.title = key;
        [self.navigationController pushViewController:subTableView animated:YES];
    }
}
#pragma mark
#pragma mark -UITableViewDataSource
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellName];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellName];
    }
    NSString* key = [self.classInfo.info.allKeys objectAtIndex:indexPath.row];
    NSString* text = key;
    id value = [self.classInfo.info objectForKey:key];
    if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }else{
        text = [NSString stringWithFormat:@"%@=%@",key,(NSString*)value];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = text;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.classInfo.info count];
}

@end
/* 原来使用objc time库函数实现的函数查询 暂时保留
- (void)btnCheckClicked:(id)sender
{
    if (self.methodsModel) {
        [self.methodsModel removeAllObjects];
    }
    else{
        self.methodsModel = [[NSMutableArray alloc]initWithCapacity:1024];
    }
    
    NSString* className = [self.tfClassName text];
    unsigned int count = 0;
    //after get the class name
    if (NSClassFromString(className)) {
        Method* methods=class_copyMethodList(NSClassFromString(className),&count);
        
        Class superCls = class_getSuperclass(NSClassFromString(className));
        NSString* basicInfo = [NSString stringWithFormat:@"函数个数：%d,父类：%s",count,class_getName(superCls)];
        self.lbBasicInfo.text = basicInfo;
        for(unsigned int i=0;i<count;i++)
        {
            SEL sel= method_getName(methods[i]);
            NSString* methodName = [NSString stringWithFormat:@"%s",sel_getName(sel)];
            [self.methodsModel addObject:methodName];
        }

    }
    else{
        self.lbBasicInfo.text = @"";
    }
    [self.tbMethods reloadData];
    [self.tfClassName resignFirstResponder];
}

#pragma mark
#pragma mark -UITableViewDelegate

#pragma mark
#pragma mark _UITalbeViewDatasource

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell= [tableView dequeueReusableCellWithIdentifier:@"methodCell"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"methodCell"];
    }
   
    [cell.textLabel setFont:[UIFont fontWithName:@"system" size:8]];
    [cell.textLabel setText:[self.methodsModel objectAtIndex:indexPath.row]];
    //NSLog(@"1111");
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.methodsModel == nil) {
        return 0;
    }

    return self.methodsModel.count;
}
 */

