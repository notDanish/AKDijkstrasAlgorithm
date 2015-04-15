//
//  AKNode.h
//  AKDijkstraAlgorithm
//
//  Created by Anish Kumar on 4/12/15.
//  Copyright (c) 2015 Anish Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKNode : NSObject

@property (strong, nonatomic) NSString *value;
@property (nonatomic) NSInteger distance;
@property (strong, nonatomic) NSMutableArray *path;

@property (nonatomic) NSInteger row;
@property (nonatomic) NSInteger colomn;

-(NSString *)description;

@end
