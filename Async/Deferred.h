//
//  Deferred.h
//  Async
//
//  Copyright (c) 2012 yo_waka. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * The definition of Promise/A interface.
 */

typedef id (^CallbackBlock)(id resultObject);
typedef id (^ErrBackBlock)(id resultObject);

@protocol Promise

@required
- (void) resolve: (id)valueObject;

@required
- (void) reject: (id)valueObject;

@required
- (id) then: (CallbackBlock)cb failure: (ErrBackBlock)eb;

@end


/**
 * Deferred states.
 */

typedef enum {
    Unresolved,
    Resolved,
    Rejected
} DeferredState;


/**
 * The deferred must be implemented Promise/A interface.
 */

@interface Deferred : NSObject<Promise>

// Using ARC properties

@property (nonatomic, strong) id result;
@property (nonatomic, unsafe_unretained) DeferredState state;
@property (nonatomic, strong) NSMutableArray *chain;

// Class methods

+ (Deferred *) defer;

// Instance methods

- (Deferred *) then: (CallbackBlock)cb;
- (Deferred *) next: (CallbackBlock)cb;
- (Deferred *) next: (CallbackBlock)cb failure: (ErrBackBlock)eb;
- (BOOL) isResolved;
- (BOOL) isRejected;

@end
