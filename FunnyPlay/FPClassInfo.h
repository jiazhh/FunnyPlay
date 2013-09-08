//
//  FPClassInfo.h
//  FunnyPlay
//
//  Created by admin on 9/7/13.
//  Copyright (c) 2013 admin. All rights reserved.
//

//#define __WITH_ADDRESS__
#define kClassName @"name"
#define kNextClassName @"nextClass"
#define kFirstSubClass @"firstSubClass"
#define kSuperClass     @"superClass"
#define kUnknown        @"unknown"
#define kIsaClass       @"isaClass"
#define kVarProperty       @"varProperty"
#define kBaseProperty   @"baseProperty"
#define kpropertyName   @"propertyName"
#define kpropertyAttributes  @"propertyAttributes"

#define kMethodName     @"methodName"
#define kMethodType     @"methodTypes"
#define kMethodIMP      @"methodIMP"
#define kMethods        @"methods"

#define kInstanceMethods    @"instanceMethods"
#define kClassMethods   @"classMethods"
#define koptionalInstanceMethods    @"optionalInstanceMethods"
#define koptionalClassMethods   @"classMethods"
#define kProtocolName       @"name"
#define kProtocols          @"protocols"

#define kMethodList     @"methodList"
//RW block
#define krw             @"rw"
#define kro             @"ro"
#define kFlags          @"flags"
#define kVersion        @"version"
#define kMethodList     @"methodList"
#define kProperties     @"properties"
#define kProtocols      @"protocols"
//RO block
#define kInstanceStart  @"instanceStart"
#define kinstanceSize   @"instanceSize"
#define kIvarLayout     @"ivarLayout"
#define kName           @"name"
#define kBaseMethods    @"baseMethods"
#define kBaseProcotols  @"baseProtocols"
#define kIvars          @"ivars"
#define kWeakIvarLayout @"weakIvarLayout"
#define kBaseProperties @"baseProperties"
//class block
#define kCache          @"cache"
#define kVtable          @"vtable"
#define unresolvedVlaue @"未解析字段"
#define hexFormat       @"0x%x"
#define unresolvedVlaueWithAddress(address) [NSString stringWithFormat:@"未解析(0x%x)",(uint32_t)(address)]

#define GET_CLASS_RW(class) ((class_rw_tt*)(class->data_NEVER_USE &~(uintptr_t)3))
#ifdef __WITH_ADDRESS__
#define NSSTRING_BY_CHARS(string,address) [NSString stringWithFormat:@"%s(0x%x)",string,(unsigned)address]
#else
#define NSSTRING_BY_CHARS(string,address) [NSString stringWithFormat:@"%s",string]
#endif



#import <Foundation/Foundation.h>
#import "ClassInfo.h"
@interface FPClassInfo : NSObject
{
    class_tt* classAddress;
}

@property NSMutableDictionary* info;


-(id)initWithClassName:(NSString*)name;
-(id)initWithObject:(id)obj;

+(BOOL)isAClass:(void*)clss;
@end
