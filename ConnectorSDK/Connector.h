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


//Request Type Response handler enum
typedef enum {JSON,XML,IMAGE,CUSTOM} REQUEST_TYPE;
//UI Type Response handler enum
typedef enum {INDICATOR_COLOR,BACKGROUND_COLOR,MESSAGE_COLOR,MESSAGE_TEXT,MESSAGE_FONT,SHOW_MESSAGE,SHOW_INDICATOR,SHOW_IMAGE_DATA,SHOW_IMAGE_URL,IMAGE_DATA,IMAGE_URL} UI_TYPE;

//Logging class
@interface ConnectorLog : NSObject
@property(nonatomic) NSString* error;
@property(nonatomic) NSString* reason;
@property(nonatomic) NSDate* date;
-(id)initWithErrorDescription:(NSString*)description reason:(NSString*)r date:(NSDate*)d;
@end

@interface Connector : NSObject

//UI Getter/Setter
+(void)SetUIMapObject:(UI_TYPE)uiType withObject:(id)object;
+(void)PrintUIMap;

//URL map Getter/Setter
+(NSDictionary*)GetURLMapDictionary;
+(void)SetURLMapDictionary:(NSDictionary*)urlM;

//Custom constructor
-(id)initWithRequestName:(NSString*)requestName requestType:(REQUEST_TYPE)requestType andDelegate:(id<ConnectorDelegate>)delegate showLoading:(BOOL)ShowLoading;
+(void)EnableLoadingView:(BOOL)enableLoadingView;
@end
