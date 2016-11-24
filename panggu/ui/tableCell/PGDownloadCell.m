//
//  PGDownloadCell.m
//  PGFrame
//
//  Created by ouyanghua on 16/11/24.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGDownloadCell.h"

@interface PGDownloadCell ()<PGTaskDelegate>
@property(nonatomic, strong)PGTaskObject *taskObj;
@end

@implementation PGDownloadCell

- (void)configWithTask:(PGTaskObject *)obj {
    self.taskObj = obj;
    self.textLabel.text = obj.mFileName;
    self.detailTextLabel.text = [NSString stringWithFormat:@"%lld / %lld", self.taskObj.mTotalBytesWritten, self.taskObj.mTotalBytesExpectedToWrite];
    self.taskObj.mDelegate = self;
}

#pragma mark -
- (void)taskDidUpdate:(PGTaskObject *)taskObj {
    
    self.detailTextLabel.text = [NSString stringWithFormat:@"%lld / %lld", taskObj.mTotalBytesWritten, taskObj.mTotalBytesExpectedToWrite];
    
}

@end
