//
//  SimpleTableCell.h
//  SimpleTable
//
//  Created by Simon Ng on 28/4/12.
//  Copyright (c) 2012 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *playerName;
@property (nonatomic, weak) IBOutlet UILabel *increment;
@property (nonatomic, weak) IBOutlet UILabel *decrement;
@property (nonatomic, weak) IBOutlet UILabel *score;
@end
