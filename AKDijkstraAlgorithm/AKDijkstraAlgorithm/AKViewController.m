//
//  AKViewController.m
//  AKDijkstraAlgorithm
//
//  Created by Anish Kumar on 4/12/15.
//  Copyright (c) 2015 Anish Kumar. All rights reserved.
//

#import "AKViewController.h"
#import "AKCollectionViewCell.h"
#import "AKNode.h"


@interface AKViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@property(nonatomic)NSMutableArray *collectionArray;
@property(nonatomic)NSMutableArray *twoDimensionArray;
@property(nonatomic)NSInteger collectionArrayCount;
@property(nonatomic)NSArray *finalPath;

@end


@implementation AKViewController

#pragma mark - Constants

static NSString * const reuseIdentifier = @"dCell";
static NSInteger const rows = 15;
static NSInteger const colomns = 10;


#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myCollectionView.dataSource=self;
    self.myCollectionView.delegate=self;
    self.myCollectionView.backgroundColor = [UIColor whiteColor];
    
    [self creatingTheArray];
    
    // Register cell classes
    [self.myCollectionView registerClass:[AKCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionArrayCount;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AKCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    AKNode *node = self.collectionArray[indexPath.row];
    cell.cellNode = node;
    
    
    if ([node.value isEqualToString:@"X"]) {
        cell.backgroundColor = [UIColor redColor];
        [cell setSelected:NO];
    }
    else{
        
        cell.backgroundColor = [UIColor yellowColor];
    }
    return cell;
}


#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    AKNode *finalNode = self.collectionArray[indexPath.row];
    if (![finalNode.value isEqualToString:@"X"]) {

    [self dijkstrasAlgorithmFromIndexPath:indexPath finalNode:finalNode];
    
    AKCollectionViewCell *cell = (AKCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //cell.cellNode = finalNode;
    NSArray* arrayOfPath = self.finalPath;
    
    for (AKNode *pathNode in arrayOfPath) {
        //NSLog(@"ROW: %ld\nCOLOMN: %ld", pathNode.row, pathNode.colomn);

        NSIndexPath *ip = [NSIndexPath indexPathForRow:(pathNode.row*10)+pathNode.column inSection:0];
        AKCollectionViewCell *cellTrace = (AKCollectionViewCell *)[collectionView cellForItemAtIndexPath:ip];
        cellTrace.backgroundColor = [UIColor greenColor];
        [UIView animateWithDuration:4.0 animations:^{
            cellTrace.backgroundColor = [UIColor yellowColor];
        }];
    }
    
    cell.backgroundColor = [UIColor greenColor];
    [UIView animateWithDuration:4.0 animations:^{
        cell.backgroundColor = [UIColor yellowColor];
    }];

    
    [self creatingTheArray];
    }
}


#pragma mark - Dijkstra's Algorithm

- (void)dijkstrasAlgorithmFromIndexPath:(NSIndexPath *)indexPath finalNode:(AKNode *)finalNode
{
    NSInteger columnAssumed = indexPath.row%10;
    NSInteger rowAssumed = indexPath.row/10;
    NSLog(@"row: %ld \ncolomn: %ld", rowAssumed, columnAssumed);
    
        
        for (NSInteger i =0; i<=rowAssumed; i++) {
            
            for (NSInteger j =0; j<=columnAssumed; j++) {
                
                AKNode *currentNode = self.twoDimensionArray[i][j];
                currentNode.row = i;
                currentNode.column = j;
                
                if (j+1 <= columnAssumed)
                {
                    
                    AKNode *followingColumnNode = self.twoDimensionArray[i][j+1];
                    
                    if ((currentNode.distance+1 < followingColumnNode.distance || followingColumnNode.distance == 0) && ![followingColumnNode.value isEqualToString:@"X"])
                    {
                        followingColumnNode.row = i;
                        followingColumnNode.column = j+1;
                        for (AKNode *node in currentNode.path) {
                            [followingColumnNode.path addObject:node];
                        }
                        [followingColumnNode.path addObject:followingColumnNode];
                        
                        followingColumnNode.distance = currentNode.distance + 1;
                        [self.twoDimensionArray[i] replaceObjectAtIndex:j+1 withObject:followingColumnNode];
                    }
                    
                }
                
                
                if (i+1 <= rowAssumed)
                {
                    
                    AKNode *follwingRowNode = self.twoDimensionArray[i+1][j];

                    if((currentNode.distance+1 < follwingRowNode.distance || follwingRowNode.distance == 0) && ![follwingRowNode.value isEqualToString:@"X"])
                    {
                        follwingRowNode.row = i+1;
                        follwingRowNode.column = j;
                        for (AKNode *node in currentNode.path) {
                            [follwingRowNode.path addObject:node];
                        }
                        [follwingRowNode.path addObject:follwingRowNode];
                        
                        follwingRowNode.distance = currentNode.distance+1;
                        [self.twoDimensionArray[i+1] replaceObjectAtIndex:j withObject:follwingRowNode];
                    }
                }
                
            }
            
        }
        
        AKNode *myFinalNode = self.twoDimensionArray[rowAssumed][columnAssumed];
        NSLog(@"Distance = %ld", myFinalNode.distance);
        self.finalPath = myFinalNode.path;
}



#pragma mark - Data Manager

- (void)creatingTheArray {
    
    self.twoDimensionArray = [[NSMutableArray alloc] init];
    self.collectionArray = [[NSMutableArray alloc] init];
    self.collectionArrayCount = 150;
    
    for (NSInteger i=1; i<=rows; i++) {
        NSMutableArray *rowArray = [[NSMutableArray alloc] init];
        
        for (NSInteger j=1; j<=colomns; j++) {
            
            //Origin Cell
            if (i==j && j==1)
            {
                AKNode *node = [[AKNode alloc] init];
                node.value = @"O";
                [node.path addObject:node];
                [rowArray addObject:node];
                [self.collectionArray addObject:node];
            }
            
            //Bad Cells
            else if ((i*j)%14 == 1 || (i*j)%13 == 1)
            {
                AKNode *node = [[AKNode alloc] init];
                node.value = @"X";
                node.distance = 25000;
                [rowArray addObject:node];
                [self.collectionArray addObject:node];
            }
            
            //Good Cells
            else
            {
                AKNode *node = [[AKNode alloc] init];
                node.value = @"O";
                [rowArray addObject:node];
                [self.collectionArray addObject:node];
            }
        }
        [self.twoDimensionArray addObject:rowArray];
        
    }

}

@end

