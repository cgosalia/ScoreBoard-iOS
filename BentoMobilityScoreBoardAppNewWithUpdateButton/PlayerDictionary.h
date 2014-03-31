//
//  PlayerDictionary.h
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 3/30/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerDictionary : NSObject <NSSecureCoding>

@property NSMutableDictionary *playerDictionary;

-(void) add:(NSString *)key value:(NSData *)data;

-(NSData *) getDataFor:(NSString *)key;

-(NSMutableDictionary *) getDictionary;

@end
