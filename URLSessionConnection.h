//
//  URLSessionConnection.h
//  NSURLSessionTest
//
//  Created by Ed on 2015/10/13.
//  Copyright © 2015年 Ed. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol URLSessionDataDelegate;


@interface URLSessionConnection : NSObject

@property (nonatomic, strong) id<URLSessionDataDelegate> delegate;


/* 不需實作delegate，completionHandler會回傳結果 */
- (NSURLSessionDataTask*)dataTaskWithUrl:(NSString*)url parameters:(NSDictionary*)parameters completionHandler:(void (^)(NSData* data, NSURLResponse* response, NSError* error))completionHandler;

/* 使用這些方法需要實作delegate */
- (void)dataTaskWithUrl:(NSString*)url parameters:(NSDictionary*)parameters;

@end


@protocol URLSessionDataDelegate <NSObject>

@optional

- (void)URLSessionDidReceiveResponse:(NSURLResponse*)response;

@end