//
//  ViewController.m
//  HTTPRequestProject
//
//  Created by Asaf Fisher on 5/21/14.
//  Copyright (c) 2014 Asaf Fisher. All rights reserved.
//

#import "ViewController.h"
#import "HTTPRequest.h"
#define kWebSiteURL @"http://androsafe.net"
@interface ViewController ()//<HTTPRequestDelegate>
@property (nonatomic,strong) NSMutableData *mutableData;
@end

@implementation ViewController
@synthesize myWebView, mutableData;
- (IBAction)sendRequestAction:(id)sender {
    [self.nameTextField resignFirstResponder];
    [self.secretTextField resignFirstResponder];
    HTTPRequest *req = [[HTTPRequest alloc]initWithReqestType:HTTPRequestTypeBDApp];
    [req addString:_nameTextField.text forKey:@"name"];
    [req addString:_secretTextField.text forKey:@"lastname"];
    [req startSync:NO block:^(HTTPResult *result) {
        NSLog(@"%@", result.data);
        self.lable.text = [result.data valueForKeyPath:@"Message"];
        //[self.lable.text ape
        
         }];
}



- (IBAction)loadWebPageAction:(id)sender {
//    NSURL *url = [NSURL URLWithString:kWebSiteURL];
//    NSURLRequest *request =[NSURLRequest requestWithURL:url];
//    [myWebView loadRequest:request];
#pragma mark - HTTPRequest
    NSURL *url = [NSURL URLWithString:kWebSiteURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
   // [self sendSyncRequest:request];
    [self SendAsyncRequest:request];
   }

-(void) SendAsyncRequest:(NSURLRequest *)request
{
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:NO];
    [connection start];
}
- (void)sendSyncRequest:(NSURLRequest *)request
{
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSString *title = [NSString stringWithFormat:@"Error Code %d", error.code];
        [[[UIAlertView alloc]initWithTitle:title message:error.localizedDescription delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] show];
    }else{
        NSLog(@"%@",data);
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        [myWebView loadHTMLString:str baseURL:nil];
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Welcome" ofType:@"html"];
    NSString *htmlString = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [myWebView loadHTMLString:htmlString baseURL:nil];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -NSURLConnection Data Delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (mutableData == nil) {
        self.mutableData = [NSMutableData data];
    }
    [mutableData appendData:data];
        NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.mutableData = nil;
    NSString *title = [NSString stringWithFormat:@"Error Code %d", error.code];
    [[[UIAlertView alloc]initWithTitle:title message:error.localizedDescription delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] show];
        NSLog(@"%@",NSStringFromSelector(_cmd));
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
        NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //...parse the Data
    NSLog(@"%@",NSStringFromSelector(_cmd));
    NSString *htmlString = [[NSString alloc]initWithData:mutableData encoding:NSUTF8StringEncoding];
    [myWebView loadHTMLString:htmlString baseURL:nil];
    self.mutableData = nil;

}

#pragma mark - HTTPRequest Delegate
//-(void)request:(HTTPRequest *)request finishedWithResult:(HTTPResult *)result{
//    NSLog(@"%@", result.data);
//}

@end
