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

import { RouterConstants } from '@hzw/common_library';
import { CardSharedAnimationProperties, Route, SharedCardContainer, SharedCardUtil, ZRouter } from 'routerapi';
import { DetailPageContent } from './DetailPageContent';

@Builder
export function CardLongTakeTransitionPageTwoBuilder() {
  CardLongTakeTransitionPageTwo()
}

@Route({ name: RouterConstants.PAGE_CARD_TWO })
@Component
export struct CardLongTakeTransitionPageTwo {
  @State properties: CardSharedAnimationProperties = SharedCardUtil.createSharedAnimationProperties();

  onBackPressed(): boolean {
    ZRouter.getInstance().pop()
    return true;
  }

  @Builder
  Content() {
    DetailPageContent({
      onBackPressed: () => {
        this.onBackPressed()
      },
    })
      .width('100%')
      .height('100%')
  }

  build() {
    NavDestination() {
      SharedCardContainer({
        properties: this.properties,
        bgColor: $r('app.color.water_flow_background_color'),
        content: () => {
          this.Content()
        }
      })
    }
    .onReady((context: NavDestinationContext) => {
      this.properties.registerSharedCardAnim(this, context)
    })
    .onDisAppear(() => {
      ZRouter.animateMgr().unregisterAnim(this)
    })
    .hideTitleBar(true)
    .backgroundColor(Color.Transparent)
    .attributeModifier(ZRouter.animateMgr().modifier(this))
    .onBackPressed(() => {
      return this.onBackPressed();
    })
  }
}