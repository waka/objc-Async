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

- (void) testMakeQuerystring
{
    NSDictionary *params = @{@"foo": @"bar"};
    NSString *querystring = [HttpClient makeQuerystringFromDict: params];
    GHAssertEqualStrings(querystring, @"foo=bar", @"query string test");
}

- (void) testDoGetSuccess
{
    [self prepare];
    
    NSString *url = @"https://api.github.com/legacy/repos/search/objc-Async";
    Deferred *d = [HttpClient doGet: url parameters: nil];
    [d then: ^id(id resultObject) {
        NSDictionary *data = (NSDictionary *)resultObject;
        
        // get first repository
        NSArray *repositories = [data objectForKey: @"repositories"];
        NSString *name = [repositories[0] objectForKey:@"name"];
        GHTestLog(name);
        GHAssertEqualStrings(name, @"objc-Async", @"first repository is this project");
        
        [self notify:kGHUnitWaitStatusSuccess];
        return resultObject;
    }];
    
    [self waitForStatus: kGHUnitWaitStatusSuccess timeout: 10.0f];
}

- (void) testDoGetFailure
{
    [self prepare];
    
    NSString *url = @"https://not/exist/path";
    Deferred *d = [HttpClient doGet: url parameters: nil];
    [d then: ^id(id resultObject) {
        GHTestLog(@"Not reach here");
        
        [self notify:kGHUnitWaitStatusSuccess];
        return resultObject;
    } failure:^id(id resultObject) {
        NSError *error = (NSError *)resultObject;
        GHTestLog(@"%@", [error localizedDescription]);
        
        [self notify:kGHUnitWaitStatusSuccess];
        return resultObject;
    }];
    
    [self waitForStatus: kGHUnitWaitStatusSuccess timeout: 10.0f];
}

- (void) testDoPost
{
}

@end
