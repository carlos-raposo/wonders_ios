#import "AppleAuthHelper.h"
#import <FirebaseAuth/FirebaseAuth.h>

@implementation AppleAuthHelper
+ (FIRAuthCredential *)credentialWithProviderID:(NSString *)providerID idToken:(NSString *)idToken accessToken:(NSString *)accessToken {
    return [FIROAuthProvider credentialWithProviderID:providerID IDToken:idToken accessToken:accessToken];
}
@end
