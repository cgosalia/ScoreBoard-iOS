//
//  SimpleTableViewController.m
//  SimpleTable
//
//  Created by Simon Ng on 16/4/12.
//  Copyright (c) 2012 AppCoda. All rights reserved.
//

#import "SimpleTableViewController.h"
#import "SimpleTableCell.h"

@interface SimpleTableViewController ()

@end

@implementation SimpleTableViewController
{
    NSMutableArray *tableData1;
    NSMutableArray *tableData2;
    NSMutableArray *tableData3;
    NSMutableArray *tableData4;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Initialize table data
    tableData1 = [NSMutableArray arrayWithObjects:@"player1",@"player2",nil];
    tableData2 = [NSMutableArray arrayWithObjects:@"+",@"+",nil];
    tableData3 = [NSMutableArray arrayWithObjects:@"-",@"-",nil];
    tableData4 = [NSMutableArray arrayWithObjects:@"score1",@"score2",nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData1 count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    SimpleTableCell *cell;
    
    if (cell == nil) {
        cell = (SimpleTableCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        NSMutableArray *nib = (NSMutableArray *)[[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil ];
        cell = [nib objectAtIndex:0];
    }
    
    cell.playerName.text = [tableData1 objectAtIndex:indexPath.row];
    cell.increment.text = [tableData2 objectAtIndex:indexPath.row];
    cell.decrement.text = [tableData3 objectAtIndex:indexPath.row];
    cell.score.text = [tableData4 objectAtIndex:indexPath.row];
    //cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
 //   cell.imageView.image = [UIImage imageNamed:@"creme_brelee.jpg"];

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove the row from data model
    [tableData1 removeObjectAtIndex:indexPath.row];
    
    // Request table view to reload
    [tableView reloadData];
}

@end

