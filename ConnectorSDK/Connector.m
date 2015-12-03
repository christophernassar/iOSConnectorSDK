//
//  Connector.m
//  Contact Book
//
//  Created by Chris Nassar on 9/25/15.
//  Copyright (c) 2015 Christopher Nassar. All rights reserved.
//

#import "Connector.h"
#import "globalVaribales.h"
#import "LoadingView.h"

static NSDictionary* urlMap;
static NSMutableDictionary* uiMap;
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

//Default UI settings
+(NSDictionary*)uiMap{
    if(uiMap == nil){
        uiMap = [[NSMutableDictionary alloc] init];
        [uiMap setObject:[UIColor whiteColor] forKey:LOADING_INDICATOR_COL] ;
        [uiMap setObject:[UIColor colorWithWhite:0.5 alpha:0.5] forKey:LOADING_BACKGROUND_COL];
        [uiMap setObject:[UIColor whiteColor] forKey:LOADING_MESSAGE_COL];
        [uiMap setObject:[UIFont boldSystemFontOfSize:30] forKey:LOADING_MESSAGE_FNT];
        [uiMap setObject:@"Loading ..." forKey:LOADING_MESSAGE_TXT];
        [uiMap setObject:[NSNumber numberWithBool:TRUE] forKey:LOADING_SHOW_INDICATOR];
        [uiMap setObject:[NSNumber numberWithBool:TRUE] forKey:LOADING_SHOW_MESSAGE];
        [uiMap setObject:[NSNumber numberWithBool:FALSE] forKey:LOADING_SHOW_IMAGE_URL];
        [uiMap setObject:[NSNumber numberWithBool:FALSE] forKey:LOADING_SHOW_IMAGE_DATA];
    }
    
    return uiMap;
}

+(void)PrintUIMap{
    if([Connector uiMap] == nil){
         NSLog(@"UI MAP NOT INITIALIZED");
        return;
    }
    NSLog(@"UI_MAP:");
    
    NSLog(@"INDICATOR_SHOW: %@",[uiMap objectForKey:LOADING_SHOW_INDICATOR]);
    NSLog(@"INDICATOR_COLOR: %@",[uiMap objectForKey:LOADING_INDICATOR_COL]);
    
    NSLog(@"BACKGROUND_COLOR: %@",[uiMap objectForKey:LOADING_BACKGROUND_COL]);
    
    NSLog(@"MESSAGE_SHOW: %@",[uiMap objectForKey:LOADING_SHOW_MESSAGE]);
    NSLog(@"MESSAGE_COLOR: %@",[uiMap objectForKey:LOADING_MESSAGE_COL]);
    NSLog(@"MESSAGE_FONT: %@",[uiMap objectForKey:LOADING_MESSAGE_FNT]);
    NSLog(@"MESSAGE_TXT: %@",[uiMap objectForKey:LOADING_MESSAGE_FNT]);
    
    NSLog(@"IMAGE_DATA_SHOW: %@",[uiMap objectForKey:LOADING_SHOW_IMAGE_DATA]);
    NSLog(@"IMAGE_DATA: %@",[uiMap objectForKey:LOADING_IMAGE_DATA]);
    
    NSLog(@"IMAGE_URL_SHOW: %@",[uiMap objectForKey:LOADING_SHOW_IMAGE_URL]);
    NSLog(@"IMAGE_URL: %@",[uiMap objectForKey:LOADING_IMAGE_URL]);
}

+(void)LogFailure:(Class) expected withActual:(Class) actual{
      NSLog(@"Type Incorrect, expected %@ actual %@",NSStringFromClass(expected),NSStringFromClass(actual));
}

+(void)SetUIMapObject:(UI_TYPE)uiType withObject:(id)object{
    
    if([Connector uiMap]){
        switch (uiType) {
            case BACKGROUND_COLOR:
                if([object isKindOfClass:[UIColor class]]){
                    [uiMap setObject:object forKey:LOADING_BACKGROUND_COL];
                }else{
                    [self LogFailure:[UIColor class] withActual:[object class]];
                }
                break;
            case INDICATOR_COLOR:
                if([object isKindOfClass:[UIColor class]]){
                    [uiMap setObject:object forKey:LOADING_INDICATOR_COL];
                }else{
                    [self LogFailure:[UIColor class] withActual:[object class]];
                }
                break;
            case MESSAGE_FONT:
                if([object isKindOfClass:[UIFont class]]){
                    [uiMap setObject:object forKey:LOADING_MESSAGE_FNT];
                }else{
                    [self LogFailure:[UIFont class] withActual:[object class]];
                }
                break;
            case MESSAGE_TEXT:
                if([object isKindOfClass:[NSString class]]){
                    [uiMap setObject:object forKey:LOADING_MESSAGE_TXT];
                }else{
                    [self LogFailure:[UIFont class] withActual:[object class]];
                }
                break;
            case MESSAGE_COLOR:
                if([object isKindOfClass:[UIColor class]]){
                    [uiMap setObject:object forKey:LOADING_MESSAGE_COL];
                }else{
                    [self LogFailure:[UIColor class] withActual:[object class]];
                }
                break;
            case SHOW_INDICATOR:
                if([object isKindOfClass:[NSNumber class]]){
                    [uiMap setObject:object forKey:LOADING_SHOW_INDICATOR];
                }else{
                    [self LogFailure:[NSNumber class] withActual:[object class]];
                }
                break;
            case SHOW_MESSAGE:
                if([object isKindOfClass:[NSNumber class]]){
                    [uiMap setObject:object forKey:LOADING_SHOW_MESSAGE];
                }else{
                    [self LogFailure:[NSNumber class] withActual:[object class]];
                }
                break;
            case SHOW_IMAGE_DATA:
                if([object isKindOfClass:[NSNumber class]]){
                    [uiMap setObject:object forKey:LOADING_SHOW_IMAGE_DATA];
                }else{
                    [self LogFailure:[NSNumber class] withActual:[object class]];
                }
                break;
            case SHOW_IMAGE_URL:
                if([object isKindOfClass:[NSNumber class]]){
                    [uiMap setObject:object forKey:LOADING_SHOW_IMAGE_URL];
                }else{
                    [self LogFailure:[NSNumber class] withActual:[object class]];
                }
                break;
            case IMAGE_DATA:
                if([object isKindOfClass:[NSData class]]){
                    [uiMap setObject:object forKey:LOADING_IMAGE_DATA];
                }else{
                    [self LogFailure:[NSData class] withActual:[object class]];
                }
                break;
            case IMAGE_URL:
                if([object isKindOfClass:[NSString class]]){
                    [uiMap setObject:object forKey:LOADING_IMAGE_URL];
                }else{
                    [self LogFailure:[NSString class] withActual:[object class]];
                }
                break;
        }
        [loadingView UpdateUI:uiMap];
    }
}

+(NSDictionary*)GetURLMapDictionary{
    return urlMap;
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
    currentContainer = (UIViewController*)delegate;
    
    if(loadingView && loadingView.superview){
        [loadingView removeFromSuperview];
    }
    
    loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, currentContainer.view.frame.size.width, currentContainer.view.frame.size.height) withUIMap:uiMap];
    
    
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
    
    if(showLoadingView && loadingView && currentContainer){
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
