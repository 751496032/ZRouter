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
import { WindowUtils } from "./WindowUtils";


@Component
export struct DetailPageContent {
  @Prop indexValue: number;
  @Prop SharedComponentId: string | undefined = undefined;
  @StorageProp('currentBreakpoint') @Watch('updateIsLargeSize') currentBreakpoint: string = '';
  @State isLargeSize: boolean = false;
  public onBackPressed: () => void = () => {
  };

  private updateIsLargeSize(): void {
    this.isLargeSize = (this.currentBreakpoint === 'md' || this.currentBreakpoint === 'lg');
  }

  aboutToAppear(): void {
    this.updateIsLargeSize();
  }

  @Builder
  MyTitleBuilder() {
    Row({ space: 10 }) {
      Image($r('app.media.icon_back'))
        .width(40)
        .height(40)
        .onClick(() => {
          this.onBackPressed();
        })
        .margin({ left: 20 })

      Text($r('app.string.img'))
        .height(56)
        .width('100%')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
    }
    .clip(true)
    .width('100%')
    .height(px2vp(182))
    .alignItems(VerticalAlign.Center)
  }

  build() {
    if (!this.isLargeSize) {
      Column() {
        this.MyTitleBuilder()
        Image($r(`app.media.img_${(this.indexValue % 6)}`))
          .size({ width: '100%' })
          .objectFit(ImageFit.Auto)
          .id(this.SharedComponentId)
      }
      .size({
        width: px2vp(WindowUtils.windowWidth_px),
        height: px2vp(WindowUtils.windowHeight_px)
      })
    } else {
      Column() {
        this.MyTitleBuilder()

        Stack() {
          Image($r(`app.media.img_${(this.indexValue % 6)}`))
            .size({ width: '50%' })
            .objectFit(ImageFit.Auto)
            .id(this.SharedComponentId)
        }
        .width('100%')

        Text($r('app.string.content'))
          .width('50%')
          .align(Alignment.TopStart)
          .margin({ top: 16 })
      }
      .size({
        width: px2vp(WindowUtils.windowWidth_px),
        height: px2vp(WindowUtils.windowHeight_px)
      })
    }
  }
}