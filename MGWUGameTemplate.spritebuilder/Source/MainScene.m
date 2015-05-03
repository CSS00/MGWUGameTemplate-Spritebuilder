//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "Grid.h"

@implementation MainScene{
    Grid *_grid;
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_movesLabel;
}

- (void)play {
    CCLOG(@"play button pressed");
}

- (void)update:(CCTime)delta {
    if(_grid.moves == 0){
        
    }
}

- (void)didLoadFromCCB {
    [_grid addObserver:self forKeyPath:@"score" options:0 context:NULL];
    [_grid addObserver:self forKeyPath:@"moves" options:0 context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"score"]) {
        _scoreLabel.string = [NSString stringWithFormat:@"%ld", _grid.score];
    }
    if([keyPath isEqualToString:@"moves"]){
        _movesLabel.string = [NSString stringWithFormat:@"%ld", _grid.moves];
    }
}

- (void)dealloc {
    [_grid removeObserver:self forKeyPath:@"score"];
    [_grid removeObserver:self forKeyPath:@"moves"];
}

@end
