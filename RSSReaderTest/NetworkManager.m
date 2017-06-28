//
//  NetworkManager.m
//  RSSReaderTest
//
//  Created by VLAD on 27/06/2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import "NetworkManager.h"
#import "AFNetworking.h"

@interface NetworkManager ()


@property (strong, nonatomic) NSURLSession *session;

@end

@implementation NetworkManager

+ (instancetype) sharedManager {
    
    static NetworkManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[NetworkManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:configuration
                                                     delegate:nil
                                                delegateQueue:nil];
        
    }
    return self;
}

#pragma mark - Reachability methods

- (void) startCheckingExistConnection: (void (^)()) existConnection notExistConnection: (void (^)()) notExistConnection {
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusReachableViaWiFi || status == AFNetworkReachabilityStatusReachableViaWWAN) {
            
            if (existConnection) {
                
                existConnection();
            }
            
        } else {
            
            if (notExistConnection) {
                
                notExistConnection();
            }
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void) stopCheckingConnection {
    
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}


- (void) getFeedWithUrl: (NSString *) URLStrng successHandler: (void(^) (NSData *rssData)) success andFailureHandler: (void(^) (NSError *error)) failure {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:URLStrng];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        
        NSString *documentsDirectory = [paths firstObject];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:[response suggestedFilename]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            
            NSError *error;
            
            [[NSFileManager defaultManager] removeItemAtPath:path
                                                       error:&error];
            
        }
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        NSURL *filePath = [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
        return filePath;
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        if (error && failure) {
            
            failure(error);
            
        } else {
            
            NSData *data = [NSData dataWithContentsOfURL:filePath];
            
            if (data && success) {
                
                success(data);
            }
        }
    }];
    [downloadTask resume];
}

@end
