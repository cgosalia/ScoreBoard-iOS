//
//  Message.h
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 3/30/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerInfo.h"

@interface Message : NSObject

+ (void) send:(NSMutableArray *)data;

+ (void) sendOneCell:(PlayerInfo *)playerInfoCell  forIndex:(NSInteger *)index withMessageType:(NSString *)msgType;

@end
