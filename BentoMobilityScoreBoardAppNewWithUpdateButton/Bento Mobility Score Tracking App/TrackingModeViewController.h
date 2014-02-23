//
//  TrackingModeViewController.h
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 2/8/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackingModeViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *cellData;

- (IBAction)addPlayer:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *settingsButton;

- (IBAction)goToSettings:(id)sender;

@end
