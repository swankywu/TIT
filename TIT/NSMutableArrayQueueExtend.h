//
//  NSMutableArrayQueueExtend.h
//  TIT
//
//  Created by swanky on 9/11/11.
//  Copyright 2011 iBrother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (NSMutableArrayQueueExtend)
- (id)dequeue;
- (void)enqueue:(id)obj;
- (id)peek;
@end
