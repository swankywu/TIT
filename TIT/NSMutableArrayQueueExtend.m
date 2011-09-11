//
//  NSMutableArrayQueueExtend.m
//  TIT
//
//  Created by swanky on 9/11/11.
//  Copyright 2011 iBrother. All rights reserved.
//

#import "NSMutableArrayQueueExtend.h"

@implementation NSMutableArray (NSMutableArrayQueueExtend)
// Queues are first-in-first-out, so we remove objects from the head
- (id)dequeue {

    if([self count] == 0) return nil; // to avoid raising exception (Quinn)
    id headObject = [self objectAtIndex:0];
    if (headObject != nil) {
        [[headObject retain] autorelease]; // so it isn't dealloc'ed on remove
        [self removeObjectAtIndex:0];
    }
    return headObject;
}

// Add to the tail of the queue (no one likes it when people cut in line!)
- (void)enqueue:(id)anObject {
    [self addObject:anObject];
    //this method automatically adds to the end of the array
}
// Get first obj in queue, but don't remove ti from the queue
- (id)peek{
    if([self count] == 0) return nil; // to avoid raising exception (Quinn)
    id headObject = [self objectAtIndex:0];
    return headObject;

}
@end
