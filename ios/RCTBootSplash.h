//
//  RCTBootSplash.h
//  Header file for RCTBootSplash
//

#import <React/RCTBridgeModule.h>
#import <UIKit/UIKit.h>

@interface RCTBootSplash : NSObject <RCTBridgeModule>

+ (void)initWithStoryboard:(NSString * _Nonnull)storyboardName
                  rootView:(UIView * _Nullable)rootView;

+ (void)hideWithFade:(BOOL)fade;

@end
