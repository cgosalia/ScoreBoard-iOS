//
//  SettingsViewController.h
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 2/22/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "ScoreBoardViewController.h"

@interface SettingsViewController : UIViewController<UITextViewDelegate>


@property (strong, nonatomic) UITextField *gameName;

@property (nonatomic, strong) AppDelegate *appDelegate;

- (IBAction)defaultPresets:(id)sender;

- (IBAction)goToScoreBoard:(id)sender;

@property (atomic) IBOutlet UIViewController *receivedSBViewController;

@property (atomic) IBOutlet UITableView *receivedTableView;

- (NSString *) stringForGameNameAt:(int)section;

@end
