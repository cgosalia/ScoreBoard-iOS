//
//  PlayerDetailViewController.h
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 2/21/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *playerNameTextField;

@property (strong, nonatomic) IBOutlet UITextField *playerScoreTextField;

- (IBAction)deletePlayer:(id)sender;

- (IBAction)savePlayerDetails:(id)sender;

- (IBAction)updatePlayerDetails:(id)sender;

@property (atomic) IBOutlet NSMutableArray *receivedPlayerData;

@property (atomic, copy) IBOutlet NSIndexPath *receivedIndexPath;

@property (atomic) IBOutlet UITableView *receivedTableView;

- (IBAction)cancelPlayerDetails:(id)sender;

@end
