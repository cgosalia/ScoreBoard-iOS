//
//  Stack.m
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 3/10/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import "Stack.h"

@implementation Stack

- (id)init {
    if (self = [super init]) {
        contents = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

- (void)push:(NSObject *)object {
    [contents addObject:object];
}

- (NSObject *) pop {
    NSUInteger count = [contents count];
    if (count > 0) {
        NSObject *topObject = [contents objectAtIndex:count - 1];
        [contents removeLastObject];
        return topObject;
    }
    else {
        return nil;
    }
}

@end
