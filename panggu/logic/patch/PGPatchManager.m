//
//  PGPatchManager.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/25.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGPatchManager.h"
#import "JPEngine.h"
#import "PGPatchObject.h"
#import "NSString+json.h"
#import "PGCacheManager.h"
#import "PGRequestManager.h"

static PGPatchManager *s_patchManager = nil;

@interface PGPatchManager ()<PGApiDelegate>
@property(nonatomic, strong)NSMutableArray *arrayHots;
@end

@implementation PGPatchManager

+ (PGPatchManager *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_patchManager = [[PGPatchManager alloc] init];
        s_patchManager.arrayHots = [[NSMutableArray alloc] init];
        [s_patchManager.arrayHots addObjectsFromArray:[s_patchManager localHots]];
    });
    return s_patchManager;
}

- (void)startListen
{
    [JPEngine startEngine];
}

- (void)getHotData
{
    NSMutableArray *localHotIDs = [[NSMutableArray alloc] init];
    for(PGPatchObject *obj in self.arrayHots)
    {
        [localHotIDs addObject:obj.mFixID];
    }
    
    //本地已经存在的补丁
    NSString *ids = [NSString jsonStringWithArray:localHotIDs];
    
    [PGRequestManager startPostClient:API_TYPE_PATCH param:@{@"fixIds":ids} target:self extendParam:nil];
}

- (NSMutableArray *)localHots
{
    NSObject *obj = [PGCacheManager readCacheType:ECacheType_Hots];
    if(obj != nil)
        return (NSMutableArray *)obj;
    else
        return [[NSMutableArray alloc] init];
}

- (void)saveHotsToLocal
{
    [PGCacheManager cacheData:self.arrayHots type:ECacheType_Hots];
}

- (void)executeLocalHot
{
    for(PGPatchObject *obj in self.arrayHots)
    {
        [JPEngine evaluateScript:obj.mFixString];
    }
}

- (void)executeHot:(NSArray *)array
{
    for(PGPatchObject *obj in array)
    {
        [JPEngine evaluateScript:obj.mFixString];
    }
}

- (void)addHot:(NSArray *)array
{
    if(array == nil || array.count <= 0)
        return;
    
    for(PGPatchObject *newobj in array)
    {
        for(PGPatchObject *obj in self.arrayHots)
        {
            if([newobj.mFixID compare:obj.mFixID] != NSOrderedSame)
            {
                [self.arrayHots addObject:obj];
            }
        }
    }
    
}

- (void)delHot:(NSArray *)array
{
    if(array == nil || array.count <= 0)
        return;
    
    for(PGPatchObject *delobj in array)
    {
        for(PGPatchObject *obj in self.arrayHots)
        {
            if([delobj.mFixID compare:obj.mFixID] == NSOrderedSame)
            {
                [self.arrayHots removeObject:obj];
                break;
            }
        }
    }
    
}

#pragma mark -
- (void)dataRequestFinish:(PGResultObject *)resultObj apiType:(PGApiType)apiType
{
    if(apiType == API_TYPE_PATCH)
    {
        if(resultObj.nCode == 0)
        {
            NSMutableDictionary *dic = (NSMutableDictionary *)resultObj.dataObject;
            NSMutableArray *addarray = [dic objectForKey:@"add"];
            NSMutableArray *delarray = [dic objectForKey:@"del"];
            
            //执行新的补丁
            [self executeHot:addarray];
            
            //删除旧的补丁
            [self delHot:delarray];
            
            //添加新的补丁
            [self addHot:addarray];
            
            //保存新的补丁
            [self saveHotsToLocal];
        }
    }
}

@end
