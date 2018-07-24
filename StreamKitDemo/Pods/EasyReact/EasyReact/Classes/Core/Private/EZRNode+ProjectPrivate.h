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

#import <EasyReact/EZRNode.h>

NS_ASSUME_NONNULL_BEGIN

@class EZRSenderList;
@protocol EZRListenEdge, EZRNextReceiver;

@interface EZRNode () 

- (instancetype)initDirectly NS_DESIGNATED_INITIALIZER;

- (void)next:(nullable id)value from:(EZRSenderList *)senderList context:(nullable id)context;

@end

@interface EZRNode<T> (Listener)

- (void)addListenEdge:(id<EZRListenEdge>)listenEdge;
- (void)removeListenEdge:(id<EZRListenEdge>)listenEdge;

@end

@interface EZRNode (Transfrom)

- (id<EZRNextReceiver>)addUpstreamTransformData:(id<EZRTransformEdge>)transform;
- (void)addDownstreamTransformData:(id<EZRTransformEdge>)transform;
- (void)removeUpstreamTransformData:(id<EZRTransformEdge>)transform;
- (void)removeDownstreamTransformData:(id<EZRTransformEdge>)transform;

@end

NS_ASSUME_NONNULL_END
