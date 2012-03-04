//
//  LocalizedManager.m
//  djc
//
//  Created by Zix Engineer on 21/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocalizedManager.h"



@implementation LocalizedManager

+(BOOL)isSupportedLanguage:(NSString *)language
{
    if([language isEqualToString:KLMChinese])
        return YES;
    if([language isEqualToString:KLMEnglish])
        return YES;
    if([language isEqualToString:KLMSpanish])
        return YES;
    return NO;
}

+(NSString *)localizedString:(NSString *)key
{
    NSString *selectedLanguage=[LocalizedManager selectedLanguage];
    
    NSString *path=[[NSBundle mainBundle] pathForResource:selectedLanguage ofType:@"lproj"];
    
    NSBundle *bundle=[NSBundle bundleWithPath:path];
    NSString *str=[bundle localizedStringForKey:key value:@"" table:nil];
    return str;
}

+(void) setSelectedLanguage:(NSString *)language
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    if([self isSupportedLanguage:language])
    {
        [userDefaults setObject:language forKey:KLMSelectedLanguageKey];
    }
    
    else
    {
        [userDefaults setObject:nil forKey:KLMSelectedLanguageKey];
    }
}

+(NSString *) selectedLanguage
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString * selectedLanguage=[userDefaults stringForKey:KLMSelectedLanguageKey];
    
    if(selectedLanguage==nil)
    {
        NSArray *userLangs=[userDefaults objectForKey:@"AppleLanguages"];
        NSString *systemlanguage=[userLangs objectAtIndex:0];
        
        if([self isSupportedLanguage:systemlanguage])
        {
            [self setSelectedLanguage:systemlanguage];
        }
        
        else
        {
            [self setSelectedLanguage:KLMDefaultLanguage];
        }
    }
    
    return [userDefaults stringForKey:KLMSelectedLanguageKey];
}

@end
