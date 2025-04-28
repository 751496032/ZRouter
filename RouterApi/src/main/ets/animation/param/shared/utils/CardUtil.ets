/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

export class CardUtil {
  // 一个卡片镜像被其他图片关联，弹出页上的图片需要标记id，在此统一设置id
  public static getPostPageImageId(prePageClickedCardId: string | undefined): string | undefined {
    if (!prePageClickedCardId) {
      return undefined;
    }
    return 'Post_Page_Image' + prePageClickedCardId;
  }

  public static getFlowItemIdByIndex(index: string): string {
    return 'FlowItem_' + index;
  }

  public static isLargeSize(): boolean {
    let currentBreakPoint: string | undefined = AppStorage.get('currentBreakpoint');
    return (currentBreakPoint === 'md' || currentBreakPoint === 'lg');
  }
}