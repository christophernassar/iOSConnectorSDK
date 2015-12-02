//
//  Connector.m
//  Contact Book
//
//  Created by Chris Nassar on 9/25/15.
//  Copyright (c) 2015 Christopher Nassar. All rights reserved.
//

#import "Connector.h"
#import "LoadingView.h"

static NSDictionary* urlMap;
static NSMutableDictionary* errorLogs;
static LoadingView* loadingView;
static UIViewController* currentContainer;
static BOOL showLoadingView = true;

@implementation ConnectorLog
@synthesize error,reason,date;

-(id)initWithErrorDescription:(NSString*)description reason:(NSString*)r date:(NSDate*)d{
    self = [super init];
    if(self){
        self.error = description;
        self.reason = r;
        self.date = d;
        
        NSLog(@"Error: %@,Reason: %@",error,reason);
    }
    
    return self;
}
@end

@interface Connector()
@property (nonatomic,assign)  id <ConnectorDelegate> delegate;
@property (nonatomic,assign)  NSString* requestName;
@property (nonatomic,assign)  REQUEST_TYPE requesType;
@property (nonatomic,assign)  UIViewController* container;
@end

@import Foundation;
@implementation Connector

+(void)EnableLoadingView:(BOOL)enableLoadingView{
    showLoadingView = enableLoadingView;
}

+(void)ConfigureLoadingWithIndicator:(BOOL)withIndicator withMessage:(NSString*)message withImageData:(NSData*)imageData withImageURL:(NSString*)url inContainer:(UIViewController*)container{
    
    if(!showLoadingView){
        return;
    }
    if(loadingView && loadingView.superview){
        [loadingView removeFromSuperview];
    }
    
    currentContainer = container;
    
    if(currentContainer){
        loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, currentContainer.view.frame.size.width, currentContainer.view.frame.size.height) showIndicator:withIndicator withMessage:message withImageData:imageData withImageURL:url];
    }
}

+(void)SetURLMapDictionary:(NSDictionary*)urlM{
    urlMap = urlM;
}

-(NSMutableDictionary*)errorLogs{
    if(errorLogs == nil){
        errorLogs = [[NSMutableDictionary alloc] init];
    }
    
    return errorLogs;
}

-(id)initWithRequestName:(NSString*)requestName requestType:(REQUEST_TYPE)requestType andDelegate:(id<ConnectorDelegate>)delegate showLoading:(BOOL)ShowLoading{
    self = [super self];
    
    showLoadingView = ShowLoading;
    [Connector ConfigureLoadingWithIndicator:true withMessage:@"test" withImageData:nil withImageURL:nil inContainer:(UIViewController*)delegate];
    
    
    if(self){
        self.delegate = delegate;
        self.requestName = requestName;
        self.requesType = requestType;
    }
    [self StartAsynchronousRequest];
    return self;
}

-(void)StartAsynchronousRequest{
    
    if(urlMap == nil){
        ConnectorLog* log = [[ConnectorLog alloc] initWithErrorDescription:@"Cannot Start Asynchronous" reason:@"urlMap is nil value" date:[NSDate new]];
        
        [self.errorLogs setObject:log forKey:[NSNumber numberWithLong:self.errorLogs.count]];
        return;
    }
    
    if(urlMap.count == 0){
        ConnectorLog* log = [[ConnectorLog alloc] initWithErrorDescription:@"Cannot Start Asynchronous" reason:@"urlMap has 0 value" date:[NSDate new]];
        
        [self.errorLogs setObject:log forKey:[NSNumber numberWithLong:self.errorLogs.count]];
        return;
    }
    
    NSString* urlStr = [urlMap objectForKey:_requestName];
    if(urlStr.length == 0){
        ConnectorLog* log = [[ConnectorLog alloc] initWithErrorDescription:@"Cannot Start Asynchronous" reason:@"No url for this request found" date:[NSDate new]];
        
        [self.errorLogs setObject:log forKey:[NSNumber numberWithLong:self.errorLogs.count]];
        return;

    }
    
    if(loadingView && currentContainer){
        [currentContainer.view addSubview:loadingView];
    }
    
    NSURL* requestedURL = [NSURL URLWithString:urlStr];
    NSURLRequest* request = [NSURLRequest requestWithURL:requestedURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    
    NSURLSession* session = [NSURLSession sharedSession];

    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if(loadingView){
                [loadingView removeFromSuperview];
            }
        }];
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
        if([httpResponse statusCode] != STANDARD_HTTP_RESPONSE_CODE){
            NSLog(@"Network Connection Error %@", error.description);
            //Add Fail
            ConnectorLog* log = [[ConnectorLog alloc] initWithErrorDescription:@"Network Connection Error" reason:[NSString stringWithFormat:@"Status code %ld",(long)[httpResponse statusCode]] date:[NSDate new]];
            
            [self.errorLogs setObject:log forKey:[NSNumber numberWithLong:self.errorLogs.count]];
            [self.delegate RequestCompleteWithError:error];
            return;
        }
        else if(error != nil){
            NSLog(@"Service Connection Error %@", error.description);
            ConnectorLog* log = [[ConnectorLog alloc] initWithErrorDescription:@"Service Connection Error" reason:error.description date:[NSDate new]];
            
            [self.errorLogs setObject:log forKey:[NSNumber numberWithLong:self.errorLogs.count]];
            [self.delegate RequestCompleteWithError:error];
            return;
        }
        else if(data.length > 0){
            [self ParseResponse:data];
        } else{
            NSLog(@"Empty response");
        }

    }];
    
    [task resume];
}

-(void)ParseResponse:(NSData*)data{
    
    switch (_requesType) {
        case JSON:{
            NSError *jsonError;
            id jsonResult = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableContainers
                                                              error:&jsonError];
            
            if(jsonError != nil){
                [self.delegate RequestCompleteWithError:jsonError];
            } else {
                
                NSDictionary* resultDic = [[NSDictionary alloc] initWithObjects:@[jsonResult,_requestName] forKeys:@[@"result",@"requestName"]];
                
                [self.delegate RequestCompleteWithSuccess:resultDic];
            }
        }
        break;
            
        case CUSTOM:
        case IMAGE:{
            NSDictionary* resultDic = [[NSDictionary alloc] initWithObjects:@[data,_requestName] forKeys:@[@"result",@"requestName"]];
            [self.delegate RequestCompleteWithSuccess:resultDic];
        }
        break;
            
        default:
        break;
    }
    
}
@end
