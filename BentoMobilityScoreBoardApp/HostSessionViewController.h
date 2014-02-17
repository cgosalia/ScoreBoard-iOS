//
//  HostSessionViewController.h
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 2/16/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Server.h"

@interface HostSessionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ServerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *HostName;

@property (strong, nonatomic) IBOutlet UITableView *hostListOfClients;

@end
