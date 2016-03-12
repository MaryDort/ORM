//
//  MADTag.h
//  ORM
//
//  Created by Mariia Cherniuk on 28.02.16.
//  Copyright © 2016 marydort. All rights reserved.
//

#import "MADEntity.h"
@class MADPost;

@interface MADTag : MADEntity

@property (copy, nonatomic, readwrite) NSString *name;
@property (strong, nonatomic, readwrite) NSMutableArray *posts;

@end
