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

```objectivec
// get request
NSString *url = @"http://hostname/path/to/api";
NSDictionary *params = @{@"key": @"value"};

Deferred *deferred = [HttpClient doGet: url parameters: params];
[deferred then: ^id(id result) {
    // result is NSDictionary object translated from JSON
    NSDictionary *data = (NSDictionary *)result;
    // process data
    return data;
}];
[deferred resolve: nil];

// post request
NSString *url = @"http://hostname/path/to/api";
NSDictionary *params = @{@"key": @"value"};

Deferred *deferred = [HttpClient doPost: url parameters: params];
[deferred then: ^id(id result) {
    // result is NSDictionary object that translated from JSON
    NSDictionary *data = (NSDictionary *)result;
    // process data
    return data;
} failure: ^id(id result) {
    // result is NSError object
    NSError *error = (NSError *)result;
    // process error
    return error;
}];
[deferred resolve: nil];
```
