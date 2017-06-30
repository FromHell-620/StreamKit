/*
 * Tencent is pleased to support the open source community by making
 * WCDB available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use
 * this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 *       https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "benchmark_normal.h"
#import <Foundation/Foundation.h>
int main(int argc, const char *argv[])
{
#warning TODO Perfect benchmark works
    NSString *machPath = [NSString stringWithUTF8String:argv[0]];
    NSString *baseDirectory = [[machPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"SampleDB"];
    NSLog(@"Base Directory: %@", baseDirectory);
    benchmark_normal(baseDirectory);
    return 0;
}
