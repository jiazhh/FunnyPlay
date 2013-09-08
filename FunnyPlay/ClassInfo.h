//
//  ClassInfo.h
//  FunnyPlay
//
//  Created by admin on 9/7/13.
//  Copyright (c) 2013 admin. All rights reserved.
//

#ifndef FunnyPlay_ClassInfo_h
#define FunnyPlay_ClassInfo_h


#define RW_METHOD_ARRAY 1<<18
typedef void(IMP_T)(void);

typedef struct method_tt {
    char* name;
    const char *types;
    IMP_T* imp;
}method_tt;
            
typedef struct method_list_tt {
                uint32_t entsize_NEVER_USE;  // high bits used for fixup markers
                uint32_t count;
                struct method_tt first;
} method_list_tt;

typedef struct ivar_tt {
    // *offset is 64-bit by accident even though other
    // fields restrict total instance size to 32-bit.
    uintptr_t *offset;
    const char *name;
    const char *type;
    // alignment is sometimes -1; use ivar_alignment() instead
    uint32_t alignment  __attribute__((deprecated));
    uint32_t size;
} ivar_tt;

typedef struct ivar_list_tt {
    uint32_t entsize;
    uint32_t count;
    ivar_tt first;
} ivar_list_tt;

typedef struct objc_property_tt {
    const char *name;
    const char *attributes;
} property_tt;

typedef struct property_list_tt {
    uint32_t entsize;
    uint32_t count;
    property_tt first;
} property_list_tt;

typedef struct protocol_tt {
    void* isa;
    const char *name;
    struct protocol_list_t *protocols;
    method_list_tt *instanceMethods;
    method_list_tt *classMethods;
    method_list_tt *optionalInstanceMethods;
    method_list_tt *optionalClassMethods;
    property_list_tt *instanceProperties;
    uint32_t size;   // sizeof(protocol_t)
    uint32_t flags;
    const char **extendedMethodTypes;
    
} protocol_tt;

typedef uintptr_t protocol_ref_tt;

typedef struct protocol_list_tt {
    // count is 64-bit by accident.
    uintptr_t count;
    protocol_ref_tt list[0]; // variable-size
} protocol_list_tt;

typedef struct class_ro_tt {
    uint32_t flags;
    uint32_t instanceStart;
    uint32_t instanceSize;
#ifdef __LP64__
    uint32_t reserved;
#endif
    
    const uint8_t * ivarLayout;
    
    const char * name;
    const method_list_tt * baseMethods;
    const protocol_list_tt * baseProtocols;
    const ivar_list_tt * ivars;
    
    const uint8_t * weakIvarLayout;
    const property_list_tt *baseProperties;
} class_ro_tt;


typedef struct chained_property_list_t {
    struct chained_property_list_t *next;
    uint32_t count;
    property_tt list[0];  // variable-size
} chained_property_list_t;

typedef struct class_rw_tt {
    uint32_t flags;
    uint32_t version;
    
    const class_ro_tt *ro;
    
    union {
        method_list_tt **method_lists;  // RW_METHOD_ARRAY == 1
        method_list_tt *method_list;    // RW_METHOD_ARRAY == 0
    };
    struct chained_property_list_t *properties;
    const protocol_list_tt ** protocols;
    
    struct class_tt *firstSubclass;
    struct class_tt *nextSiblingClass;
} class_rw_tt;

typedef struct class_tt {
    struct class_tt *isa;
    struct class_tt *superclass;
    void* cache;
    IMP *vtable;
    uintptr_t data_NEVER_USE;  
}class_tt;

#endif
