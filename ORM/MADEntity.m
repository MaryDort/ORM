//
//  MADEntity.m
//  ORM
//
//  Created by Mariia Cherniuk on 28.02.16.
//  Copyright © 2016 marydort. All rights reserved.
//

#import "MADEntity.h"
#import "MADDataBaseManager.h"
#import "MADExceptions.h"

static NSString *insertQuery = @"INSERT INTO %@ (%@) VALUES (%@);";
static NSString *selectQuery = @"SELECT * FROM %@ WHERE %@_id = %ld;";
static NSString *updateQuery = @"UPDATE %@ SET %@ WHERE %@_id = %ld;";
static NSString *deleteQuery = @"DELETE FROM %@ WHERE %@_id = %ld;";
static NSString *listQuery = @"SELECT * FROM %@;";
static NSString *siblingQuery = @"SELECT * FROM %@ NATURAL JOIN %@ WHERE %@_id = %ld;";
static NSString *updateChildren = @"UPDATE %@ SET %@_id = %ld WHERE %@_id IN (%@);";

@interface MADEntity ()

@property (assign, nonatomic, readwrite) NSInteger entityId;
@property (strong, nonatomic, readwrite) NSMutableDictionary *modification;
@property (copy, nonatomic, readwrite) NSString *tableName;

+ (NSString *)tableName;

@end

@implementation MADEntity

+ (instancetype)sharedEntity {
    static MADEntity *entity = nil;
    static dispatch_once_t onceTocen;
    
    dispatch_once(&onceTocen, ^{
        entity = [[MADEntity alloc] init];
    });
    
    return entity;
}

+ (NSString *)tableName {
    return [[NSStringFromClass([self class]) substringFromIndex:3] lowercaseString];
}

+ (NSString *)classNameWith:(NSString *)fieldName {
    return [NSString stringWithFormat:@"MAD%@", [fieldName capitalizedString]];
}

+ (instancetype)findFirstById:(NSInteger)entityId {
    NSString *query = [NSString stringWithFormat:
                       selectQuery, [self tableName], [self tableName], entityId];
    NSArray *result = [[MADDataBaseManager sharedManager] executeSelectQuery:query];
    
    if (result.firstObject == nil) {
        NSString *reason = [NSString stringWithFormat:
                            @"Object '%@' with id = %ld not found!", [self tableName], entityId];
        @throw [[MADNotFoundError alloc] initWithName:@"MADNotFoundError"
                                               reason:reason
                                             userInfo:nil];
    }
    
    return [[self alloc] initWithDictionary:result.firstObject];
}

+ (NSArray *)showAll {
    NSString *query = [NSString stringWithFormat:listQuery, [self tableName]];
    NSArray *result = [[MADDataBaseManager sharedManager] executeSelectQuery:query];
    
    return [self formObjects:result];
}

+ (NSArray *)formObjects:(NSArray *)array {
    NSMutableArray *entities = [NSMutableArray array];
    
    for (NSDictionary *obj in array) {
        [entities addObject:[[self alloc] initWithDictionary:obj]];
    }
    
    return entities;
}

+ (NSArray *)formObjects:(NSArray *)array className:(NSString *)className {
    NSMutableArray *entities = [NSMutableArray array];
    
    for (NSDictionary *obj in array) {
        [entities addObject:[[NSClassFromString([self.class classNameWith:className]) alloc] initWithDictionary:obj]];
    }
    
    return entities;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _tableName = [self.class tableName];
        _entityId = -1;
        _fields = [[NSMutableDictionary alloc] init];
        _loaded = NO;
        _modified = NO;
        _modification = [[NSMutableDictionary alloc] init];
        _columns = [[NSMutableArray alloc] init];
        _parents = [[NSMutableArray alloc] init];
        _children = [[NSMutableDictionary alloc] init];
        _siblings = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)object {
    self = [super init];
    
    if (self) {
        _tableName = [self.class tableName];
        _entityId = [object[[NSString stringWithFormat:@"%@_id", _tableName]] integerValue];
        _fields = [[NSMutableDictionary alloc] initWithDictionary:object];
        _loaded = YES;
        _modified = NO;
        _modification = [[NSMutableDictionary alloc] init];
        _columns = [NSMutableArray arrayWithArray:[self importColumnsFromDictionary:object]];
        _children = [[NSMutableDictionary alloc] init];
        _parents = [[NSMutableArray alloc] init];
        _siblings = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (NSArray *)importColumnsFromDictionary:(NSDictionary *)object {
    NSArray *keys = [object allKeys];
    NSMutableArray *columns = [[NSMutableArray alloc] init];
    
    for (NSString *col in keys) {
        NSRange range = [col rangeOfString:[NSString stringWithFormat:@"%@_", [self.class tableName]]];
        
        if (range.location != NSNotFound) {
             NSString *column = [col substringFromIndex:range.length];
            
            if (![column isEqualToString:@"created"] && ![column isEqualToString:@"updated"] &&
                ![column isEqualToString:@"id"]) {
                [columns addObject:column];
            }
        }
    }
    
    return columns;
}

- (NSArray *)uniqueSelectByQuery:(NSString *)query tableName:(NSString *)tableName {
    NSArray *result = [[MADDataBaseManager sharedManager] executeSelectQuery:query];
    
    for (NSDictionary *obj in result) {
        [obj enumerateKeysAndObjectsUsingBlock:^(id key, id obj1, BOOL *stop) {
            if (obj1 == nil) {
                NSString *reason = [NSString stringWithFormat:
                                    @"Object in the '%@' not found!", tableName];
                @throw [[MADNotFoundError alloc] initWithName:@"MADNotFoundError"
                                                       reason:reason
                                                     userInfo:nil];
            }
        }];
    }
    
    return result;
}

//- (void)importParents {
//    NSArray *keys = [_fields allKeys];
//
//    for (NSString *parent in keys) {
//        if (![parent hasPrefix:[NSString stringWithFormat:@"%@_", [self.class tableName]]]) {
//            if ([parent hasSuffix:@"_id"]) {
////                import parents from DB by parent_id(from _fields)
//                NSRange range = [parent rangeOfString:@"_"];
//                NSString *tableName = [[NSString alloc] init];
//                
//                if (range.location != NSNotFound) {
//                    tableName = [parent substringToIndex:range.location];
//                }
//                
//                NSString *query = [NSMutableString stringWithFormat:selectQuery, tableName, tableName, [_fields[parent] integerValue]];
//                NSArray *result = [self uniqueSelectByQuery:query tableName:tableName];
//                id object = [[NSClassFromString([self.class classNameWith:tableName]) alloc] initWithDictionary:result.firstObject];
//
//                [_parents addObject:object];
//            }
//        }
//    }
//}

//- (id)getParent:(NSString *)key {
//    NSString *parentName = [self.class classNameWith:key];
//
//    for (MADEntity *parent in _parents) {
//        if ([[parent className] isEqualToString:parentName]) {
//            return parent;
//        }
//    }
//
//    [self importParents];
//
//    for (MADEntity *parent in _parents) {
//        if ([[parent className] isEqualToString:parentName]) {
//            return parent;
//        }
//    }
//
//    return nil;
//}

- (id)importParent:(NSString *)parentName {
    NSArray *keys = [_fields allKeys];
    
    for (NSString *parent in keys) {
        if ([parent isEqualToString:[NSString stringWithFormat:@"%@_id", parentName]]) {
            NSString *query = [NSMutableString stringWithFormat:selectQuery, parentName, parentName, [_fields[parent] integerValue]];
            NSArray *result = [self uniqueSelectByQuery:query tableName:parentName];
            id object = [[NSClassFromString([self.class classNameWith:parentName]) alloc] initWithDictionary:result.firstObject];
            
            [_parents addObject:object];
            
            return object;
        }
    }
    return nil;
}

- (id)getParent:(NSString *)key {
    NSString *parentName = [self.class classNameWith:key];
    
    for (MADEntity *parent in _parents) {
        if ([[parent className] isEqualToString:parentName]) {
            return parent;
        }
    }
    
    return [self importParent:key];
}

- (void)setParentValue:(MADEntity *)value forKey:(NSString *)key {
    NSString *column = [NSString stringWithFormat:@"%@_id", key];
    
    _fields[column] = [NSString stringWithFormat:@"%ld", value.entityId];
    _modification[column] = [NSString stringWithFormat:@"%ld", value.entityId];
    _modified = YES;
    
    for (MADEntity *parent in _parents) {
        if ([[parent className] isEqualToString:[self.class classNameWith:key]]) {
            [_parents removeObject:parent];
        }
    }
    [_parents addObject:value];
}

- (void)importChildren:(NSString *)fieldName {
    NSString *query = [NSMutableString stringWithFormat:selectQuery, fieldName, _tableName, _entityId];

    _children[fieldName] = [self.class formObjects:[self uniqueSelectByQuery:query tableName:fieldName] className:fieldName];
}

- (NSArray *)getChildren:(NSString *)key {
    if (_children[key] == nil) {
        [self importChildren:key];
    }
    
    return _children[key];
}

- (NSString *)getJoinTableNameFromTable:(NSString *)tableName {
    NSArray *linkingTable = [@[tableName, _tableName] sortedArrayUsingSelector: @selector(compare:)];
    
    return [linkingTable componentsJoinedByString:@"__"];
}

- (void)importSiblings:(NSString *)fieldName {
    NSString *query = [NSMutableString stringWithFormat:
                       siblingQuery, fieldName, [self getJoinTableNameFromTable:fieldName], _tableName, _entityId];

    _siblings[fieldName] = [self.class formObjects:[self uniqueSelectByQuery:query tableName:
                                                    [self getJoinTableNameFromTable:fieldName]] className:fieldName];
}

- (id)getSiblings:(NSString *)key {
    if (_siblings[key] == nil) {
        [self importSiblings:key];
    }
    
    return _siblings[key];
}

- (id)fieldValueForKey:(NSString *)key {
    NSString *column = [NSString stringWithFormat:@"%@_%@", [self.class tableName], key];
    
    return _fields[column];
}

- (void)setFieldValue:(id)value forKey:(NSString *)key {
    NSString *column = [NSString stringWithFormat:@"%@_%@", [self.class tableName], key];
    
    _fields[column] = value;
    _modification[column] = value;
    _modified = YES;
}

- (void)save {
    if (_entityId == -1) {
        [self insert];
    } else {
        [self update];
    }
    _modified = NO;
    [_modification removeAllObjects];
}

- (void)insert {
    NSMutableArray *colums = [[NSMutableArray alloc] init];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    [_modification enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        [colums addObject:key];
    }];
    
    [_modification enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        [values addObject:[NSString stringWithFormat:@"'%@'", obj]];
    }];
    
    PGresult *result = [[MADDataBaseManager sharedManager] executeQuery:
                        [NSString stringWithFormat:insertQuery, _tableName,
                         [colums componentsJoinedByString:@", "],
                         [values componentsJoinedByString:@", "], _tableName]];
    
    if (PQresultStatus(result) == PGRES_COMMAND_OK) {
        _entityId = [[MADDataBaseManager sharedManager] lastInsertedRowID:
                     [NSString stringWithFormat:@"%@_%@_id_seq", _tableName, _tableName]];
    }
    PQclear(result);
}

- (void)update {
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    [_modification enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        [values addObject:[NSString stringWithFormat:@"%@ = '%@'", key, obj]];
    }];

    [[MADDataBaseManager sharedManager] executeQuery:
     [NSString stringWithFormat:updateQuery, _tableName, [values componentsJoinedByString:@", "], _tableName, _entityId]];
}

- (void)remove {
    if (_entityId == -1) {
        NSString *reason = [NSString stringWithFormat:
                            @"There is no object in %@ for such id!", [self.class tableName]];
        @throw [[MADNotFoundError alloc] initWithName:@"NotFoundError"
                                                  reason:reason
                                                userInfo:nil];
    }
    NSString *query = [NSString stringWithFormat:deleteQuery, _tableName, _tableName, (long)_entityId];
    
    [[MADDataBaseManager sharedManager] executeQuery:query];
}

- (NSString *)description {
    return [[super description] stringByAppendingString:[NSString stringWithFormat:@" %@", _fields]];
}

@end
