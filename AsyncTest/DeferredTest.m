//
//  DeferredTest.m
//  AsyncTest
//
//  Copyright (c) 2012 yo_waka. All rights reserved.
//

#import "Deferred.h"
#import <GHUnitIOS/GHUnit.h>


@interface DeferredTest : GHAsyncTestCase
@end


@implementation DeferredTest

- (void)setUpClass
{
}

- (void)tearDownClass
{
}

- (void) setup
{
}

- (void) tearDown
{
}

- (void) testResolve
{
    Deferred *deferred = [Deferred defer];
    GHAssertFalse([deferred isResolved], @"Not resolved yet");
    
    [deferred resolve: nil];
    GHAssertTrue([deferred isResolved], @"Deferred has resolved");
}

- (void) testReject
{
    Deferred *deferred = [Deferred defer];
    GHAssertFalse([deferred isRejected], @"Not rejected yet");
    
    [deferred reject: nil];
    GHAssertTrue([deferred isRejected], @"Deferred has rejected");
}

- (void) testThen
{
    __block int count = 0;
    Deferred *deferred = [Deferred defer];
    
    [[deferred then: ^(id resultObject) {
        GHTestLog(@"%d", count);
        count++;
        GHAssertEquals(1, count, @"first call");
        return resultObject;
    }] resolve: nil];
    
    [[deferred then: ^(id resultObject) {
        GHTestLog(@"%d", count);
        count++;
        GHAssertEquals(2, count, @"second call");
        @throw [NSException exceptionWithName: @"UnForcedError"
                                       reason: @"unforced error"
                                     userInfo: nil];
        return resultObject;
    }] then: nil failure: ^(id error) {
        GHTestLog(@"%d", count);
        GHAssertEquals(2, count, @"third call");
        return error;
    }];
}

- (void) testNext
{
    [self prepare];
    __block int count = 0;
    
    Deferred *d1 = [Deferred defer];
    [[[d1 then: ^(id resultObject) {
        GHTestLog(@"first");
        count++;
        GHAssertEquals(1, count, @"first call");
        return resultObject;
    }] next: ^(id resultObject) {
        GHTestLog(@"third");
        count++;
        GHAssertEquals(3, count, @"third call");
        return resultObject;
    }] then: ^(id resultObject) {
        GHTestLog(@"fourth");
        count++;
        GHAssertEquals(4, count, @"fourth call");
        
        [self notify:kGHUnitWaitStatusSuccess];
        return resultObject;
    }];
    
    Deferred *d2 = [Deferred defer];
    [d2 then: ^(id resultObject) {
        GHTestLog(@"second");
        count++;
        GHAssertEquals(2, count, @"second call");
        return resultObject;
    }];
    
    [d1 resolve: nil];
    [d2 resolve: nil];
    
    [self waitForStatus: kGHUnitWaitStatusSuccess timeout: 10.0f];
}

@end
