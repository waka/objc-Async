//
//  HttpClient.h
//  Async
//
//  Copyright (c) 2012 yo_waka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deferred.h"


/**
 * Make easy to handle HTTP request by Deferred pattern.
 */

@interface HttpClient : NSObject

// Class methods

+ (Deferred *) doGet: (NSString *)url parameters: (NSDictionary *)params;
+ (Deferred *) doPost: (NSString *)url parameters: (NSDictionary *)params;
+ (NSString *) urlEncode: (id)obj;
+ (NSString *) makeQuerystringFromDict: (NSDictionary *)dict;

@end
