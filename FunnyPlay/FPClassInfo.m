//
//  FPClassInfo.m
//  FunnyPlay
//
//  Created by admin on 9/7/13.
//  Copyright (c) 2013 admin. All rights reserved.
//

#import "FPClassInfo.h"
#import "ClassInfo.h"

@interface FPClassInfo ()
//void* _classBaseAddress;
//class_tt* classAddress;
@end

@implementation FPClassInfo

#pragma mark
#pragma mark -initialization
-(id)initWithObject:(id)obj
{   self = [super init];
    if(self){
        self.info = [[NSMutableDictionary alloc]initWithCapacity:100];
        classAddress = (class_tt*)(__bridge void*)obj;
        [self resolveClassInfo];
    }
    return self;
}

-(id)initWithClassName:(NSString*)name
{
    self = [super init];
    if(self)
    {
        self.info = [[NSMutableDictionary alloc]initWithCapacity:100];
        Class cls = NSClassFromString(name);
        classAddress = (__bridge class_tt*)cls;
        [self resolveClassInfo];
    }
    return self;
}

#pragma mark
#pragma mark public Class Methods

+(BOOL)isAClass:(void*)clss
{   class_tt* cls = (class_tt*)clss;
    if (cls &&(cls->data_NEVER_USE & ~(uintptr_t)3)) {
        class_rw_tt* rw = (class_rw_tt*)(cls->data_NEVER_USE & ~(uintptr_t)3);
        if (rw->ro && rw->ro->name) {
            return YES;
        }
    }
    return NO;
}
#pragma mark
#pragma mark Private Methods
//根据私有变量classAddress获取整个类信息
-(void)resolveClassInfo{
    self.info = [self getClass:classAddress];
}
/* cast unuse
-(void)resolveClassInfo
{
    class_rw_tt* rw = GET_CLASS_RW(classAddress);
    if(!rw)
    {
        [self.info setObject:kUnknown forKey:kClassName];
        return;
    }
    NSString *className = NSSTRING_BY_CHARS(GET_CLASS_RW(classAddress)->ro->name,classAddress);
    [self.info setObject:className forKey:kClassName];
    //兄弟节点
    class_tt* nextClass = rw->nextSiblingClass;
    if ([FPClassInfo isAClass:nextClass]) {
        NSString *className = NSSTRING_BY_CHARS(GET_CLASS_RW(nextClass)->ro->name,nextClass);
        [self.info setObject:className forKey:kNextClassName];
    }else{
        [self.info setObject:kUnknown forKey:kNextClassName];
    }
    //类链表中首子节点
    class_tt* subClass = rw->firstSubclass;
    if ([FPClassInfo isAClass:subClass]) {
        NSString *className = NSSTRING_BY_CHARS(GET_CLASS_RW(subClass)->ro->name,subClass);
        [self.info setObject:className forKey:kFirstSubClass];
    }else{
            [self.info setObject:kUnknown forKey:kFirstSubClass];
    }
    //父类节点
    class_tt* superClass = classAddress->superclass;
    if ([FPClassInfo isAClass:superClass]) {
        [self.info setObject:NSSTRING_BY_CHARS(GET_CLASS_RW(superClass)->ro->name,superClass) forKey:kSuperClass];
    }else{
        [self.info setObject:kUnknown forKey:kSuperClass];
    }
    //isa节点
    class_tt* isaClass = classAddress->isa;
    if ([FPClassInfo isAClass:isaClass]) {
     [self.info setObject:NSSTRING_BY_CHARS(GET_CLASS_RW(isaClass)->ro->name,isaClass) forKey:kIsaClass];
    }else{
        [self.info setObject:kUnknown forKey:kIsaClass];
    }
    //获取可变属性信息
    chained_property_list_t *propertyList = GET_CLASS_RW(classAddress)->properties;
    NSMutableArray* propertyArray = [[NSMutableArray alloc]init];//此处未定义数组大小，因为属性要把所有属性的大小加起来
    while (propertyList) {
        for (int i = 0; i<propertyList->count; i++) {
            property_tt *property = (property_tt*)((uint8_t*)propertyList->list +(uint32_t)(i*sizeof(property_tt)));
            NSDictionary *propertyDic = [[NSDictionary alloc]initWithObjectsAndKeys:NSSTRING_BY_CHARS(property->name, property->name),kpropertyName,NSSTRING_BY_CHARS(property->attributes, property->attributes),kpropertyAttributes, nil];
            [propertyArray addObject:propertyDic];
        }
        propertyList = propertyList->next;
    }
    [self.info setObject:propertyArray forKey:kVarProperty];
    
    //获取基础（base)属性 与上一段代码类似
    const property_list_tt* basePropertyList = GET_CLASS_RW(classAddress)->ro->baseProperties;
    NSMutableArray*basePropertyArray = [[NSMutableArray alloc]init];//此处未定义数组大小，因为属性要把所有属性的大小加起来
    if (basePropertyList) {
        for (int i = 0; i < basePropertyList->count; i++) {
            property_tt *property = (property_tt*)((uint8_t*)&(basePropertyList->first) +(uint32_t)(i*basePropertyList->entsize));
            NSDictionary *propertyDic = [[NSDictionary alloc]initWithObjectsAndKeys:NSSTRING_BY_CHARS(property->name, property->name),kpropertyName,NSSTRING_BY_CHARS(property->attributes, property->attributes),kpropertyAttributes, nil];
            [basePropertyArray addObject:propertyDic];
        }
    }
    [self.info setObject:basePropertyArray forKey:kBaseProperty];
    //获取方法列表
    method_list_tt *list = NULL;
    if (GET_CLASS_RW(classAddress)->flags & RW_METHOD_ARRAY) {
        list = *(GET_CLASS_RW(classAddress)->method_lists);
    }
    else{
        list = GET_CLASS_RW(classAddress)->method_list;
    }
    [self.info setObject:[self getMethodsByMethodList:list] forKey:kMethodList];
    const method_list_tt *rolist=NULL;
    if (GET_CLASS_RW(classAddress)->ro->flags &RW_METHOD_ARRAY) {
        rolist = *((method_list_tt**)(GET_CLASS_RW(classAddress)->ro->baseMethods));
    }else{
        rolist = GET_CLASS_RW(classAddress)->ro->baseMethods;
    }
    [self.info setObject:[self getMethodsByMethodList:rolist] forKey:@"baseMethods"];
    //[self getProtocolsInfo];
}
*/
- (void)getProtocolsInfo
{
    NSMutableArray* protocolArray = [[NSMutableArray alloc]init];
    const protocol_list_tt* protocols = (GET_CLASS_RW(classAddress)->ro->baseProtocols);
    uint32_t protocolsCount = (protocols)->count;
    for (uint32_t i=0 ; i<protocolsCount; i++) {
        protocol_tt *protocol = (protocol_tt*)((protocols)->list + i*(sizeof(protocol_tt)));
        NSDictionary* protocolDic = [NSDictionary dictionaryWithObjectsAndKeys:[self getMethodsByMethodList:protocol->instanceMethods],kInstanceMethods,[self getMethodsByMethodList:protocol->classMethods],kClassMethods,[self getMethodsByMethodList:protocol->optionalInstanceMethods],koptionalInstanceMethods,[self getMethodsByMethodList:protocol->optionalClassMethods],koptionalClassMethods,[self getPropertyByPropertyList:protocol->instanceProperties],NSSTRING_BY_CHARS(protocol->name, protocol->name),kProtocolName, nil];
        [protocolArray addObject:protocolDic];
    }
    //[self.info setObject:protocolArray forKey:kProtocols];
}

- (NSMutableArray*)getMethodsByMethodList:(const method_list_tt*)methodList
{
    method_list_tt* list = (method_list_tt*)methodList;
    NSMutableArray* methodArray = [[NSMutableArray alloc]init];
    uint32_t entsize = list->entsize_NEVER_USE & ~(uint32_t)3;
    for (uint32_t i = 0; i<list->count;i++) {
        method_tt* method= (method_tt*)((uint8_t*)&(list->first) + (uint32_t)(i*entsize));
        NSDictionary* methodDic = [NSDictionary dictionaryWithObjectsAndKeys:NSSTRING_BY_CHARS(method->name, method->name),kMethodName,NSSTRING_BY_CHARS(method->types, method->types),kMethodType,[NSString stringWithFormat:@"0x%x",(uint32_t)(method->imp)],kMethodIMP, nil];
        [methodArray addObject:methodDic];
    }
    return methodArray;
}

- (NSMutableArray*)getPropertyByPropertyList:(const property_list_tt*)propertyList
{
    property_list_tt* list = (property_list_tt*)propertyList;
    NSMutableArray *propertyArray = [[NSMutableArray alloc]init];
    if (!list) {
        return nil;
    }
    for (uint32_t i = 0; i<list->count; i++) {
        property_tt *property = (property_tt*)((uint8_t*)&(list->first) +(uint32_t)(i*list->entsize));
        NSDictionary *propertyDic = [NSDictionary dictionaryWithObjectsAndKeys:NSSTRING_BY_CHARS(property->name,property->name),kpropertyName, NSSTRING_BY_CHARS(property->attributes, property->attributes),kpropertyAttributes,nil];
        [propertyArray addObject:propertyDic];
    }
    
    return propertyArray;
}

- (NSMutableArray*)getChainedProperty:(const chained_property_list_t*)propertyList
{
    NSMutableArray* propertyArray = [[NSMutableArray alloc]init];//此处未定义数组大小，因为属性要把所有属性的大小加起来
    while (propertyList) {
        for (int i = 0; i<propertyList->count; i++) {
            property_tt *property = (property_tt*)((uint8_t*)propertyList->list +(uint32_t)(i*sizeof(property_tt)));
            NSDictionary *propertyDic = [[NSDictionary alloc]initWithObjectsAndKeys:NSSTRING_BY_CHARS(property->name, property->name),kpropertyName,NSSTRING_BY_CHARS(property->attributes, property->attributes),kpropertyAttributes, nil];
            [propertyArray addObject:propertyDic];
        }
        propertyList = propertyList->next;
    }
    return propertyArray;
}
//get class name
-(NSString*)getClassName:(class_tt*)cls
{
    if (cls &&GET_CLASS_RW(cls) && GET_CLASS_RW(cls)->ro) {
        return NSSTRING_BY_CHARS(GET_CLASS_RW(cls)->ro->name, cls);
    }
    return @"nil";
}

//class properties
- (NSMutableDictionary*)getClass:(class_tt*)cls
{
    NSString* isaclass = [self getClassName:cls->isa];
    NSString* superclass = [self getClassName:cls->superclass];
    NSString* cache = unresolvedVlaueWithAddress(cls->cache);
    NSString* imp = unresolvedVlaueWithAddress(cls->vtable);
    NSMutableDictionary* rw = [self getrw:GET_CLASS_RW(cls)];
    NSMutableDictionary* classDictinary = [[NSMutableDictionary alloc]init];
                                           /*WithObjectsAndKeys:isaclass,kIsaClass,superclass,kSuperClass,cache,kCache,imp,kVtable,rw,krw, nil];
                                            */
    [classDictinary setObject:isaclass forKey:kIsaClass];
    [classDictinary setObject:superclass forKey:kSuperClass];
    [classDictinary setObject:cache forKey:kCache];
    [classDictinary setObject:imp forKey:kVtable];
    [classDictinary setObject:rw forKey:krw];
    return classDictinary;
}

//RW properties
-(NSMutableDictionary*)getrw:(class_rw_tt*)rw
{
    NSString* flags = [NSString stringWithFormat:hexFormat,rw->flags];
    NSString* version = [NSString stringWithFormat:hexFormat,rw->version];
    NSMutableDictionary* ro = [self getro:rw->ro];
    NSMutableArray* properties = [self getChainedProperty:rw->properties];
    NSMutableArray* protocols = [self getProtocolsByProtocols2List:rw->protocols];
    NSMutableDictionary* rwDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:flags,kFlags,version,kVersion,ro,kro,properties,kProperties,protocols,kProtocols, nil];
    return rwDictionary;
}
//RO properties
-(NSMutableDictionary*)getro:(const class_ro_tt*)ro
{
    if (!ro) {
        return nil;
    }
    NSString* flags = [NSString stringWithFormat:hexFormat,ro->flags];
    NSString* start = [NSString stringWithFormat:hexFormat,ro->instanceStart];
    NSString* size = [NSString stringWithFormat:hexFormat,ro->instanceSize];
    NSString* ivar = unresolvedVlaue;
    NSString* name = NSSTRING_BY_CHARS(ro->name,ro->name);
    NSMutableArray* baseMethods = [self getMethodsByMethodList:ro->baseMethods];
    NSString* baseProtocols = unresolvedVlaue;
    NSString* ivarList = unresolvedVlaue;
    NSString* weakIvarLayout = unresolvedVlaue;
    NSMutableArray* baseProperties = [self getPropertyByPropertyList:ro->baseProperties];
    NSMutableDictionary* roDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:flags,kFlags,start,kInstanceStart,size,kinstanceSize,ivar,kIvarLayout,name,kName,baseMethods,kBaseMethods,baseProtocols,kBaseProcotols,baseProperties,kBaseProperties,ivarList,kIvars,weakIvarLayout,kWeakIvarLayout, nil];
    return roDictionary;
}

-(NSMutableArray*)getProtocolsByProtocols2List:(const protocol_list_tt**)list
{
    return nil;
}


@end
