//
//  MADSection.m
//  ORM
//
//  Created by Mariia Cherniuk on 29.02.16.
//  Copyright © 2016 marydort. All rights reserved.
//

#import "MADSection.h"
#import "MADCategory.h"

@implementation MADSection

- (NSString *)title {
    return [self fieldValueForKey:[NSString stringWithUTF8String:sel_getName(_cmd)]];
}

- (void)setTitle:(NSString *)newTitle {
    return [self setFieldValue:newTitle forKey:@"title"];
}

- (NSArray *)categories {
    return [self getChildren:@"category"];
}

@end
