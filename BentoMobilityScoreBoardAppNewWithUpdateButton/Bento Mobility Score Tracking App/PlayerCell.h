//
//  PlayerCell.h
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 2/9/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSwipeTableViewCell.h"

@interface PlayerCell : MCSwipeTableViewCell

@property (strong, nonatomic) IBOutlet UILabel *playerName;

@property (strong, nonatomic) IBOutlet UILabel *playerScore;

@property (strong, nonatomic) IBOutlet UIImageView *playerImage;

@end
