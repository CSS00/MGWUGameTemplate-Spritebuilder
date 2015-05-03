//
//  Block.m
//  MGWUGameTemplate
//
//  Created by Congshan Lv on 3/1/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Block.h"
#import <CCSpriteFrame.h>

@implementation Block

- (id)init{
    self = [super init];
    CCSpriteFrame *frame = [CCSpriteFrame frameWithImageNamed:@"./Asset/Blocks_01_256x256_Alt_04_005.png"];
    self.spriteFrame = frame;
    return self;
}

@end
