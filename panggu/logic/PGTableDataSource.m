//
//  PGTableDataSource.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/24.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGTableDataSource.h"

@interface PGTableDataSource ()
{
    NSMutableArray *items;
    NSString *cellIdentifier;
}
@property(nonatomic, copy)config_block configCellBlock;
@property(nonatomic, copy)createCellBlock cellCreateBlock;
@end

@implementation PGTableDataSource

- (id)initWithItems:(NSArray *)array cellIdentifier:(NSString *)identifier createCellBlock:(createCellBlock)createBlock configCellBlock:(config_block)configBlock
{
    if(self = [super init])
    {
        items = [[NSMutableArray alloc] init];
        if(array != nil && array.count > 0)
        {
            [items addObjectsFromArray:array];
        }
        
        cellIdentifier = identifier;
        
        self.configCellBlock = configBlock;
        self.cellCreateBlock = createBlock;
    }
    return self;
}

- (void)setArrayData:(NSArray *)arrayData
{
    [items removeAllObjects];
    if(arrayData != nil && arrayData.count > 0)
    {
        [items addObjectsFromArray:arrayData];
    }
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.bMutableSection)
    {
        NSArray *array = nil;
        if(self.sectionObjToArrayBlock)
        {
            array = self.sectionObjToArrayBlock(items[indexPath.section]);
        }
        else
        {
            array = items[indexPath.section];
        }
        return array[(NSUInteger)indexPath.row];
    }
    else
    {
        return items[(NSUInteger)indexPath.row];
    }
}

- (void)removeData:(NSInteger)index
{
    if(index >= 0 && items.count > index)
        [items removeObjectAtIndex:index];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.bMutableSection)
    {
        NSArray *array = nil;
        if(self.sectionObjToArrayBlock)
        {
            array = self.sectionObjToArrayBlock(items[section]);
        }
        else
        {
            array = items[section];
        }
        return array.count;
    }
    else
    {
        return items.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.bMutableSection)
    {
        return items.count;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell*)tableView:(UITableView* )tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    id cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        if(self.cellCreateBlock != nil)
            cell = self.cellCreateBlock(cellIdentifier);
        else
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    id item = [self itemAtIndexPath:indexPath];
    if(self.configCellBlock != nil)
        self.configCellBlock(cell,item);
    return cell;
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(self.sectionTitlesBlock)
    {
        return self.sectionTitlesBlock();
    }
    return nil;
}

@end
