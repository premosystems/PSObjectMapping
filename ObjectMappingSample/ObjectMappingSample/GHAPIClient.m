// GHAPIClient.h

#import "GHAPIClient.h"
#import "AFNetworkActivityLogger.h"
#import "GHConstants.h"

@implementation GHAPIClient

static GHAPIClient *_sharedClient;

+ (GHAPIClient *)sharedClient {
    
    if (!_sharedClient) {
        _sharedClient = [[GHAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kGHBaseURLString]];
    }
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [[AFNetworkActivityLogger sharedLogger] startLogging];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:AFNetworkingOperationDidStartNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      NSLog(@"Operation Started: %@", [note object]);
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:AFNetworkingOperationDidFinishNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      NSLog(@"Operation Finished: %@", [note object]);
                                                  }];
    return self;
}

@end
