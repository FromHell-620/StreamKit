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

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface EZRSenderList : NSObject

@property (nonatomic, readonly, strong) id value;
@property (nonatomic, readonly, strong) EZRSenderList *prev;

- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithSender:(id)value NS_DESIGNATED_INITIALIZER;
+ (instancetype)senderListWithSender:(id)value;
+ (instancetype)senderListWithArray:(NSArray *)array;

- (EZRSenderList *)appendNewSender:(id)value;
- (BOOL)contains:(id)obj;

@end

NS_ASSUME_NONNULL_END
