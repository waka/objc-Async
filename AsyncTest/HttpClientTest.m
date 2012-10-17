//
//  HttpClientTest.m
//  Async
//
//  Copyright (c) 2012 yo_waka. All rights reserved.
//

#import "HttpClient.h"
#import <GHUnitIOS/GHUnit.h>


@interface HttpClientTest : GHAsyncTestCase
@end


@implementation HttpClientTest

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

- (void) testDoGet
{
    NSString *url = @"https://api.github.com";
    Deferred *d = [HttpClient doGet: url parameters: nil];
    [d then: ^id(id resultObject) {
        return resultObject;
    }];
}

- (void) testDoPost
{
}

@end
