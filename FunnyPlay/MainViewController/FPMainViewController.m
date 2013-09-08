//
//  FPMainViewController.m
//  FunnyPlay
//
//  Created by admin on 8/24/13.
//  Copyright (c) 2013 admin. All rights reserved.
//

#define BTN_ROOT 1001
#define BTN_TITLE @"title"
#define BTN_TAG     @"tag"
#define BTN_CONTROLLER @"controller"
#import "FPMainViewController.h"
#import <objc/runtime.h>

#import "FPRootViewController.h"
#import "FPClassViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface FPMainViewController ()

@end

@implementation FPMainViewController
#pragma mark
#pragma mark ViewLifeCycle
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
    [super viewDidLoad];
    /*
    self.view.backgroundColor = [UIColor whiteColor];
    CALayer* myLayer = [[CALayer alloc]init];
    UIImage* myImage = [UIImage imageNamed:@"20130107131332.gif"];
    NSDate* begin =[NSDate date];

    UIImage* im3 = [UIImage imageWithCGImage:myImage.CGImage scale:2.0f orientation:UIImageOrientationUp];
    NSDate* end = [NSDate date];
    NSTimeInterval span = [end timeIntervalSinceReferenceDate]-[begin timeIntervalSinceReferenceDate];
    NSLog(@"::::::::::::%f",span);
    UIImage* myImage2 = [UIImage animatedImageNamed:@"ss" duration:2.0f];
    //NSLog(@"%s",class_getName([[self.view appearance] class]));
    NSLog(@"%s",class_getName([[UIView appearance] class]));
    NSLog(@"%s",class_getName([[UIImageView appearance] class]));
    NSLog(@"%s",class_getName([[UITableView appearance] class]));
    UIImageView* imv = [[UIImageView alloc]initWithImage:im3];
    NSLog(@"%s",class_getName([[UIView appearance] class]));
    imv.frame = CGRectMake(0, 0, 320, 480);
    //id obj=[[UIView appearance]data];
    //if ([obj isMemberOfClass:NSClassFromString(@"_UIAppearance")]) {
     //   NSLog(@"YES");
       // NSLog(@"%s",class_getName(obj))
    //}
    //else{
    //    NSLog(@"no");
    //}
    [self.view addSubview:imv];
    [[UIButton appearanceWhenContainedIn:[UIView class], nil] setBackgroundColor:[UIColor clearColor]];
    CGSize size = myImage.size;
    myLayer.bounds = CGRectMake(0, 0, size.width, size.height);
    //myLayer = (CALayer*)myImage.CGImage;
    //[myLayer setBackgroundColor:[[UIColor redColor] CGColor]];
    //[myLayer setContents:(id)myImage2.CGImage];
    //self.view.layer.opacity = 0.5;
    //[self.view.layer addSublayer:myLayer];
    CALayer*    viewLayer = self.view.layer;
    [viewLayer addSublayer:myLayer];
    myLayer.opacity = 0.9;
    // Center the layer in the view.
    CGRect        viewBounds = self.view.bounds;
    myLayer.position = CGPointMake(CGRectGetMidX(viewBounds), CGRectGetMidY(viewBounds));
    */
    
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"buttons" ofType:@"plist"];
    NSArray* buttons = [[NSArray alloc]initWithContentsOfFile:path];
    
    CGFloat space = 50.0f;
    for (NSDictionary* button in buttons) {
        static int i=0;
        NSString* btnTilte = [button objectForKey:BTN_TITLE];
        NSInteger tag = [[button objectForKey:BTN_TAG]integerValue];
        UIButton* buttonCtl = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [buttonCtl setTitle:btnTilte forState:UIControlStateNormal];
        [buttonCtl setFrame:CGRectMake(10.0f, 10.0f+space*i, 300.0f, 40.0f)];
        buttonCtl.tag = tag;
        [buttonCtl addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:buttonCtl];
        i++;
    }
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark Event Handler

- (void)btnClicked:(id)sender
{
    NSInteger tag = ((UIButton*)sender).tag;
    NSString* path = [[NSBundle mainBundle] pathForResource:@"buttons" ofType:@"plist"];
    NSArray* buttons = [NSArray arrayWithContentsOfFile:path];
    NSString* controllerName = nil;
    for (NSDictionary* button in buttons) {
        if ([[button objectForKey:BTN_TAG]integerValue] == tag) {
            controllerName = [button objectForKey:BTN_CONTROLLER];
        }
    }
    
    //find the controller push to window
    if (controllerName) {
        id controller =[[NSClassFromString(controllerName) alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
