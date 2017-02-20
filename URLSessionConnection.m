//
//  URLSessionConnection.m
//  NSURLSessionTest
//
//  Created by Ed on 2015/10/13.
//  Copyright © 2015年 Ed. All rights reserved.
//

#import "URLSessionConnection.h"

#define TIME_OUT_INTERVAL 20


@interface URLSessionConnection () <NSURLSessionDataDelegate,NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDownloadDelegate>

@end

@implementation URLSessionConnection

- (void)dataTaskWithUrl:(NSString*)url parameters:(NSDictionary*)parameters
{    
    NSURLSessionConfiguration* defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* urlSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString* postString = [self composePostData:parameters];    
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask* dataTask = [urlSession dataTaskWithRequest:request];
    [dataTask resume];
}

- (NSURLSessionDataTask*)dataTaskWithUrl:(NSString*)url parameters:(NSMutableDictionary*)parameters completionHandler:(void (^)(NSData* data, NSURLResponse* response, NSError* error))completionHandler
{
//    NSString* completeURL = [NSString stringWithFormat:@"%@?%@",url,[self composePostData:parameters]];
//    NSLog(@"sessionCompleteURL:%@",completeURL);
    
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* urlSession = [NSURLSession sessionWithConfiguration: sessionConfig delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TIME_OUT_INTERVAL];
    [request setHTTPMethod:@"POST"];
    NSString* postString = [self composePostData:parameters];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask* dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
//        NSString* strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"sessionResponse:%@\ndata:%@\nerror:%@",response,strData,error);
        if (completionHandler) {
            completionHandler(data, response, error);
        }
    }];
    [dataTask resume];
    
    return dataTask;
}

/* 將dictinary組合成post字串 */
- (NSString*)composePostData:(NSDictionary*)dicPostData
{
    NSMutableArray* postArray = [[NSMutableArray alloc] init];
    for (NSString* key in dicPostData) {
        
        /* percentEscapeString處理特殊字元 */
        NSString* tempString = [[NSString alloc] initWithFormat:@"%@=%@", key, [self percentEscapeString:[dicPostData objectForKey:key]]];
        
        [postArray addObject:tempString];
    }
    
    return [postArray componentsJoinedByString:@"&"];
}

- (NSString *)percentEscapeString:(NSString *)string
{
    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)string,
                                                                                 (CFStringRef)@" ",
                                                                                 (CFStringRef)@":/?%@!$&'()*+,;=",
                                                                                 kCFStringEncodingUTF8));
    return [result stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

#pragma -
#pragma NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
//    NSLog(@"NSURLSession didReceiveResponse: %@",response);
    if ([_delegate respondsToSelector:@selector(URLSessionDidReceiveResponse:)]) {
        [_delegate URLSessionDidReceiveResponse:response];
    }
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
//    NSLog(@"NSURLSession didReceiveData: %@",data);
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
//    NSLog(@"NSURLSession didBecomeDownloadTask: %@",downloadTask);
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeStreamTask:(NSURLSessionStreamTask *)streamTask
{
//    NSLog(@"NSURLSession didBecomeStreamTask: %@",streamTask);
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse * __nullable cachedResponse))completionHandler
{
//    NSLog(@"NSURLSession willCacheResponse: %@",proposedResponse);
}

#pragma -
#pragma NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
//    NSLog(@"didReceiveChallenge: %@",challenge);
}

#pragma -
#pragma NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
//    NSLog(@"didFinishDownloadingToURL: %@",location);
}

@end
