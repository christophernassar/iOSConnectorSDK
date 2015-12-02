//
//  LoadingView.h
//  ConnectorSDK
//
//  Created by Christopher Nassar on 11/27/15.
//  Copyright © 2015 Christopher Nassar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView
-(id)initWithFrame:(CGRect)frame showIndicator:(BOOL)showIndicator withMessage:(NSString*)message withImageData:(NSData*)imageData withImageURL:(NSString*)imageUrl;
@end
