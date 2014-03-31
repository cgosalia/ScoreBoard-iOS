//
//  DiscoveryInfo.h
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 3/31/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscoveryInfo : NSObject

@property NSMutableDictionary *discoveryInfoDictionary;

-(void) setDiscoveryInfoWithKey:(NSString *)key andValue:(NSString *)value;

-(NSDictionary *) getDiscoveryInfo;

+ (id) getInstance;

@end
