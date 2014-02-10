//
//  TrackingModeViewController.m
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 2/8/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import "TrackingModeViewController.h"
#import "PlayerCell.h"
#import "PlayerInfo.h"

@interface TrackingModeViewController ()

@end

@implementation TrackingModeViewController


@synthesize cellData;

NSString *score;

PlayerCell *cell;

PlayerCell *selectedCell;

int playerId = 1;

NSIndexPath *labelIndexPath;

- (IBAction)incrementScoreByOne:(id)sender {
    
    CGPoint btnOrigin = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:btnOrigin];
    PlayerInfo *selectedPlayer = [cellData objectAtIndex:indexPath.row];
    int score = selectedPlayer.score;
    score++;
    PlayerInfo *newPlayer = [[PlayerInfo alloc] init];
    newPlayer.playerName = selectedPlayer.playerName;
    newPlayer.score = score;
    [cellData replaceObjectAtIndex:indexPath.row withObject:newPlayer];
    [self.tableView reloadData];

}

- (IBAction)decrementScoreByOne:(id)sender {
    
    CGPoint btnOrigin = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:btnOrigin];
    PlayerInfo *selectedPlayer = [cellData objectAtIndex:indexPath.row];
    int score = selectedPlayer.score;
    if(score > 0) {
    score--;
    }
    PlayerInfo *newPlayer = [[PlayerInfo alloc] init];
    newPlayer.playerName = selectedPlayer.playerName;
    newPlayer.score = score;
    [cellData replaceObjectAtIndex:indexPath.row withObject:newPlayer];
    [self.tableView reloadData];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PlayerInfo *firstPlayer = [[PlayerInfo alloc] init];
    
    firstPlayer.playerName = @"Player 1";
    firstPlayer.score = 0;
    
    cellData = [[NSMutableArray alloc] initWithObjects:firstPlayer, nil];

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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return cellData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellForPlayers";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Configure the cell...
    
    if (cell == nil) {
        cell = [[PlayerCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
    }
    
    PlayerInfo *player = [cellData objectAtIndex:indexPath.row];
    cell.playerName.text = player.playerName;
    cell.playerScore.text = [NSString stringWithFormat:@"%d", player.score];
    [cell.incrementScore setTitle:@"+" forState:normal];
    [cell.decrementScore setTitle:@"-" forState:normal];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [cell.playerName addGestureRecognizer:doubleTap];
    //cell.textLabel.text = [cellData objectAtIndex:indexPath.row];
    return cell;
}

-(void) handleDoubleTap:(UITapGestureRecognizer *) gesture {
    UIView *uiView = (UIView *) gesture.view;
    while(![uiView isKindOfClass: [UITableViewCell class]]) {
        uiView = uiView.superview;
    }
    labelIndexPath = [self.tableView indexPathForCell:uiView];
    //labelOrigin = [cell.playerName convertPoint:CGPointZero toView:self.tableView];
    NSString *Temp = cell.playerName.text;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Player Name" message:@"Enter name" delegate:self cancelButtonTitle:@"Cancel Rename" otherButtonTitles:@"Done", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.show;
}

-(void) alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        PlayerInfo *selectedPlayer = [cellData objectAtIndex:labelIndexPath.row];
        PlayerInfo *newPlayer = [[PlayerInfo alloc] init];
        newPlayer.playerName = textField.text;
        newPlayer.score = selectedPlayer.score;
        [cellData replaceObjectAtIndex:labelIndexPath.row withObject:newPlayer];
        [self.tableView reloadData];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    selectedCell = [cellData objectAtIndex:indexPath.row];
//    score = selectedCell.playerScore.text;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        [cellData removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */



- (IBAction)addPlayer:(id)sender {
    PlayerInfo *newPlayer = [[PlayerInfo alloc] init];
    newPlayer.playerName = @"New Player";
    newPlayer.score = 0;
    [cellData addObject:newPlayer];
    [self.tableView reloadData];
   
}
@end
