#import "AppleAuthHelper.h"
#import <FirebaseAuth/FirebaseAuth.h>

@implementation AppleAuthHelper
+ (FIRAuthCredential *)credentialWithProviderID:(NSString *)providerID idToken:(NSString *)idToken accessToken:(NSString *)accessToken {
    // Not implemented: Apple Sign-In is not supported via Objective-C in current FirebaseAuth versions.
    return nil;
}
@end
