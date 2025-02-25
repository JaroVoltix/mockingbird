//
//  MKBClassInvocationHandler.m
//  MockingbirdFramework
//
//  Created by typealias on 7/19/21.
//

#import "MKBClassInvocationHandler.h"
#import "MKBComparator.h"
#import <Mockingbird/Mockingbird-Swift.h>

@implementation MKBClassInvocationHandler

- (instancetype)initWithNext:(MKBInvocationHandler *)next
{
  return (self = [super initWithObjCType:@encode(Class)
                                    next:next
                                selector:@selector(isSubclassOfClass:)]);
}

- (MKBArgumentMatcher *)serializeArgumentAtIndex:(NSUInteger)index
                                   forInvocation:(NSInvocation *)invocation
{
  __unsafe_unretained Class value = nil;
  [invocation getArgument:&value atIndex:index];
  return [[MKBArgumentMatcher alloc] init:value
                              description:NSStringFromClass(value)
                               comparator:^BOOL(id _Nullable lhs, id _Nullable rhs) {
    if (![lhs respondsToSelector:@selector(isSubclassOfClass:)]) return false;
    return !![lhs performSelector:@selector(isSubclassOfClass:) withObject:rhs];
  }];
}

- (void)deserializeReturnValue:(id)returnValue forInvocation:(NSInvocation *)invocation
{
  Class value = returnValue;
  [invocation setReturnValue:&value];
}

@end
