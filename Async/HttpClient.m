//
//  HttpClient.m
//  Async
//
//  Copyright (c) 2012 yo_waka. All rights reserved.
//

#import "HttpClient.h"


/**
 * Prototype of private properties and methods.
 */
@interface HttpClient()

+ (Deferred *) _send: (NSMutableURLRequest *)req;

@end


/**
 * HttpClient implementation.
 */

@implementation HttpClient

+ (Deferred *) doGet: (NSString *)url parameters: (NSDictionary *)params
{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:url];
    if (params) {
        [urlString appendString: @"?"];
        [urlString appendString: [HttpClient makeQuerystringFromDict: params]];
    }
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: urlString]
                                                       cachePolicy: NSURLRequestUseProtocolCachePolicy
                                                   timeoutInterval: 30.0];
    [req setHTTPMethod: @"GET"];
    [req setValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    
    return [self _send: req];
}

+ (Deferred *) doPost: (NSString *)url parameters: (NSDictionary *)params
{
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: url]
                                                       cachePolicy: NSURLRequestUseProtocolCachePolicy
                                                   timeoutInterval: 30.0];
    [req setHTTPMethod: @"POST"];
    [req setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField: @"Content-Type"];

    if (params) {
        NSString *postString = [HttpClient makeQuerystringFromDict: params];
        NSData *postData = [NSData dataWithBytes: [postString UTF8String]
                                          length: [postString length]];
        [req setValue: [NSString stringWithFormat: @"%d", [postString length]] forHTTPHeaderField: @"Content-Length"];
        [req setHTTPBody: postData];
    }
    
    return [self _send: req];
}

+ (Deferred *) _send: (NSMutableURLRequest *)req
{
    Deferred *deferred = [Deferred defer];
    __weak Deferred *wd = deferred;

    // Make an NSOperationQueue
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue setName:@"AsyncHttpRequestQueue"];
    
    // Send an asyncronous request on the queue
    [NSURLConnection sendAsynchronousRequest: req
                                       queue: queue
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error) {
        
        // If there was an error getting the data
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [wd reject: error];
            });
            return;
        }
        
        // Decode the data
        NSError *jsonError;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData: data
                                                                     options: 0
                                                                       error: &jsonError];
        
        // If there was an error decoding the JSON
        if (jsonError) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [wd reject: jsonError];
            });
            return;
        }
        
        // All looks fine, lets call the completion block with the response data
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [wd resolve: responseDict];;
        });
    }];
    
    return deferred;
}


+ (NSString *) urlEncode: (id)obj
{
    NSString *string = [NSString stringWithFormat: @"%@", obj];
    return [string stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
}

+ (NSString *) makeQuerystringFromDict: (NSDictionary *)dict
{
    NSMutableArray *parts = [NSMutableArray array];
    for (id key in dict) {
        id value = [dict objectForKey: key];
        NSString *part = [NSString stringWithFormat: @"%@=%@",
                          [HttpClient urlEncode: key], [HttpClient urlEncode: value]];
        [parts addObject: part];
    }
    return [parts componentsJoinedByString: @"&"];
}

@end
