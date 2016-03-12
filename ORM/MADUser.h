//
//  MADUser.h
//  ORM
//
//  Created by Mariia Cherniuk on 29.02.16.
//  Copyright © 2016 marydort. All rights reserved.
//

#import "MADEntity.h"
@class MADComment;

@interface MADUser : MADEntity

@property (copy, nonatomic, readwrite) NSString *name;
@property (copy, nonatomic, readwrite) NSString *email;
@property (strong, nonatomic, readwrite) NSMutableArray *comments;

@end
