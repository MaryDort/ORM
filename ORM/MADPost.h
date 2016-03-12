//
//  MADPost.h
//  ORM
//
//  Created by Mariia Cherniuk on 29.02.16.
//  Copyright © 2016 marydort. All rights reserved.
//

#import "MADEntity.h"

@class MADComment;
@class MADTag;
@class MADCategory;

@interface MADPost : MADEntity

@property (copy, nonatomic, readwrite) NSString *title;
@property (copy, nonatomic, readwrite) NSString *content;
@property (strong, nonatomic, readwrite) MADCategory *category;
@property (strong, nonatomic, readwrite) NSMutableArray *comments;
@property (strong, nonatomic, readwrite) NSMutableArray *tags;

@end
