# objc-Async

* Deferred
* HttpClient(GET/POST request using Deferred)

## Usage

### Deferred

```objectivec
// set callback and errback
Deferred *deferred = [Deferred defer];
[deferred then: ^id(id result) {
    // process result object
    return result;
} failure: ^id(id result) {
    NSError *error = (NSError *)result;
    // process error object
}];
[deferred resolve: nil];

// chain callbacks
Deferred *deferred = [Deferred defer];
[[deferred then: ^id(id result) {
    // process result object
    return result;
}] then: ^id(id result) {
    // process result object
    return result;
}];
[deferred resolve: nil];
```

### HttpClient

Required modules are "Reachability" and "SVProgressHD"

```objectivec
// get json request
NSString *url = @"http://hostname/path/to/api";
NSDictionary *params = @{@"key": @"value"};

HttpClient *client = [HttpClient clientWithUrl: url];
[client getJsonWithDelegate: params
                    headers: nil
                   delegate: self
                    success: @selector(handleGetSuccess:)
                    failure: @selector(handleGetFailure:)];

// post request
NSString *url = @"http://hostname/path/to/api";
NSDictionary *params = @{@"key": @"value"};

HttpClient *client = [HttpClient clientWithUrl: url];
[client postWithDelegate: params
                 headers: nil
                delegate: self
                 success: @selector(handlePostSuccess:)
                 failure: @selector(handlePostFailure:)];

// and can use PUT/DELETE request, see HttpClient.h
```
