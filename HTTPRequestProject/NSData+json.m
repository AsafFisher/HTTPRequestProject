//
//  NSData+json.m
//  HTTPRequestProject
//
//  Created by Asaf Fisher on 5/25/14.
//  Copyright (c) 2014 Asaf Fisher. All rights reserved.
//

#import "NSData+json.h"

@implementation NSData (json)

- (id)jsonValueWithError:(NSError **)error{
    return [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingAllowFragments error:error];
}

@end
