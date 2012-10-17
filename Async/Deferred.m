//
//  Deferred.m
//  Async
//
//  Copyright (c) 2012 yo_waka. All rights reserved.
//

#import "Deferred.h"


/**
 * Prototype of private properties and methods.
 */

@interface Deferred()

// Using ARC properties

@property (nonatomic, strong) id result;
@property (nonatomic, unsafe_unretained) DeferredState state;
@property (nonatomic, strong) NSMutableArray *chain;

- (void) _fire: (id)valueObject;

@end


/**
 * Deferred implementation.
 */

@implementation Deferred

- (id) init
{
    self = [super init];
    if (self) {
        self.result = nil;
        self.state = Unresolved;
        self.chain = [NSMutableArray array];
    }
    return self;
}

+ (Deferred *) defer
{
    return [[self alloc] init];
}

- (void) resolve: (id)valueObject
{
    self.state = Resolved;
    [self _fire: valueObject];
}

- (void) reject: (id)valueObject
{
    self.state = Rejected;
    [self _fire: valueObject];
}

- (Deferred *) then: (CallbackBlock)cb
{
    return [self then: cb failure: nil];
}

- (Deferred *) then: (CallbackBlock)cb failure: (ErrBackBlock)eb
{
    NSMutableArray *arr = [NSMutableArray array];
    if (cb) {
        [arr addObject: cb];
    } else {
        [arr addObject: [NSNull null]];
    }
    if (eb) {
        [arr addObject: eb];
    } else {
        [arr addObject: [NSNull null]];
    }
    [self.chain addObject: arr];
    
    if (self.state != Unresolved) {
        [self _fire: nil];
    }
    return self;
}

- (Deferred *) next: (CallbackBlock)cb
{
    return [self next: cb failure: nil];
}

- (Deferred *) next: (CallbackBlock)cb failure:(ErrBackBlock)eb
{
    Deferred *deferred = [Deferred defer];
    __weak Deferred *wd = deferred;
    
    [self then: ^id(id resultObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [wd resolve: cb(resultObject)];
        });
        return resultObject;
    } failure: ^id(id resultObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [wd reject: eb(resultObject)];
        });
        return resultObject;
    }];
    
    return deferred;
}

- (BOOL) isResolved
{
    return self.state == Resolved;
}

- (BOOL) isRejected
{
    return self.state == Rejected;
}

- (void) _fire: (id)valueObject
{
    id res = self.result = (valueObject != nil) ? valueObject : self.result;
    
    while ([self.chain count] > 0) {
        NSArray *entry = self.chain[0];
        [self.chain removeObjectAtIndex: 0];
        
        CallbackBlock fn = [self isRejected] ? entry[1] : entry[0];
        if (fn) {
            @try {
                res = self.result = fn(res);
            }
            @catch (NSException *ex) {
                self.state = Rejected;
                res = self.result = ex;
            }
        }
    }
}

@end
