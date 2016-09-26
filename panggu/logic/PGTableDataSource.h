//
//  PGTableDataSource.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/24.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSArray* (^sectionObjDataToSectionArray)(NSObject *sectionItem);
typedef void(^config_block)(UITableViewCell *cell, NSObject *item);
typedef UITableViewCell* (^createCellBlock)(NSString *cellIdentifier);
typedef NSArray* (^sectionTitles)(void);

@interface PGTableDataSource : NSObject<UITableViewDataSource>
/*
 是否支持分组
 */
@property(nonatomic, assign)BOOL bMutableSection;
/*
 数据源对象
 */
@property(nonatomic, strong)NSArray *arrayData;
/*
 获取单行中的数据对象
 */
@property(nonatomic, copy)sectionObjDataToSectionArray sectionObjToArrayBlock;
/*
 设置sectionTitles
 */
@property(nonatomic, copy)sectionTitles sectionTitlesBlock;

- (id)initWithItems:(NSArray *)array
     cellIdentifier:(NSString *)identifier
    createCellBlock:(createCellBlock)createBlock
    configCellBlock:(config_block)configBlock;

/*
 获取单行中的数据对象
 */
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

/*
 移除数据
 */
- (void)removeData:(NSInteger)index;

@end
