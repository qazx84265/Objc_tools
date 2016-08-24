//
//  ASTabBar.h
//  ARSeek
//
//  Created by ARSeeds on 16/7/12.
//  Copyright © 2016年 ARSeeds. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^itemClick)();

@interface ASTabBar : UITabBar

- (id)initWithItemClickHandler:(itemClick)handler;

@property (nonatomic, copy) itemClick itemClickHandler;

@end
