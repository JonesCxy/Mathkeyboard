//
//  NSObject+DictionaryRepresentation.h
//  AppLibrary
//
//  Created by Gaurav Rajput on 18/11/13.
//  Copyright (c) 2013 Chrome Infotech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DictionaryRepresentation)

/**
 Returns an NSDictionary containing the properties of an object that are not nil.
 */
- (NSDictionary *)objectDict;

- (NSString*)json ;

- (NSString *)jsonWithSuperClass;

@end
