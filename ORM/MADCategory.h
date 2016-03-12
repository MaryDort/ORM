//
//  MADCategory.h
//  ORM
//
//  Created by Mariia Cherniuk on 29.02.16.
//  Copyright © 2016 marydort. All rights reserved.
//

#import "MADEntity.h"
@class MADPost;
@class MADSection;

@interface MADCategory : MADEntity

@property (copy, nonatomic, readwrite) NSString *title;
@property (strong, nonatomic, readwrite) MADSection *section;
@property (strong, nonatomic, readwrite) NSMutableArray *posts;

@end
