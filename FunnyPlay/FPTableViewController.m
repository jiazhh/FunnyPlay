//
//  FPTableViewController.m
//  FunnyPlay
//
//  Created by admin on 9/8/13.
//  Copyright (c) 2013 admin. All rights reserved.
//

#import "FPTableViewController.h"

@interface FPTableViewController ()

@property(nonatomic,assign) ArrayListType type;

@end

@implementation FPTableViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.arrayList = nil;
        self.dictionaryList = nil;
        //self.tableView = [[UITableView alloc]init];
    }
    return self;
}

- (void)loadData:(id)data withType:(ArrayListType)type
{
    if ([data isKindOfClass:[NSArray class]]) {
        self.arrayList = (NSMutableArray*)data;
        self.dictionaryList = nil;
        self.type = type;
    }else if([data isKindOfClass:[NSDictionary class]]){
        self.dictionaryList = (NSMutableDictionary*)data;
        self.arrayList = nil;
        self.type = type;
        
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    // Return the number of rows in the section.
    int count =0;
    if (self.arrayList) {
        count = self.arrayList.count;
    }else if (self.dictionaryList){
        count = self.dictionaryList.count;
    }
    return count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.numberOfLines = 5;
    //cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.font = [UIFont fontWithName:nil size:4];
    [cell.textLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];
    if (self.arrayList) {
        if (self.type == arrayTypeProperty) {
            NSDictionary* property =[self.arrayList objectAtIndex:indexPath.row];
            NSString *title = [NSString stringWithFormat:@"%@,%@",[property objectForKey:kpropertyName],[property objectForKey:kpropertyAttributes] ];
            cell.textLabel.text = title;
        }
        else if(self.type == arrayTypeMethod)
        {
            NSDictionary* method = [self.arrayList objectAtIndex:indexPath.row];
            NSString* title = [NSString stringWithFormat:@"%@,%@,%@",[method objectForKey:kMethodName],[method objectForKey:kMethodType],[method objectForKey:kMethodIMP]];
            cell.textLabel.text = title;
        }
    }
    else if(self.dictionaryList){
        NSString* key = [self.dictionaryList.allKeys objectAtIndex:indexPath.row];
        id value = [self.dictionaryList objectForKey:key];
        if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            cell.textLabel.text = key;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = [NSString stringWithFormat:@"%@=%@",key,[self.dictionaryList objectForKey:key]];
        }
    }
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id data=nil;
    ArrayListType type = ArrayTypeNone;
    if (self.arrayList) {
        data = [self.arrayList objectAtIndex:indexPath.row];
    }else{
        NSString* key =[self.dictionaryList.allKeys objectAtIndex:indexPath.row];
        data = [self.dictionaryList objectForKey:key];
        if ([key rangeOfString:@"ropert"].location != NSNotFound) {
            type = arrayTypeProperty;
        }
        if ([key rangeOfString:@"ethod"].location != NSNotFound) {
            type = arrayTypeMethod;
        }

        
    }
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryDetailDisclosureButton) {
        FPTableViewController *subTableView = [[FPTableViewController alloc]initWithNibName:nil bundle:nil];
        [subTableView loadData:data withType:type];
        subTableView.title = cell.textLabel.text;
        [self.navigationController pushViewController:subTableView animated:YES];
    }
}

@end
