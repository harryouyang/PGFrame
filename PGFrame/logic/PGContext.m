//
//  PGContext.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/22.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGContext.h"
#import "PGConfig.h"
#import "PGMacroDefHeader.h"
#import "NSString+encrypt.h"

#define IS_LOGIN_KEY        @"isLogin"
#define IS_AGAIN_OPENT_KEY  @"isAgainOpen"
#define USER_ACCOUNT_KEY    @"userAccount"
#define USER_TOKEN          @"userToken"

#define PSWF                @"pswf"

static PGContext *s_context = nil;
@implementation PGContext

+ (PGContext *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_context = [[PGContext alloc] init];
        s_context.userAccount = @"";
        s_context.userToken = @"";
    });
    return s_context;
}

+ (NSString *)imagePath
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", kPathCache, PG_IMAGE_PATH];
    if(![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return path;
}

+ (NSString *)dataPathForCache
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", kPathCache, PG_CACHES_DATA_PATH];
    if(![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return path;
}

+ (NSString *)userPathForCache
{
    if([PGContext shareInstance].userAccount != nil && [PGContext shareInstance].userAccount.length > 0)
    {
        NSString *path = [NSString stringWithFormat:@"%@/user", kPathCache];
        if(![[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
        }
        path = [NSString stringWithFormat:@"%@/%@", path, [NSString MD5Encrypt:[PGContext shareInstance].userAccount]];
        if(![[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
        }
        return path;
    }
    return nil;
}

+ (NSString *)userPathDocument
{
    if([PGContext shareInstance].userAccount != nil && [PGContext shareInstance].userAccount.length > 0)
    {
        NSString *path = [NSString stringWithFormat:@"%@/%@",kPathDocument, [NSString MD5Encrypt:[PGContext shareInstance].userAccount]];
        if(![[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
        }
        
        return path;
    }
    return nil;
}

- (void)readInfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.bAgainOpen = [defaults boolForKey:IS_AGAIN_OPENT_KEY];
    self.bLogin = [defaults boolForKey:IS_LOGIN_KEY];
    self.userAccount = [defaults stringForKey:USER_ACCOUNT_KEY];
    self.userToken = [defaults stringForKey:USER_TOKEN];
    if(self.userToken == nil)
    {
        self.userToken = @"";
    }
}

- (void)writeInfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.bAgainOpen forKey:IS_AGAIN_OPENT_KEY];
    [defaults setBool:self.bLogin forKey:IS_LOGIN_KEY];
    [defaults setObject:self.userAccount forKey:USER_ACCOUNT_KEY];
    [defaults setObject:self.userToken forKey:USER_TOKEN];
    [defaults synchronize];
}

#pragma mark -
- (void)savePsw:(NSString *)szPsw
{
    NSString *path = [[PGContext userPathDocument] stringByAppendingPathComponent:PSWF];
    const char* chPsw = [szPsw UTF8String];
    int nLen = (int)strlen(chPsw);
    NSMutableData *data = [NSMutableData new];
    for(int i = 0; i < nLen; i++)
    {
        int ch = chPsw[i];
        ch *= 2;
        [data appendBytes:&ch length:sizeof(int)];
    }
    
    [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
}

- (NSString *)getPsw:(NSString *)szuser
{
    NSString *szPath = [[PGContext userPathDocument] stringByAppendingPathComponent:PSWF];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:szPath];
    int n = ((int)sizeof(char))*((int)data.length);
    char *buf = malloc(n);
    char *buffer = malloc(n/sizeof(int)+1);
    [data getBytes:buf length:n];
    for(int i=0;i<n;i+=4)
    {
        char f[4];
        memcpy(f,buf+i,4);
        int ch = *(int*)f;
        ch /= 2;
        buffer[i/4] = ch;
    }
    buffer[n/sizeof(int)] = '\0';
    NSString *psw = [NSString stringWithUTF8String:buffer];
    free(buf);
    free(buffer);
    return psw;
}

@end
