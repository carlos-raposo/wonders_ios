#import "AppleAuthHelper.h"
#import <FirebaseAuth/FirebaseAuth.h>

@implementation AppleAuthHelper
+ (FIRAuthCredential *)credentialWithProviderID:(NSString *)providerID idToken:(NSString *)idToken accessToken:(NSString *)accessToken {
    // Google Sign-In pode funcionar se o header estiver disponível, mas o recomendado é usar Swift.
    // Apple Sign-In NÃO é suportado via Objective-C nas versões atuais do FirebaseAuth.
    // Recomenda-se migrar todo o fluxo de autenticação para Swift.
    return nil;
}
@end
