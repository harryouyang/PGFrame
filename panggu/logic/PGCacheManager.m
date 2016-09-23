//
//  PGCacheManager.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/22.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGCacheManager.h"
#import "PGContext.h"
#import "NSString+encrypt.h"


@implementation PGCacheManager

+ (BOOL)cacheData:(NSObject *)data type:(PGCacheType)type
{
    return [PGCacheManager  cacheData:data type:type param:nil];
}

+ (BOOL)cacheData:(NSObject *)data type:(PGCacheType)type param:(NSObject *)param
{
    NSString *filePath = [PGCacheManager filePathWithType:type param:param];
    if(data == nil)
    {
        return [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    else
    {
        return [NSKeyedArchiver archiveRootObject:data toFile:filePath];
    }
}

+ (NSObject *)readCacheType:(PGCacheType)type
{
    return [PGCacheManager readCacheType:type param:nil];
}

+ (NSObject *)readCacheType:(PGCacheType)type param:(NSObject *)param
{
    NSString *filePath = [PGCacheManager filePathWithType:type param:param];
    NSObject *resultObj = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return resultObj;
}

+ (NSString *)filePathWithType:(PGCacheType)type param:(NSObject *)param
{
    NSString *filePath = nil;
    
    switch(type)
    {
        case ECacheType_ProductList:
        {
            filePath = [NSString stringWithFormat:@"%@/%@",[PGContext dataPathForCache],[NSString MD5Encrypt:@"productCache"]];
            break;
        }
        
        case ECacheType_Hots:
        {
            filePath = [NSString stringWithFormat:@"%@/%@",[PGContext dataPathForCache],[NSString MD5Encrypt:@"systemHots"]];
            break;
        }
            
        case ECacheType_UserOrderList:
        {
            filePath = [NSString stringWithFormat:@"%@/%@",[PGContext userPathForCache],[NSString MD5Encrypt:@"OrderListCache"]];
            break;
        }
            
        case ECacheType_Message:
        {
            filePath = [NSString stringWithFormat:@"%@/%@",[PGContext userPathDocument],[NSString MD5Encrypt:@"messageReceiptData"]];
            break;
        }
            
        case ECacheType_ApiStrategy:
        {
            filePath = [NSString stringWithFormat:@"%@/%@/%@",[PGContext dataPathForCache],[NSString MD5Encrypt:@"apiStrategy"], (NSString *)param];
            break;
        }
    }
    
    return filePath;
}

#pragma mark -
+ (float)fileSizeAtPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL bDirectory = NO;
    BOOL bExist = [fileManager fileExistsAtPath:path isDirectory:&bDirectory];
    if(bExist)
    {
        if(bDirectory)
        {
            return [PGCacheManager folderSizeAtPath:path];
        }
        else
        {
            long long size = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
            return size/1024.0/1024.0;
        }
    }
    return 0;
}

+ (float)folderSizeAtPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float folderSize = 0.0;
    if ([fileManager fileExistsAtPath:path])
    {
        NSArray *childerFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles)
        {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            folderSize += [PGCacheManager fileSizeAtPath:absolutePath];
        }
        
        return folderSize;
    }
    return 0;
}

+ (float)cacheDataSize
{
    float folderSize = [PGCacheManager folderSizeAtPath:[PGContext imagePath]];
    folderSize += [PGCacheManager folderSizeAtPath:[PGContext dataPathForCache]];
    folderSize += [PGCacheManager folderSizeAtPath:[PGContext userPathForCache]];
    return folderSize;
}

+ (void)clearCacheData:(void(^)())finishBlock
{
    NSString *path = [PGContext dataPathForCache];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path])
    {
        NSArray *childerFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles)
        {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    
    path = [PGContext dataPathForCache];
    if([fileManager fileExistsAtPath:path])
    {
        NSArray *childerFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles)
        {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    
    path = [PGContext userPathForCache];
    if([fileManager fileExistsAtPath:path])
    {
        NSArray *childerFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles)
        {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    
    if(finishBlock)
    {
        finishBlock();
    }
}

#pragma mark -
/**
 避免API接口频繁的调用。
 */
+ (NSObject *)getApiCacheStringWithKey:(NSString *)key
{
    return [PGCacheManager readCacheType:ECacheType_ApiStrategy param:key];
}
/*
 缓存接口数据
 */
+ (BOOL)cacheApiData:(NSString *)apiString key:(NSString *)szKey
{
    return [PGCacheManager cacheData:apiString type:ECacheType_ApiStrategy param:szKey];
}


@end
