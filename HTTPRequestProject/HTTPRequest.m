//
//  HTTPRequest.m
//  HTTPRequestProject
//
//  Created by Asaf Fisher on 5/21/14.
//  Copyright (c) 2014 Asaf Fisher. All rights reserved.
//

#import "HTTPRequest.h"
#import "NSData+json.h"
@interface HTTPRequest ()<NSURLConnectionDataDelegate>
//store the request arguments
@property (nonatomic, strong)NSMutableDictionary *params;
//get the data on a-sync request
@property (nonatomic, strong) NSMutableData *mutableData;

// store the block
@property(nonatomic, assign) void *requestBlock;

@end
@implementation HTTPRequest
@synthesize params,requestType,requestDelegate,requestBlock,requestResult,mutableData;
- (id)init
{
    self = [super init];
    if (self) {
        self.requestType = HTTPRequestTypeNone;
        self.params = [[NSMutableDictionary alloc]init];
        
    }
    return self;
}

- (id) initWithReqestType:(HTTPRequestType)type{
    return [self initWithReqestType:type delegate:nil];
}
- (id) initWithReqestType:(HTTPRequestType)type delegate:(id <HTTPRequestDelegate>) delegate{
    if (self = [self init]) {
        self.requestType = type;
        self.requestDelegate = delegate;
        
    }
    return self;
}


+ (id) requestWithType:(HTTPRequestType)type{
    return [[self alloc]initWithReqestType:type];
}

+ (id) requestWithType:(HTTPRequestType)type delegate:(id <HTTPRequestDelegate>)delegate{
    return [[self alloc]initWithReqestType:type delegate:delegate];
    
}
#pragma mark - StartMethods
- (NSURLRequest *)createRequest{
    NSString *baseURL = @"http://androsafe.net/test/iPhone";
    switch (requestType) {
        case HTTPRequestTypeBDApp:
            baseURL = [baseURL stringByAppendingPathComponent:@"iPhoneTestInsurt.php"];
            break;
        case HTTPRequestTypeNone:
            NSLog(@"Request Type cannot be none");
            baseURL = nil;
            break;
    }
    NSURL *url = [NSURL URLWithString:baseURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:0 timeoutInterval:60];
    
    [request setHTTPMethod:@"POST"];
    
    NSMutableString *bodyDataString = [NSMutableString string];
    
    //... gather all arguments
    NSArray *allKeys = [params allKeys];
    for (NSString *key in allKeys) {
        id value = [params objectForKey:key];
        [bodyDataString appendFormat:@"%@=%@&",key,value];
    }
    
    
    NSData *bodyData = [bodyDataString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:bodyData];
    
    //NSString *deviceID = [openUDID value];
    //[request addValue:deviceID forHTTPHeaderField:@"deviceID"];
    
    return request;
    
}

- (void)startSync:(BOOL)Sync{
    [self startSync:Sync block:NULL];
}

- (void)startSync:(BOOL)Sync block:(HTTPRequestBlock)block{
    NSURLRequest *request = [self createRequest];
    
    if (block != NULL) {
    self.requestBlock = Block_copy((__bridge void *)block);
    }
    if (Sync) {
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        [self handleData:data error:error];
    }else{
        NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:NO];
        [connection start];
    }
}


- (void) handleData:(NSData *)data error:(NSError *)error{
    id resultData = nil;
    if (error == nil) {
        resultData = [data jsonValueWithError:&error];
    }
    HTTPResult *result = [[HTTPResult alloc]init];
    result.data = resultData;
    result.error = error;
    
    self.requestResult = result;
    //respond to delegate
    if ([requestDelegate respondsToSelector:@selector(request:finishedWithResult:)]) {
        [requestDelegate request:self finishedWithResult:result];
    }
    //respond to block
    if (requestBlock != NULL) {
        //cast from void* to HTTPRequestBlock
        HTTPRequestBlock block = (__bridge HTTPRequestBlock)requestBlock;
        block(result);
        Block_release(requestBlock);
        self.requestBlock = NULL;
    }
}

#pragma mark - NSURLConnection Data Delegate Methods
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self handleData:nil error:error];
    self.mutableData = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if (mutableData == nil) {
        self.mutableData = [NSMutableData new];
    }
    [mutableData appendData:data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [self handleData:mutableData error:nil];
    self.mutableData = nil;
}


#pragma mark - Arguments Methods

- (void) addInteger:(NSInteger)val forKey:(NSString *)key{
    
    [self addValue:[NSNumber numberWithInteger:val] forKey:key];
}

- (void) addBool:(BOOL)val forKey:(NSString *)key{
    [self addValue:[NSNumber numberWithBool:val] forKey:key];
}

- (void) addDouble:(double)val forKey:(NSString *)key{
    [self addValue:[NSNumber numberWithDouble:val] forKey:key];
    
}

- (void) addDate:(NSDate *)val forKey:(NSString *)key{
    
    //sample of timestamp with miliseconds
    NSTimeInterval timeInterval = [val timeIntervalSince1970];
    NSString *str = [NSString stringWithFormat:@"%.3f",timeInterval];
    str = [str stringByReplacingOccurrencesOfString:@"." withString:@""];
    [self addString:str forKey:key];
}

- (void) addString:(NSString *)val forKey:(NSString *)key{
    //optional: escaped the val
    [self addValue:val forKey:key];
}

- (void) addValue:(id)val forKey:(NSString*)key{
    if (val != nil) {
        [params setObject:val forKey:key];
    }else{
        NSLog(@"WARNING:!!!!!\n\nAttemp to insert nil for %@",key);
    }
}

@end


@implementation HTTPResult
@end
