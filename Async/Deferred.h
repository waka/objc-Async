//
//  Deferred.h
//  Async
//
//  Copyright (c) 2012 yo_waka. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * Callback blocks.
 */

typedef id (^CallbackBlock)(id resultObject);
typedef id (^ErrBackBlock)(id resultObject);


/**
 * Definition of Promise/A interface.
 */

@protocol Promise

@required
- (void) resolve: (id)valueObject;
- (void) reject: (id)valueObject;
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
 * Deferred must be implemented Promise/A interface.
 */

@interface Deferred : NSObject<Promise>

// Class methods

+ (Deferred *) defer;

// Instance methods

- (Deferred *) then: (CallbackBlock)cb;
- (Deferred *) next: (CallbackBlock)cb;
- (Deferred *) next: (CallbackBlock)cb failure: (ErrBackBlock)eb;
- (BOOL) isResolved;
- (BOOL) isRejected;

@end
