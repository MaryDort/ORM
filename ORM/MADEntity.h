//
//  MADEntity.h
//  ORM
//
//  Created by Mariia Cherniuk on 28.02.16.
//  Copyright © 2016 marydort. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MADEntity : NSObject

@property (strong, nonatomic, readwrite) NSMutableDictionary *fields;
@property (assign, nonatomic, readwrite) BOOL loaded;
@property (assign, nonatomic, readwrite) BOOL modified;
@property (strong, nonatomic, readwrite) NSMutableArray *columns;
@property (strong, nonatomic, readwrite) NSMutableArray *parents;
@property (strong, nonatomic, readwrite) NSMutableDictionary *children;
@property (strong, nonatomic, readwrite) NSMutableDictionary *siblings;

+ (instancetype)sharedEntity;
+ (instancetype)findFirstById:(NSInteger)entityId;
+ (NSArray *)showAll;

- (id)fieldValueForKey:(NSString *)key;
- (void)setFieldValue:(id)value forKey:(NSString *)key;
- (void)save;
- (void)insert;
- (void)update;
- (void)remove;

- (id)getParent:(NSString *)key;
- (void)setParentValue:(id)value forKey:(NSString *)key;
- (id)getChildren:(NSString *)key;
- (id)getSiblings:(NSString *)key;

@end
