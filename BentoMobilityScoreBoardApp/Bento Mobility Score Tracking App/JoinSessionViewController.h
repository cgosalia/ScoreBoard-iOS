//
//  JoinSessionViewController.h
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 2/16/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Client.h"

@interface JoinSessionViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITextFieldDelegate, ClientDelegate>

@property (strong, nonatomic) IBOutlet UITextField *ClientName;

@property (strong, nonatomic) IBOutlet UITableView *clientListOfHosts;


@end
