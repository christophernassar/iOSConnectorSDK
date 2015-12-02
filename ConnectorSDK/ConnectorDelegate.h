//
//  ConnectorDelegate.h
//  Contact Book
//
//  Created by Chris Nassar on 9/25/15.
//  Copyright (c) 2015 Christopher Nassar. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol ConnectorDelegate
- (void) RequestCompleteWithSuccess:(id)data;
- (void) RequestCompleteWithError:(NSError*)error;
@end

@interface ConnectorDelegate : NSObject<ConnectorDelegate>

@end
