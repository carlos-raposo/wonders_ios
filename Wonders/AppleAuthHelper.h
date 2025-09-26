#import <Foundation/Foundation.h>
#import <FirebaseAuth/FirebaseAuth.h>

@interface AppleAuthHelper : NSObject
+ (FIRAuthCredential *)credentialWithProviderID:(NSString *)providerID idToken:(NSString *)idToken accessToken:(NSString *)accessToken;
@end
