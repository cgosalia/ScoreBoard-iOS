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
#import "PlayerDetailViewController.h"
#import "IncrDecrScoreViewController.h"
#import "BluetoothSettingsViewController.h"
#import "AppDelegate.h"
#import "ScoreBoardViewController.h"
#import "SettingsViewController.h"

@interface TrackingModeViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation TrackingModeViewController

@synthesize cellData;

@synthesize settingsButton;

NSString *score;

PlayerCell *cell;

PlayerCell *selectedCell;

int playerId = 1;

BOOL longIncr = false;

BOOL longDecr = false;

bool incrementOrDecrementMassScore;

NSIndexPath *labelIndexPath;

NSNotification *notificationForScoreBoard;

NSMutableDictionary *trackingModeDataSource;

UIViewController *scoreboardController = nil;

NSMutableDictionary *isPlayerBeingEdited;

-(void) incrementScoreBy:(int)value forCellAtIndex:(NSIndexPath *)indexPath {
    PlayerInfo *selectedPlayer = [cellData objectAtIndex:indexPath.row];
    int score = selectedPlayer.score;
    score = score+value;
    PlayerInfo *newPlayer = [[PlayerInfo alloc] init];
    newPlayer.playerName = selectedPlayer.playerName;
    newPlayer.score = score;
    newPlayer.playerImg = selectedPlayer.playerImg;
    [cellData replaceObjectAtIndex:indexPath.row withObject:newPlayer];
    [self.tableView reloadData];
    [self sendMyMessage];
}

-(void) decrementScoreBy:(int)value forCellAtIndex:(NSIndexPath *)indexPath {
    PlayerInfo *selectedPlayer = [cellData objectAtIndex:indexPath.row];
    int score = selectedPlayer.score;
    //    if((score-value) >= 0) {
    score = score-value;
    //    }
    PlayerInfo *newPlayer = [[PlayerInfo alloc] init];
    newPlayer.playerName = selectedPlayer.playerName;
    newPlayer.score = score;
    newPlayer.playerImg = selectedPlayer.playerImg;
    [cellData replaceObjectAtIndex:indexPath.row withObject:newPlayer];
    [self.tableView reloadData];
    [self sendMyMessage];
    
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
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //_txtMsg.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:@"MCDidReceiveDataNotification"
                                               object:nil];
    trackingModeDataSource = [[NSMutableDictionary alloc] init];
    notificationForScoreBoard = [NSNotification notificationWithName:@"PlayerInfoChangedNotification"
                                                              object:self
                                                            userInfo:trackingModeDataSource];
    
    if(scoreboardController == nil) {
        scoreboardController = (ScoreBoardViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"ScoreBoardView"];
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:scoreboardController
                                             selector:@selector(updateScoreBoard:)
                                                 name:@"PlayerInfoChangedNotification"
                                               object:nil];
    
    NSUserDefaults *settingsDefault = [NSUserDefaults standardUserDefaults];
    [settingsDefault setInteger:1 forKey:@"preset1"];
    [settingsDefault setInteger:5 forKey:@"preset2"];
    [settingsDefault setInteger:10 forKey:@"preset3"];
    [settingsDefault setInteger:25 forKey:@"preset4"];
    
    isPlayerBeingEdited = [[NSMutableDictionary alloc] init];
    PlayerInfo *firstPlayer = [[PlayerInfo alloc] init];
    
    NSString *combinedName = [NSString stringWithFormat:@"%@%@%@", @"Player (", [NSString stringWithFormat:@"%d",playerId++],@")"];
    firstPlayer.playerName = combinedName;
    firstPlayer.score = 0;
    firstPlayer.playerImg = [UIImage imageNamed:@"unknownperson"];
    
    cellData = [[NSMutableArray alloc] initWithObjects:firstPlayer, nil];
    isPlayerBeingEdited[firstPlayer] = @NO;
    settingsButton = [settingsButton initWithTitle:@"\u2699" style:UIBarButtonItemStylePlain target:self action:@selector(goToSettings:)];
    UIFont *customFont = [UIFont fontWithName:@"Helvetica" size:25.0];
    NSDictionary *fontDictionary = @{UITextAttributeFont : customFont};
    [settingsButton setTitleTextAttributes:fontDictionary forState:UIControlStateNormal];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [settingsDefault synchronize];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSIndexPath *selectedRowIndexPath = [self.tableView indexPathForSelectedRow];
    if (selectedRowIndexPath) {
        [self.tableView deselectRowAtIndexPath:selectedRowIndexPath animated:YES];
    }
    
    [self sendMyMessage];
}

void LR_offsetView(UIView *view, CGFloat offsetX, CGFloat offsetY)
{
    view.frame = CGRectOffset(view.frame, offsetX, offsetY);
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

PlayerInfo *player;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellForPlayers";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    if (cell == nil) {
        cell = [[PlayerCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier ];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    player = [cellData objectAtIndex:indexPath.row];
    cell.playerName.text = player.playerName;
    cell.playerScore.text = [NSString stringWithFormat:@"%d", player.score];
    cell.playerImage.image = player.playerImg;
    
    // Configure single tap with two fingers for opening detail disclosure screen
    UITapGestureRecognizer *singleTapWithTwoFingers = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesturesOnCell:)];
    [singleTapWithTwoFingers setNumberOfTouchesRequired:2];
    [singleTapWithTwoFingers setNumberOfTapsRequired:1];
    [cell addGestureRecognizer:singleTapWithTwoFingers];
    
    UITapGestureRecognizer *doubleTapWithOneFinger = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesturesOnCell:)];
    [doubleTapWithOneFinger setNumberOfTapsRequired:2];
    [cell addGestureRecognizer:doubleTapWithOneFinger];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    [trackingModeDataSource setObject:cellData forKey:@"trackingModeDS"];
    [[NSNotificationCenter defaultCenter] postNotification:notificationForScoreBoard];
    return cell;
}

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName ];
    image = [UIImage imageWithCGImage:image.CGImage scale:6 orientation:image.imageOrientation];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

- (UILabel *)viewWithLabelName:(NSString *)labelName {
    UIView *labelView = [[UIView alloc] init];
    UILabel *label = [[UILabel alloc] init];
    label.text = labelName;
    [labelView addSubview:label];
    return label;
}


#pragma mark - UITableViewDataSource

- (void)configureCell:(PlayerCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIView *leftNormalView = [self viewWithImageName:@"minus"];
    UIColor *redColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];
    
    UIView *leftExtendedView = [self viewWithImageName:@"help"];
    UIColor *brownColor = [UIColor colorWithRed:206.0 / 255.0 green:149.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
    
    UIView *rightNormalView = [self viewWithImageName:@"plus"];
    UIColor *greenColor = [UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];
    
    UIView *rightExtendedView = [self viewWithImageName:@"help"];
    UIColor *yellowColor = [UIColor colorWithRed:254.0 / 255.0 green:217.0 / 255.0 blue:56.0 / 255.0 alpha:1.0];
    
    // Setting the default inactive state color to the tableView background color
    [cell setDefaultColor:self.tableView.backgroundView.backgroundColor];
    
    [cell setDelegate:self];
    
    
    [cell setSwipeGestureWithView:leftNormalView color:redColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        [self decrementScoreBy:1 forCellAtIndex:indexPath];
        
    }];
    
    [cell setSwipeGestureWithView:leftExtendedView color:yellowColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState2 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        incrementOrDecrementMassScore = false;
        [self performSegueWithIdentifier:@"incrDecrScoreSegue" sender: cell];
    }];
    
    [cell setSwipeGestureWithView:rightNormalView color:greenColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        [self incrementScoreBy:1 forCellAtIndex:indexPath];
    }];
    
    [cell setSwipeGestureWithView:rightExtendedView color:yellowColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState4 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        incrementOrDecrementMassScore = true;
        [self performSegueWithIdentifier:@"incrDecrScoreSegue" sender: cell];
    }];
}


#pragma mark - MCSwipeTableViewCellDelegate


// When the user starts swiping the cell this method is called
- (void)swipeTableViewCellDidStartSwiping:(MCSwipeTableViewCell *)cell {
    // NSLog(@"Did start swiping the cell!");
}

// When the user ends swiping the cell this method is called
- (void)swipeTableViewCellDidEndSwiping:(MCSwipeTableViewCell *)cell {
    // NSLog(@"Did end swiping the cell!");
}

// When the user is dragging, this method is called and return the dragged percentage from the border
- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didSwipeWithPercentage:(CGFloat)percentage {
    // NSLog(@"Did swipe with percentage : %f", percentage);
}

UIAlertView *progressAlert;

- (void) checkTimer:(NSTimer *)timer
{
	[progressAlert dismissWithClickedButtonIndex:-1 animated:YES];
    [timer invalidate];
}

-(void) handleTapGesturesOnCell:(UITapGestureRecognizer *) gesture {
    CGPoint tapLocation = [gesture locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:tapLocation];
    UITableViewCell *tappedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    PlayerInfo *player = [cellData objectAtIndex:indexPath.row];
    if (isPlayerBeingEdited[player]) {
        progressAlert = [[UIAlertView alloc] initWithTitle:@"Unable to get to details"
                                                   message:@"This player is being edited."
                                                  delegate: self
                                         cancelButtonTitle: nil
                                         otherButtonTitles: nil];
        [NSTimer scheduledTimerWithTimeInterval: 1.0f target: self selector:@selector(checkTimer:) userInfo: nil repeats: YES];
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityView.frame = CGRectMake(139.0f-18.0f, 78.0f, 37.0f, 37.0f);
        [progressAlert addSubview:activityView];
        [activityView startAnimating];
        [progressAlert show];
        return;
    }
    [self performSegueWithIdentifier:@"PlayerDetailsSegue" sender: tappedCell];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


- (void)longPressIncrement:(UILongPressGestureRecognizer*)gesture {
    if ( gesture.state == UIGestureRecognizerStateEnded ) {
        
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
        [alert show];
    }
    
}


- (void)longPressDecrement:(UILongPressGestureRecognizer*)gesture {
    if ( gesture.state == UIGestureRecognizerStateEnded ) {
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
        [alert show];
    }
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
            [self sendMyMessage];
        }
    }
    else if(alertView.tag==2 && buttonIndex == 1 ) {
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
            [self sendMyMessage];
        }
    }
    else if(alertView.tag==3 && buttonIndex == 1 ) {
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
                [alert show];
            }
            [self.tableView reloadData];
            [self sendMyMessage];
        }
    }
    else if(alertView.tag == 4)
    {
        if(buttonIndex == 1)
        {
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
                [self sendMyMessage];
            }
        }
        if(buttonIndex == 2)
        {
            UITextField *textField = [alertView textFieldAtIndex:0];
            if ([textField.text length]>0) {
                PlayerInfo *selectedPlayer = [cellData objectAtIndex:labelIndexPath.row];
                PlayerInfo *newPlayer = [[PlayerInfo alloc] init];
                int valueToIncr = [textField.text intValue];
                int currentScore = selectedPlayer.score;
                newPlayer.playerName = selectedPlayer.playerName;
                newPlayer.score = currentScore-valueToIncr;
                [cellData replaceObjectAtIndex:labelIndexPath.row withObject:newPlayer];
                [self.tableView reloadData];
                [self sendMyMessage];
            }
        }
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedCell = (PlayerCell *)[tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
/*
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
 */

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



#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PlayerDetailsSegue"]) {
        PlayerDetailViewController *playerDetailView = (PlayerDetailViewController *)segue.destinationViewController;
        playerDetailView.receivedPlayerData = cellData;
        playerDetailView.receivedIndexPath = [self.tableView indexPathForCell:sender];
        playerDetailView.receivedTableView = self.tableView;
    } else if ([segue.identifier isEqualToString:@"SettingsSegue"]) {
        SettingsViewController *settingsController = (SettingsViewController *)segue.destinationViewController;
        settingsController.receivedSBViewController = scoreboardController;
    } else if ([segue.identifier isEqualToString:@"incrDecrScoreSegue"]) {
        IncrDecrScoreViewController *incrDecrScoreView = (IncrDecrScoreViewController *)segue.destinationViewController;
        incrDecrScoreView.incrementOrDecrementFlag = incrementOrDecrementMassScore;
        incrDecrScoreView.receivedPlayerData = cellData;
        incrDecrScoreView.receivedIndexPath = [self.tableView indexPathForCell:sender];
        incrDecrScoreView.receivedTableView = self.tableView;
    }
}



- (IBAction)addPlayer:(id)sender {
    PlayerInfo *newPlayer = [[PlayerInfo alloc] init];
    NSString *combinedName = [NSString stringWithFormat:@"%@%@%@", @"Player (", [NSString stringWithFormat:@"%d",playerId++],@")"];
    newPlayer.playerName = combinedName;
    newPlayer.score = 0;
    newPlayer.playerImg = [UIImage imageNamed:@"unknownperson"];
    [cellData addObject:newPlayer];
    isPlayerBeingEdited[newPlayer] = @NO;
    [self.tableView reloadData];
    [self sendMyMessage];
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

- (IBAction)goToSettings:(id)sender {
    [self performSegueWithIdentifier:@"SettingsSegue" sender: sender];
}

-(void)sendMyMessage{
    
    NSInteger count = [self.cellData count];
    NSMutableDictionary *toSend =[[NSMutableDictionary alloc] init];
    PlayerInfo* player;
    for (int i = 0;i<count; i++) {
        player=[self.cellData objectAtIndex:i];
        NSString *key = [NSString stringWithFormat:@"%d",i];
        NSString *value = [NSString stringWithFormat:@"%@;#%d",player.playerName,player.score];
        [toSend setObject:value forKey:key];
    }
    NSData *messageData=[NSJSONSerialization dataWithJSONObject:toSend options:0 error:nil];
    NSArray *allPeers = _appDelegate.mcManager.session.connectedPeers;
    NSError *error=nil;
    
    [_appDelegate.mcManager.session sendData:messageData
                                     toPeers:allPeers
                                    withMode:MCSessionSendDataReliable
                                       error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
}

-(void)didReceiveDataWithNotification:(NSNotification *)notification{
    
    NSDictionary *receivedData = [notification userInfo];
    NSInteger count = [receivedData count];
    NSMutableArray *newCellData = [[NSMutableArray alloc] initWithObjects: nil];
    for(int i = 0 ;i<count ; i++){
        NSString *key = [NSString stringWithFormat:@"%d",i];
        NSString *value = [receivedData objectForKey:key];
        NSArray *combinedData = [value componentsSeparatedByString:@";#"];
        NSString *playerName = [combinedData objectAtIndex:0];
        NSString *playerScore = [combinedData objectAtIndex:1];
        PlayerInfo *player = [[PlayerInfo alloc] init];
        player.playerName = playerName;
        player.score = [playerScore intValue];
        [newCellData addObject:player];
        
    }
    [self.cellData removeAllObjects];
    [self.cellData addObjectsFromArray:newCellData];
    dispatch_async(dispatch_get_main_queue(),^{[self.tableView reloadData];});
    
}


@end
