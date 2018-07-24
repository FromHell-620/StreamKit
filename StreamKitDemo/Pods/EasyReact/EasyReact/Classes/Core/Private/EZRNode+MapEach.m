/**
 * Beijing Sankuai Online Technology Co.,Ltd (Meituan)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

#import <EasyFoundation/EasyFoundation.h>
#import "EZRMetaMacros.h"
#import "EZRNode+MapEach.h"
#import "EZRTypeDefine.h"
#import "EZRNode+Operation.h"

@implementation EZRNode (MapEach)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
- (EZRNode *)mapEach:(id (^)())block  {
#pragma clang diagnostic pop

    return [self map:^id _Nullable(EZTupleBase *tuple) {
        if (![tuple isKindOfClass:[EZTupleBase class]]) {
            EZR_THROW(EZRNodeExceptionName, EZRExceptionReason_MapEachNextValueNotTuple, nil)
        }
        if (!block) { return nil; }
#define EZR_tupleGet(_index_)       fakeTuple16. EZ_ORDINAL_AT(_index_)
#define EZR_mapBlock(_index_)       case _index_: return block(EZ_FOR_COMMA(_index_, EZR_tupleGet));
        EZTuple16 *fakeTuple16 = (EZTuple16 *)tuple;
        switch (tuple.count) {
            EZ_FOR(16, EZR_mapBlock, )
            default: return nil;
        }
    }];
}

@end
