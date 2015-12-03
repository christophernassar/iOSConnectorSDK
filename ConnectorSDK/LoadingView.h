//
//  LoadingView.h
//  ConnectorSDK
//
//  Created by Christopher Nassar on 11/27/15.
//  Copyright © 2015 Christopher Nassar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

-(void)UpdateUI:(NSDictionary*)uimap;
-(id)initWithFrame:(CGRect)frame withUIMap:(NSDictionary*)uimap;
@end
