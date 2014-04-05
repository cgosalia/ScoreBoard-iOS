//
//  PlayerInfo.h
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 2/10/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerInfo : NSObject <NSCopying, NSCoding>

@property NSString *playerName;

@property int score;

@property UIImage *playerImg;

@property int isBeingEdited;

@end
