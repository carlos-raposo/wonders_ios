#import "AppleAuthHelper.h"
@import FirebaseAuth;

@implementation AppleAuthHelper
+ (FIRAuthCredential *)credentialWithProviderID:(NSString *)providerID
                                        idToken:(NSString *)idToken
                                       rawNonce:(NSString *)rawNonce
                                   accessToken:(NSString *)accessToken {
    return [FIROAuthProvider credentialWithProviderID:providerID
                                              IDToken:idToken
                                             rawNonce:rawNonce
                                          accessToken:accessToken];
}
@end
