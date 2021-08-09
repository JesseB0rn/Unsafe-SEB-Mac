//
//  SEBWebViewController.h
//  Safe Exam Browser
//
//  Created by Daniel Schneider on 02.07.21.
//

#import <Foundation/Foundation.h>
#import "SEBAbstractWebView.h"
#import "SEBWebView.h"
#import <WebKit/WebKit.h>

#import "SEBBrowserWindowController.h"
#import "SEBWebView.h"
#import "SEBEncryptedUserDefaultsController.h"
#import "SEBOSXBrowserController.h"
#import "SEBTextField.h"

@class SEBAbstractClassicWebView;
@class SEBWebView;
@class SEBURLFilter;

NS_ASSUME_NONNULL_BEGIN

@interface SEBWebViewController : NSViewController <SEBAbstractBrowserControllerDelegate, SEBAbstractWebViewNavigationDelegate, WebUIDelegate, WebPolicyDelegate, WebFrameLoadDelegate, WebResourceLoadDelegate, NSURLDownloadDelegate> {
    
    @private
    SEBURLFilter *urlFilter;
    NSString *quitURLTrimmed;
    BOOL sendBrowserExamKey;
}

@property (weak, nonatomic) id<SEBAbstractWebViewNavigationDelegate> navigationDelegate;

//@property (weak) SEBBrowserTabViewController *browserTabViewController;
@property (strong, nonatomic) SEBWebView *sebWebView;
@property (strong, nonatomic) NSString *currentWebViewMainHost;
@property (strong, nonatomic) NSURLAuthenticationChallenge * _Nullable pendingChallenge;
@property (strong, nonatomic) NSString * _Nullable downloadFilename;
@property (strong, nonatomic) NSString * _Nullable downloadFileExtension;

@property (readwrite) BOOL allowDownloads;
@property (readwrite) BOOL allowDeveloperConsole;

- (instancetype)initNewTabWithCommonHost:(BOOL)commonHostTab overrideSpellCheck:(BOOL)overrideSpellCheck;

@end

NS_ASSUME_NONNULL_END
