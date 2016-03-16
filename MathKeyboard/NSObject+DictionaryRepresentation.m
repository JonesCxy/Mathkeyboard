//
//  NSObject+DictionaryRepresentation.m
//  AppLibrary
//
//  Created by Gaurav Rajput on 18/11/13.
//  Copyright (c) 2013 Chrome Infotech. All rights reserved.
//

#import "NSObject+DictionaryRepresentation.h"
#import <objc/runtime.h>

@implementation NSObject (DictionaryRepresentation)

- (NSDictionary *)objectDict
{
    unsigned int count = 0;
    // Get a list of all properties in the class.
    objc_property_t *properties = class_copyPropertyList([self class], &count);

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:count];

    for (int i = 0; i < count; i++)
    {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        NSString *value = [self valueForKey:key];
        
        //If the value saved was not kind of string but of nsnumber type like Bool, int etc.. then will explicitly convert it to string to get value. The problem was becasue it start given bool value as 'false' and 'true', and that cause issues on server while make entry in db. so we have to get it like 1, 0 , so this need to be change.
        if([[self valueForKey:key] isKindOfClass:[NSNumber class]]){
            value = [NSString stringWithFormat:@"%@", [self valueForKey:key]];
        }
        
        // Only add to the NSDictionary if it's not nil.
        if (value)
            [dictionary setObject:value forKey:key];
    }

    free(properties);

    return dictionary;
}

- (NSString *)json{
    
    NSString *jsonString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[self objectDict] options:NSJSONWritingPrettyPrinted error:nil
                                                           ] encoding:NSUTF8StringEncoding] ;
    
    return jsonString ;
}

- (NSString *)jsonWithSuperClass{
    
    NSDictionary *currentDict = [self objectDict];

    NSDictionary *superDict = [self objectDictForParentClass:[self superclass]];
    
    NSMutableDictionary *fullJsonDict = [[NSMutableDictionary alloc] initWithDictionary:currentDict];
    [fullJsonDict addEntriesFromDictionary:superDict];
    currentDict = nil;
    superDict = nil;
    
    NSString *jsonString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:fullJsonDict options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding] ;
    
    return jsonString ;
}


- (NSDictionary *)objectDictForParentClass:(Class)className
{
    unsigned int count = 0;
    // Get a list of all properties in the class.
    objc_property_t *properties = class_copyPropertyList(className, &count);
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:count];
    
    for (int i = 0; i < count; i++)
    {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        NSString *value = [self valueForKey:key];
        
        //If the value saved was not kind of string but of nsnumber type like Bool, int etc.. then will explicitly convert it to string to get value. The problem was becasue it start given bool value as 'false' and 'true', and that cause issues on server while make entry in db. so we have to get it like 1, 0 , so this need to be change.
        if([[self valueForKey:key] isKindOfClass:[NSNumber class]]){
            value = [NSString stringWithFormat:@"%@", [self valueForKey:key]];
        }
        
        // Only add to the NSDictionary if it's not nil.
        if (value)
            [dictionary setObject:value forKey:key];
    }
    
    free(properties);
    
    return dictionary;
}



@end
