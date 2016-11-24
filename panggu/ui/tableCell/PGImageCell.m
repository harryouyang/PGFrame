//
//  PGImageCell.m
//  PGFrame
//
//  Created by ouyanghua on 16/11/24.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGImageCell.h"
#import "UIImageView+PGDown.h"

@interface PGImageCell ()
@property(nonatomic, strong)UIImageView *imageV;
@end

@implementation PGImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageV.backgroundColor = [UIColor orangeColor];
//        self.imageV.bShowAnimation = YES;
        [self.contentView addSubview:self.imageV];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageV.frame = CGRectInset(self.bounds, 5, 5);
}

- (void)configCellWithImageUrl:(NSString *)url {
    [self.imageV setImageWithUrl:url placeholder:nil];
}

@end
