//
//  ViewController.h
//  HTTPRequestProject
//
//  Created by Asaf Fisher on 5/21/14.
//  Copyright (c) 2014 Asaf Fisher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSURLConnectionDataDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *secretTextField;
@property (weak, nonatomic) IBOutlet UILabel *lable;

@property (weak, nonatomic) IBOutlet UIWebView *myWebView;

@end
