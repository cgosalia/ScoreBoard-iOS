//
//  Stack.h
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 3/10/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stack : NSObject
{
    NSMutableArray *contents;
}
- (void)push:(NSObject *)object;

- (NSObject *) pop;

@end
