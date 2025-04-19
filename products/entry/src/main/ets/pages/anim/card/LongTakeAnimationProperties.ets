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

import { hilog } from '@kit.PerformanceAnalysisKit';
import { INavAnimateOptions, NavAnimationModifier, ZRouter } from 'routerapi';
import NavAnimateStatus from 'routerapi/src/main/ets/animation/const/NavAnimateStatus';
import { CardUtil } from './CardUtil';
import { ComponentAttrUtils, RectInfoInPx } from './ComponentAttrUtils';
import { WindowUtils } from './WindowUtils';


class MyAnim implements INavAnimateOptions {
  _isBeforePage: boolean = false;
  longTakeAnimationProperties: LongTakeAnimationProperties
  static readonly INIT_OVERLAY_COLOR = '#00000000';
  static readonly FINAL_OVERLAY_COLOR = '#33000000';

  constructor(longTakeAnimationProperties: LongTakeAnimationProperties) {
    this.longTakeAnimationProperties = longTakeAnimationProperties
  }

  updateModifier(modifier: NavAnimationModifier, isStart: boolean, status: NavAnimateStatus): void {
    switch (status) {
      case NavAnimateStatus.PUSH_ENTER:
        if (!this._isBeforePage) {
          if (isStart) {
            this.longTakeAnimationProperties.initParams();
            this.longTakeAnimationProperties.scaleValue = this.longTakeAnimationProperties.initScale;
            this.longTakeAnimationProperties.translateX = this.longTakeAnimationProperties.initTranslateX;
            this.longTakeAnimationProperties.clipWidth = this.longTakeAnimationProperties.initClipWidth;
            this.longTakeAnimationProperties.clipHeight = this.longTakeAnimationProperties.initClipHeight;
            this.longTakeAnimationProperties.translateY = this.longTakeAnimationProperties.initTranslateY;
            this.longTakeAnimationProperties.positionYValue = this.longTakeAnimationProperties.initPositionValueY;
            this.longTakeAnimationProperties.positionXValue = this.longTakeAnimationProperties.initPositionValueX;
          } else {
            this.longTakeAnimationProperties.scaleValue = 1.0;
            this.longTakeAnimationProperties.translateX = 0;
            this.longTakeAnimationProperties.translateY = 0;
            this.longTakeAnimationProperties.clipWidth = '100%';
            this.longTakeAnimationProperties.clipHeight = '100%';
            this.longTakeAnimationProperties.positionYValue = 0;
            this.longTakeAnimationProperties.positionXValue = 0;
            this.longTakeAnimationProperties.radius = 34;
            this.longTakeAnimationProperties.navDestinationBgColor = MyAnim.FINAL_OVERLAY_COLOR;
            this.longTakeAnimationProperties.snapShotOpacity = 0;
            this.longTakeAnimationProperties.postPageOpacity = 1.0;
          }
        }
        break
      case NavAnimateStatus.POP_EXIT:
        if (!this._isBeforePage) {
          if (isStart) {
          } else {
            this.longTakeAnimationProperties.scaleValue = this.longTakeAnimationProperties.initScale;
            this.longTakeAnimationProperties.translateX = this.longTakeAnimationProperties.initTranslateX;
            this.longTakeAnimationProperties.clipWidth = this.longTakeAnimationProperties.initClipWidth;
            this.longTakeAnimationProperties.clipHeight = this.longTakeAnimationProperties.initClipHeight;
            this.longTakeAnimationProperties.translateY = this.longTakeAnimationProperties.initTranslateY;
            this.longTakeAnimationProperties.radius = 16;
            this.longTakeAnimationProperties.positionXValue = this.longTakeAnimationProperties.initPositionValueX;
            this.longTakeAnimationProperties.positionYValue = this.longTakeAnimationProperties.initPositionValueY;
            this.longTakeAnimationProperties.navDestinationBgColor = MyAnim.INIT_OVERLAY_COLOR;
          }
        }
        break
    }
  }
}

// Encapsulate the custom mirror transition animation, so that if other interfaces also need to customize a mirror transition, they can be reused directly and reduce the workload.
@Observed
export class LongTakeAnimationProperties {
  public navDestinationBgColor: ResourceColor = MyAnim.INIT_OVERLAY_COLOR;
  public snapShotOpacity: number = 1;
  public postPageOpacity: number = 0;
  public translateX: number = 0;
  public translateY: number = 0;
  public scaleValue: number = 1;
  public clipWidth: Dimension = '100%';
  public clipHeight: Dimension = '100%';
  public radius: number = 16;
  public positionXValue: number = 0;
  public positionYValue: number = 0;
  public snapShotSize: SizeOptions = { width: '100%', height: '100%' };
  public snapShotPositionX: number = 0;
  public snapShotPositionY: number = 0;
  public animationCount: number = 0;
  public initScale: number = 1;
  public initTranslateX: number = 0;
  public initTranslateY: number = 0;
  public initClipWidth: Dimension = 0;
  public initClipHeight: Dimension = 0;
  public initPositionValueX: number = 0;
  public initPositionValueY: number = 0;
  public cardItemInfo_px: RectInfoInPx = new RectInfoInPx();
  public recoverPrePage: () => void = () => {
  };
  public clickedCardId: string = '';

  public init(prePageCardId: string, prePageOnFinish: () => void): void {
    this.clickedCardId = prePageCardId;
    this.recoverPrePage = prePageOnFinish;
    this.cardItemInfo_px = ComponentAttrUtils.getRectInfoById(WindowUtils.window.getUIContext(), prePageCardId);
  }

  public  initParams(): void {
    let postNode = WindowUtils.window.getUIContext().getFrameNodeById(CardUtil.getPostPageImageId(this.clickedCardId));
    // let postNode = WindowUtils.window.getUIContext().getFrameNodeById(this.clickedCardId);
    let postNodePositionX_vp: number = 0;
    let postNodePositionY_vp: number = 0;
    let postNodeWidth_px: number = 0;
    let postNodeHeight_px: number = 0;

    if (postNode) {
      postNodePositionX_vp = postNode.getPositionToWindowWithTransform().x;
      postNodePositionY_vp = postNode.getPositionToWindowWithTransform().y;
      postNodeWidth_px = postNode.getMeasuredSize().width;
      postNodeHeight_px = postNode.getMeasuredSize().height;
      hilog.info(0x0000, 'LongTakeAnimationProperties', 'the size is ' + postNodeWidth_px + ' and ' + postNodeHeight_px
        + ' and ' + vp2px(postNodePositionX_vp) + ' and ' + vp2px(postNodePositionY_vp));
    }

    this.initPositionValueX = -postNodePositionX_vp;
    this.initPositionValueY = -postNodePositionY_vp;
    this.snapShotPositionY = postNodePositionY_vp - px2vp(WindowUtils.topAvoidAreaHeight_px);
    this.snapShotPositionX = postNodePositionX_vp;

    // First calculate the ratio of the width and height of the card to the width and height of the window.
    this.initScale = this.cardItemInfo_px.width / postNodeWidth_px;
    if (!CardUtil.isLargeSize()) {
      this.initTranslateX = px2vp(this.cardItemInfo_px.left -
        (WindowUtils.windowWidth_px - this.cardItemInfo_px.width) / 2);
      this.initClipWidth = '100%';
      this.initClipHeight = px2vp((this.cardItemInfo_px.height) / this.initScale);
      this.snapShotSize = { width: '100%' };
      this.initTranslateY = px2vp(this.cardItemInfo_px.top -
        ((vp2px(this.initClipHeight) - vp2px(this.initClipHeight) * this.initScale) / 2));
    } else {
      this.initClipHeight = px2vp(this.cardItemInfo_px.height / this.initScale);
      this.initTranslateY = px2vp(this.cardItemInfo_px.top -
        ((vp2px(this.initClipHeight) - vp2px(this.initClipHeight) * this.initScale) / 2));
      this.initClipWidth = px2vp((this.cardItemInfo_px.width) / this.initScale);
      this.snapShotSize = { width: px2vp(postNodeWidth_px) };
      this.initTranslateX = px2vp(this.cardItemInfo_px.left -
        (WindowUtils.windowWidth_px / 2 - this.cardItemInfo_px.width / 2));
    }
    hilog.info(0x0000, 'LongTakeAnimationProperties',
      'the value is initScale: ' + this.initScale + ' initTranslateX ' + this.initTranslateX
        + ' initClipWidth ' + this.initClipWidth + ' initClipHeight ' + this.initClipHeight + ' initTranslateY '
        + this.initTranslateY + ' initPositionValue ' + this.initPositionValueY);
  }

  public doAnimation(component: object, ctx: NavDestinationContext): void {
    ZRouter.animateMgr()
      .registerAnimParam(component, ctx)
      .setEnterAnimate({ duration: 500 })
      .setExitAnimate({ duration: 500 })
      .addAnimateOptions(new MyAnim(this))
  }
}