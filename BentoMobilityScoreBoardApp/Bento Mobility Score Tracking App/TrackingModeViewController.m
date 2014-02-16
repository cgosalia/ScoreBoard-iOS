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

BOOL longIncr = false;

BOOL longDecr = false;

NSIndexPath *labelIndexPath;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    PlayerInfo *firstPlayer = [[PlayerInfo alloc] init];

    NSString *combinedName = [NSString stringWithFormat:@"%@%@%@", @"Player (", [NSString stringWithFormat:@"%d",playerId++],@")"];
    firstPlayer.playerName = combinedName;
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

    // Configure the cell
    
    if (cell == nil) {
        cell = [[PlayerCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
    }
    
    PlayerInfo *player = [cellData objectAtIndex:indexPath.row];
    cell.playerName.text = player.playerName;
    cell.playerScore.text = [NSString stringWithFormat:@"%d", player.score];
    [cell.incrementScore setTitle:@"+" forState:normal];
    [cell.decrementScore setTitle:@"-" forState:normal];
    
    // Configure double-tap gestures for editing label of player name
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [cell.playerName addGestureRecognizer:doubleTap];
    
    
    // Configure long press gesture for increment buttons
    UILongPressGestureRecognizer *longPressIncr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressIncrement:)];
    longPressIncr.minimumPressDuration = 1;  //1.0 seconds
    [cell.incrementScore addGestureRecognizer:longPressIncr];

    
    // Configure long press gesture for decrement buttons
    UILongPressGestureRecognizer *longPressDecr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDecrement:)];
    longPressDecr.minimumPressDuration = 1;  //1.0 seconds
    [cell.decrementScore addGestureRecognizer:longPressDecr];
    //cell.textLabel.text = [cellData objectAtIndex:indexPath.row];
    return cell;
}

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
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


- (void)longPressIncrement:(UILongPressGestureRecognizer*)gesture {
    if ( gesture.state == UIGestureRecognizerStateEnded ) {
        NSLog(@"long press of incremnent");
        UIView *uiView = (UIView *) gesture.view;
        while(![uiView isKindOfClass: [UITableViewCell class]]) {
            uiView = uiView.superview;
        }
        labelIndexPath = [self.tableView indexPathForCell:(UITableViewCell *)uiView];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Increment Score" message:@"Enter score value to add to current score" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *alertTextField = [alert textFieldAtIndex:0];
        alertTextField.keyboardType = UIKeyboardTypeNumberPad;
        [alert setTag:2];
        alert.show;
    }
}


- (void)longPressDecrement:(UILongPressGestureRecognizer*)gesture {
    if ( gesture.state == UIGestureRecognizerStateEnded ) {
        NSLog(@"long press of decrement");
        UIView *uiView = (UIView *) gesture.view;
        while(![uiView isKindOfClass: [UITableViewCell class]]) {
            uiView = uiView.superview;
        }
        labelIndexPath = [self.tableView indexPathForCell:(UITableViewCell *)uiView];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Decrement Score" message:@"Enter score value to subtract from current score" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *alertTextField = [alert textFieldAtIndex:0];
        alertTextField.keyboardType = UIKeyboardTypeNumberPad;
        [alert setTag:3];
        alert.show;
    }
}


-(void) handleDoubleTap:(UITapGestureRecognizer *) gesture {
    UIView *uiView = (UIView *) gesture.view;
    while(![uiView isKindOfClass: [UITableViewCell class]]) {
        uiView = uiView.superview;
    }
    labelIndexPath = [self.tableView indexPathForCell:(UITableViewCell *)uiView];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Player Name" message:@"Enter a new name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert setTag:1];
    alert.show;
}

-(void) alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag==1 && buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if ([textField.text length]>0) {
            PlayerInfo *selectedPlayer = [cellData objectAtIndex:labelIndexPath.row];
            PlayerInfo *newPlayer = [[PlayerInfo alloc] init];
            newPlayer.playerName = textField.text;
            newPlayer.score = selectedPlayer.score;
            [cellData replaceObjectAtIndex:labelIndexPath.row withObject:newPlayer];
            [self.tableView reloadData];
        }
    }
    if(alertView.tag==2 && buttonIndex == 1 ) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if ([textField.text length]>0) {
            PlayerInfo *selectedPlayer = [cellData objectAtIndex:labelIndexPath.row];
            PlayerInfo *newPlayer = [[PlayerInfo alloc] init];
            int valueToIncr = [textField.text intValue];
            int currentScore = selectedPlayer.score;
            newPlayer.playerName = selectedPlayer.playerName;
            newPlayer.score = currentScore+valueToIncr;
            [cellData replaceObjectAtIndex:labelIndexPath.row withObject:newPlayer];
            [self.tableView reloadData];
        }
    }
    if(alertView.tag==3 && buttonIndex == 1 ) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if ([textField.text length]>0) {
            PlayerInfo *selectedPlayer = [cellData objectAtIndex:labelIndexPath.row];
            
            int valueToDecr = [textField.text intValue];
            int currentScore = selectedPlayer.score;
            
            if(currentScore-valueToDecr > 0) {
                PlayerInfo *newPlayer = [[PlayerInfo alloc] init];
                newPlayer.playerName = selectedPlayer.playerName;
                newPlayer.score = currentScore-valueToDecr;
                [cellData replaceObjectAtIndex:labelIndexPath.row withObject:newPlayer];
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Score" message:@"Score cannot go below zero" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                alert.alertViewStyle = UIAlertViewStyleDefault;
                [alert setTag:4];
                alert.show;
            }
            [self.tableView reloadData];
            
        }
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
    NSString *combinedName = [NSString stringWithFormat:@"%@%@%@", @"Player (", [NSString stringWithFormat:@"%d",playerId++],@")"];
    newPlayer.playerName = combinedName;
    newPlayer.score = 0;
    [cellData addObject:newPlayer];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"Editable Player Info", @"playerInfoSection");
            break;
        default:
            sectionName = @"OTHER";
            break;
    }
    return sectionName;
}
@end
