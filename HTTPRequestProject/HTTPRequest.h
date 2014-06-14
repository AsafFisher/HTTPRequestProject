//
//  HTTPRequest.h
//  HTTPRequestProject
//
//  Created by Asaf Fisher on 5/21/14.
//  Copyright (c) 2014 Asaf Fisher. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTTPResult;
@class HTTPRequest;
@protocol HTTPRequestDelegate<NSObject>

- (void) request:(HTTPRequest *)request finishedWithResult:(HTTPResult *)result;

@end

typedef enum {
    HTTPRequestTypeNone = 0,
    HTTPRequestTypeBDApp,
}HTTPRequestType;

typedef void(^HTTPRequestBlock)(HTTPResult *result);

@interface HTTPRequest : NSObject

@property (nonatomic) HTTPRequestType requestType;
@property (nonatomic, strong) HTTPResult *requestResult;
@property (nonatomic, strong) id <HTTPRequestDelegate> requestDelegate;
//Init Methods
- (id) initWithReqestType:(HTTPRequestType)type;
- (id) initWithReqestType:(HTTPRequestType)type delegate:(id <HTTPRequestDelegate>) delegate;
+ (id) requestWithType:(HTTPRequestType)type;
+ (id) requestWithType:(HTTPRequestType)type delegate:(id <HTTPRequestDelegate>)delegate;

//Start Methods
- (void)startSync:(BOOL)Sync;
- (void)startSync:(BOOL)Sync block:(HTTPRequestBlock)block;

//Request Arguments Methods
- (void) addInteger:(NSInteger)val forKey:(NSString *)key;
- (void) addBool:(BOOL)val forKey:(NSString *)key;
- (void) addDouble:(double)val forKey:(NSString *)key;
- (void) addDate:(NSDate *)val forKey:(NSString *)key;
- (void) addString:(NSString *)val forKey:(NSString *)key;
- (void) addValue:(id)val forKey:(NSString*)key;



@end




@interface HTTPResult : NSObject

@property (nonatomic, strong) id data;
@property (nonatomic, strong) NSError *error;

@end




































