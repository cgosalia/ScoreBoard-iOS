//
//  PlayerDetailViewController.m
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 2/21/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import "PlayerDetailViewController.h"
#import "PlayerInfo.h"


@interface PlayerDetailViewController ()

@end

@implementation PlayerDetailViewController

@synthesize playerNameTextField;

@synthesize playerScoreTextField;

@synthesize receivedPlayerData;

@synthesize receivedIndexPath;

@synthesize receivedTableView;

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
    PlayerInfo *playerInfo = [receivedPlayerData objectAtIndex:receivedIndexPath.row];
    playerNameTextField.text = [playerInfo playerName];
    playerScoreTextField.text = [NSString stringWithFormat:@"%d",[playerInfo score]];
    NSLog(@"Rec: %@",[NSString stringWithFormat:@"%d",(int)receivedIndexPath.row]);
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)deletePlayer:(id)sender {
    NSLog(@"here");
    NSLog(@"Rec: %@",[NSString stringWithFormat:@"%d",(int)receivedIndexPath.row]);
    [receivedPlayerData removeObjectAtIndex:receivedIndexPath.row];
    [receivedTableView deleteRowsAtIndexPaths:@[receivedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)savePlayerDetails:(id)sender {
    if ([playerNameTextField.text length]>0) {
        PlayerInfo *selectedPlayer = [receivedPlayerData objectAtIndex:receivedIndexPath.row];
        if ((![selectedPlayer.playerName isEqualToString:playerNameTextField.text]) || (selectedPlayer.score != [playerScoreTextField.text intValue])) {
            PlayerInfo *newPlayer = [[PlayerInfo alloc] init];
            newPlayer.playerName = playerNameTextField.text;
            if ([playerScoreTextField.text length] > 0) {
                newPlayer.score = [playerScoreTextField.text intValue];
            }
            [receivedPlayerData replaceObjectAtIndex:receivedIndexPath.row withObject:newPlayer];
            [self.receivedTableView reloadData];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)updatePlayerDetails:(id)sender {
    if ([playerNameTextField.text length]>0) {
        PlayerInfo *selectedPlayer = [receivedPlayerData objectAtIndex:receivedIndexPath.row];
        if ((![selectedPlayer.playerName isEqualToString:playerNameTextField.text]) || (selectedPlayer.score != [playerScoreTextField.text intValue])) {
            PlayerInfo *newPlayer = [[PlayerInfo alloc] init];
            newPlayer.playerName = playerNameTextField.text;
            if ([playerScoreTextField.text length] > 0) {
                newPlayer.score = [playerScoreTextField.text intValue];
            }
            [receivedPlayerData replaceObjectAtIndex:receivedIndexPath.row withObject:newPlayer];
            [self.receivedTableView reloadData];
        }
    }

}


- (IBAction)cancelPlayerDetails:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
