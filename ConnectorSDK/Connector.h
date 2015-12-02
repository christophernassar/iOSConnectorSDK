//
//  Connector.h
//  Contact Book
//
//  Created by Chris Nassar on 9/25/15.
//  Copyright (c) 2015 Christopher Nassar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ConnectorDelegate.h"
#define STANDARD_HTTP_RESPONSE_CODE 200

typedef enum {JSON,XML,IMAGE,CUSTOM} REQUEST_TYPE;


@interface ConnectorLog : NSObject
@property(nonatomic) NSString* error;
@property(nonatomic) NSString* reason;
@property(nonatomic) NSDate* date;
-(id)initWithErrorDescription:(NSString*)description reason:(NSString*)r date:(NSDate*)d;
@end

@interface Connector : NSObject
+(void)SetURLMapDictionary:(NSDictionary*)urlM;
+(void)ConfigureLoadingWithIndicator:(BOOL)withIndicator withMessage:(NSString*)message withImageData:(NSData*)imageData withImageURL:(NSString*)url inContainer:(UIViewController*)container;
-(id)initWithRequestName:(NSString*)requestName requestType:(REQUEST_TYPE)requestType andDelegate:(id<ConnectorDelegate>)delegate showLoading:(BOOL)ShowLoading;
@end
