//
//  MADComment.h
//  ORM
//
//  Created by Mariia Cherniuk on 29.02.16.
//  Copyright © 2016 marydort. All rights reserved.
//

#import "MADEntity.h"
#import "MADPost.h"
#import "MADUser.h"

@interface MADComment : MADEntity

@property (assign, nonatomic, readwrite) NSNumber *date;
@property (copy, nonatomic, readwrite) NSString *text;
@property (copy, nonatomic, readwrite) NSString *author;
@property (strong, nonatomic, readwrite) MADPost *post;
@property (strong, nonatomic, readwrite) MADUser *user;

@end
