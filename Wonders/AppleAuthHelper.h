#import <Foundation/Foundation.h>
#import <FirebaseAuth/FirebaseAuth.h>

@interface AppleAuthHelper : NSObject
+ (FIRAuthCredential * _Nonnull)credentialWithProviderID:(NSString * _Nonnull)providerID
                                                 idToken:(NSString * _Nonnull)idToken
                                                rawNonce:(NSString * _Nonnull)rawNonce
                                            accessToken:(NSString * _Nonnull)accessToken;
@end
