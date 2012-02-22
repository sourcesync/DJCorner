//
//  LocalizedManager.h
//  djc
//
//  Created by Zix Engineer on 21/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KLMDefaultLanguage @"en"
#define KLMEnglish @"en"
#define KLMSpanish @"es"
#define KLMChinese @"zh-Hans"

#define KLMSelectedLanguageKey @"KLMSelectedLanguageKey"

@interface LocalizedManager : NSObject

+(BOOL) isSupportedLanguage:(NSString *) language;
+(NSString *) localizedString:(NSString *) key;
+(void) setSelectedLanguage:(NSString *) language;
+(NSString *) selectedLanguage;

@end
