//
//  AKCollectionViewCell.h
//  AKDijkstraAlgorithm
//
//  Created by Anish Kumar on 4/13/15.
//  Copyright (c) 2015 Anish Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AKNode;
@interface AKCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) AKNode *cellNode;

@end
