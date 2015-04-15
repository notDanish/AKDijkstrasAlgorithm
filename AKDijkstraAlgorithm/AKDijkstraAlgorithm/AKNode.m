//
//  AKNode.m
//  AKDijkstraAlgorithm
//
//  Created by Anish Kumar on 4/12/15.
//  Copyright (c) 2015 Anish Kumar. All rights reserved.
//

#import "AKNode.h"

@implementation AKNode

-(NSString *)description
{
    return [NSString stringWithFormat:@"Value: %@ \nDistance: %ld\nPosition: (%ld, %ld)", self.value, self.distance, self.row, self.column];
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        _path = [[NSMutableArray alloc] init];
        _distance = 0;
        _column = 0;
        _row = 0;
    }

    return self;
}

@end
