//
//  AMessageParser.h
//  Aircraft
//
//  Created by Yufei Lang on 12/26/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANetMessage.h"

#define kKeyFlag            @"MSG_FLAG"
#define kKeySender          @"MSG_SENDER"
#define kKeyValue           @"MSG_VALUE"
#define kKeyCount           @"MSG_COUNT"
#define kKeyTimestamp       @"MSG_TIMESTAMP"

@interface AMessageParser : NSObject

- (ANetMessage *)parseData:(NSData *)data;
- (NSData *)prepareDictionaryMessage:(NSDictionary *)message;
- (NSData *)prepareMessage:(ANetMessage *)message;

+ (id)createInternalMsgClass:(Class)msgClass filledWithSource:(id)source;
//+ (id)createInternalMsgWithFlag:(NSString *)flag filledWithSource:(id)source;
+ (NSDictionary *)prepareInternalMsg:(id)InternalMsg;

@end

#define CREATE_INTERNAL_MSG(_class, _source)\
(_class *)[AMessageParser createInternalMsgClass:[_class class] filledWithSource:_source]

//#define CREATE_INTERNAL_MSG_FLAG(_flag, _source)\
//[AMessageParser createInternalMsgWithFlag:_flag filledWithSource:_source]

/*!
 @discussion get the value from a dictionary(_dict) according the key path(_keyPath), and set the value to _obj
 */
#define DICT_GET_OBJECT(_dict, _obj, _keyPath)\
do {\
\
id _value = [_dict valueForKeyPath:_keyPath];\
if (_value ==  [NSNull null])\
{\
_obj = nil;\
break;\
}\
if ([_value respondsToSelector:@selector(length)])\
{\
if ([(id)_value length] <= 0)\
{\
_obj = nil;\
break;\
}\
}\
\
if ([_value respondsToSelector:@selector(count)])\
{\
if ([_value isKindOfClass:[NSDictionary class]])\
{\
if ([(NSDictionary *)_value count] <= 0)\
{\
_obj = nil;\
break;\
}\
}\
else if ([_value isKindOfClass:[NSArray class]])\
{\
if ([(NSArray *)_value count] <= 0)\
{\
_obj = nil;\
break;\
}\
}\
}\
_obj = _value;\
\
} while (0)

/*!
 @discussion set the value(_obj) to a dictionary(_dict) on the given key(_key) only when the value if not nil
 */
#define DICT_SETOBJECT_IFAVAILABLE(_dict, _obj, _key)\
do {\
\
if (nil == _obj)\
{\
break;\
}\
\
if ([_obj respondsToSelector:@selector(length)])\
{\
if ([(id)_obj length] <= 0)\
{\
break;\
}\
}\
\
if ([_obj respondsToSelector:@selector(count)])\
{\
if ([_obj isKindOfClass:[NSArray class]])\
{\
if ([(NSArray *)_obj count] <= 0)\
{\
break;\
}\
}\
else if ([_obj isKindOfClass:[NSDictionary class]]) \
{\
if ([(NSDictionary *)_obj count] <= 0)\
{\
break;\
}\
}\
}\
\
[_dict setValue:(_obj) forKeyPath:(_key)];\
\
} while (0)

/*!
 @discussion set the value(_obj) to a dictionary(_dict) on the given key(_key)
 */
#define DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(_dict, _obj, _key)\
do {\
id _value = _obj;\
\
if (nil == _obj)\
{\
_value = [NSNull null];\
\
}\
\
if ([_obj respondsToSelector:@selector(length)])\
{\
if ([(id)_obj length] <= 0)\
{\
_value = [NSNull null];\
}\
}\
\
if ([_obj respondsToSelector:@selector(count)])\
{\
if ([_value isKindOfClass:[NSDictionary class]])\
{\
if ([(NSDictionary *)_value count] <= 0)\
{\
_value = [NSNull null];\
}\
}\
else if ([_value isKindOfClass:[NSArray class]])\
{\
if ([(NSArray *)_value count] <= 0)\
{\
_value = [NSNull null];\
}\
}\
}\
\
[_dict setValue:(_value) forKeyPath:(_key)];\
\
} while (0)