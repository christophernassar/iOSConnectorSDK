//
//  LoadingView.m
//  ConnectorSDK
//
//  Created by Christopher Nassar on 11/27/15.
//  Copyright © 2015 Christopher Nassar. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView()
@property(nonatomic) UIActivityIndicatorView* loadingIndicator;
@property(nonatomic) UILabel* loadingMessage;
@property(nonatomic) UIImageView* loadingImage;
@end

@implementation LoadingView

-(id)initWithFrame:(CGRect)frame showIndicator:(BOOL)showIndicator withMessage:(NSString*)message withImageData:(NSData*)imageData withImageURL:(NSString*)imageUrl{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        
        if(showIndicator){
            _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            
            [_loadingIndicator setCenter:CGPointMake(frame.size.width/2, frame.size.height/2)];
            [_loadingIndicator startAnimating];
            [self addSubview:_loadingIndicator];
        }
        
        if(message.length > 0){
            _loadingMessage = [[UILabel alloc] initWithFrame:CGRectMake(0, _loadingIndicator.center.y+_loadingIndicator.frame.size.height, frame.size.width, 20)];
            
            [_loadingMessage setText:message];
            [_loadingMessage setTextAlignment:NSTextAlignmentCenter];
            [_loadingMessage setTextColor:[UIColor whiteColor]];
            [_loadingMessage setFont:[UIFont boldSystemFontOfSize:30]];
            [self addSubview:_loadingMessage];
        }
        
        if(imageData.length > 0){
            _loadingImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            [_loadingImage setImage:[UIImage imageWithData:imageData]];
            [self addSubview:_loadingImage];
            [self sendSubviewToBack:_loadingImage];
        }
        
        if(imageUrl.length > 0){
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
