//
//  IncrDecrScoreViewController.h
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 3/1/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IncrDecrScoreViewController : UIViewController

// True indicate increment and False to decrement
@property (atomic) BOOL incrementOrDecrementFlag;

@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;

@property (strong, nonatomic) IBOutlet UILabel *label;

@property (strong, nonatomic) IBOutlet UILabel *infoLabel;

- (IBAction)cancelIncrDecr:(id)sender;

- (IBAction)doneIncrDecr:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *currentScore;

@property (strong, nonatomic) IBOutlet UITextField *totalScore;

@property (strong, nonatomic) IBOutlet UIButton *preset1;

- (IBAction)incrDecrByPreset1:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *preset2;

- (IBAction)incrDecrByPreset2:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *preset3;

- (IBAction)incrDecrByPreset3:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *preset4;

- (IBAction)incrDecrByPreset4:(id)sender;

@property (atomic) IBOutlet NSMutableArray *receivedPlayerData;

@property (atomic, copy) IBOutlet NSIndexPath *receivedIndexPath;

@property (atomic) IBOutlet UITableView *receivedTableView;

- (IBAction)undoScoreChange:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *undoButton;

@end
