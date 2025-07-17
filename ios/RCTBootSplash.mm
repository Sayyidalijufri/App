//
//  RCTBootSplash.mm
//  Fixed version addressing iOS splash screen color shift
//

#import "RCTBootSplash.h"
#import <React/RCTUtils.h>

static UIView *_rootView = nil;
static bool _nativeHidden = false;
static bool _darkModeEnabled = false;

@implementation RCTBootSplash

RCT_EXPORT_MODULE();

+ (BOOL)requiresMainQueueSetup {
  return YES;
}

+ (void)initWithStoryboard:(NSString * _Nonnull)storyboardName
                  rootView:(UIView * _Nullable)rootView {
  if (rootView == nil || _rootView != nil)
    return;

  _rootView = rootView;

  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                   name:UIApplicationDidBecomeActiveNotification
                                                 object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(onJavaScriptDidLoad)
                                                name:RCTJavaScriptDidLoadNotification
                                              object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(onJavaScriptDidFailToLoad)
                                                name:RCTJavaScriptDidFailToLoadNotification
                                              object:nil];

  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
  UIView *loadingView = [[storyboard instantiateInitialViewController] view];

  [_rootView addSubview:loadingView];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(onUIApplicationDidBecomeActiveNotification)
                                                name:UIApplicationDidBecomeActiveNotification
                                              object:nil];

  [RCTBootSplash hideWithFade:false];
}

+ (void)onUIApplicationDidBecomeActiveNotification {
  [RCTBootSplash hideWithFade:false];
}

+ (void)onJavaScriptDidLoad {
  [RCTBootSplash hideWithFade:false];
}

+ (void)onJavaScriptDidFailToLoad {
  [RCTBootSplash hideWithFade:false];
}

+ (void)hideWithFade:(BOOL)fade {
  if (_nativeHidden || _rootView == nil || [_rootView subviews].count == 0)
    return;

  UIView *loadingView = [[_rootView subviews] objectAtIndex:0];

  if (fade) {
    // FIXED: Use no-transition animation with reduced duration to prevent color blending
    [UIView transitionWithView:_rootView
                      duration:0.1  // Reduced from 0.25s to 0.1s
                       options:UIViewAnimationOptionTransitionNone  // Changed from CrossDissolve to None
                    animations:^{
                      [loadingView removeFromSuperview];
                    }
                    completion:^(BOOL finished) {
                      _nativeHidden = true;
                    }];
  } else {
    [loadingView removeFromSuperview];
    _nativeHidden = true;
  }
}

RCT_EXPORT_METHOD(hide:(NSDictionary * _Nullable)options
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
  
  // FIXED: Reduced initial delay from 0.35s to 0.1s
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    BOOL fade = [RCTConvert BOOL:options[@"fade"]];
    [RCTBootSplash hideWithFade:fade];
    resolve(@(true));
  });
}

RCT_EXPORT_METHOD(getVisibilityStatus:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
  resolve(_nativeHidden ? @"hidden" : @"visible");
}

@end
