//
//  HttpClient.h
//  Async
//
//  Copyright (c) 2012 yo_waka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deferred.h"


@interface HttpClient : NSObject

+ (Deferred *) doGet: (NSString *)url params: (NSDictionary *)params;
+ (Deferred *) doPost: (NSString *)url params: (NSDictionary *)params;

@end
