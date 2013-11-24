// GHAPIClient.h

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface GHAPIClient : AFHTTPSessionManager

+ (GHAPIClient *)sharedClient;

@end
