//
//  LoadingView.m
//  ConnectorSDK
//
//  Created by Christopher Nassar on 11/27/15.
//  Copyright © 2015 Christopher Nassar. All rights reserved.
//

#import "LoadingView.h"
#import "globalVaribales.h"

@interface LoadingView()
@property(nonatomic) UIActivityIndicatorView* loadingIndicator;
@property(nonatomic) UILabel* loadingMessage;
@property(nonatomic) UIImageView* loadingImage;
@end

@implementation LoadingView

-(void)UpdateUI:(NSDictionary*)uimap{
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.backgroundColor = [uimap objectForKey:LOADING_BACKGROUND_COL];
        [_loadingIndicator setBackgroundColor:[uimap objectForKey:LOADING_INDICATOR_COL]];
        [_loadingMessage setTextColor:[uimap objectForKey:LOADING_MESSAGE_COL]];
        [_loadingMessage setFont:[uimap objectForKey:LOADING_MESSAGE_FNT]];

    }];
}

-(id)initWithFrame:(CGRect)frame withUIMap:(NSDictionary*)uimap{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [uimap objectForKey:LOADING_BACKGROUND_COL];
        
        BOOL showIndicator = [[uimap objectForKey:LOADING_SHOW_INDICATOR] boolValue];
        BOOL showMessage = [[uimap objectForKey:LOADING_SHOW_MESSAGE] boolValue];
        BOOL showImageData = [[uimap objectForKey:LOADING_SHOW_IMAGE_DATA] boolValue];
        BOOL showImageURL = [[uimap objectForKey:LOADING_SHOW_IMAGE_URL] boolValue];
        
        NSString* messageTxt = [uimap objectForKey:LOADING_MESSAGE_TXT];
        NSData* imageData = [uimap objectForKey:LOADING_IMAGE_DATA];
        NSString* imageUrl = [uimap objectForKey:LOADING_IMAGE_URL];
        
        if(showIndicator){
            _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            
            [_loadingIndicator setColor:[uimap objectForKey:LOADING_INDICATOR_COL]];
            [_loadingIndicator setCenter:CGPointMake(frame.size.width/2, frame.size.height/2)];
            [_loadingIndicator startAnimating];
            [self addSubview:_loadingIndicator];
        }
        
        if(showMessage && messageTxt.length>0){
            _loadingMessage = [[UILabel alloc] initWithFrame:CGRectMake(0, _loadingIndicator.center.y+_loadingIndicator.frame.size.height, frame.size.width, 20)];
            
            [_loadingMessage setText:messageTxt];
            [_loadingMessage setTextAlignment:NSTextAlignmentCenter];
            [_loadingMessage setTextColor:[uimap objectForKey:LOADING_MESSAGE_COL]];
            [_loadingMessage setFont:[uimap objectForKey:LOADING_MESSAGE_FNT]];
            [self addSubview:_loadingMessage];
        }
        
        if(showImageData && imageData.length > 0){
            _loadingImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            [_loadingImage setImage:[UIImage imageWithData:imageData]];
            [self addSubview:_loadingImage];
            [self sendSubviewToBack:_loadingImage];
        }
        
        if(showImageURL && imageUrl.length > 0){
            [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
                NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                if(data.length > 0){
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        
                        if(!_loadingImage){
                             _loadingImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
                        }
                        
                        [_loadingImage setImage:[UIImage imageWithData:data]];
                    }];
                }
            }];
        }
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
