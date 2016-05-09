
//The MIT License (MIT)
//
//Copyright (c) 2013 Rafał Augustyniak
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of
//this software and associated documentation files (the "Software"), to deal in
//the Software without restriction, including without limitation the rights to
//use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//the Software, and to permit persons to whom the Software is furnished to do so,
//subject to the following conditions:
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "RADataObject.h"

@implementation RADataObject


- (id)initWithDic:(NSDictionary *)dic children:(NSArray *)children
{
    self = [super init];
    if (self) {
        self.children = [[NSMutableArray alloc] initWithArray:children];
        self.dicOrgparent = dic;
    }
    return self;
}

+ (id)dataObjectWithDic:(NSDictionary *)dic children:(NSArray *)children
{
    return [[self alloc] initWithDic:dic children:children];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@\n%@",self.dicOrgparent,self.children];
}

#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.dicOrgparent = [aDecoder decodeObjectForKey:@"dicOrgparent"];
    self.children = [aDecoder decodeObjectForKey:@"children"];
    self.isOrgparentid = [aDecoder decodeBoolForKey:@"isOrgparentid"];
    self.isPeople = [aDecoder decodeBoolForKey:@"isPeople"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_dicOrgparent forKey:@"dicOrgparent"];
    [aCoder encodeObject:_children forKey:@"children"];
    [aCoder encodeBool:_isOrgparentid forKey:@"isOrgparentid"];
    [aCoder encodeBool:_isPeople forKey:@"isPeople"];
}



@end
