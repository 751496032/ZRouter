import { CardUtil } from './utils/CardUtil';
import { WindowUtils } from './utils/WindowUtils';
import { ComponentAttrUtils, RectInfoInPx } from './utils/ComponentAttrUtils';
import { ZRouter } from '../../../api/Router';
import { ImageAnimationModifier, StackAnimationModifier } from '../../modifier/NavAnimationModifier';

/**
 * @author: HHBin
 * @date: 2025/4/28
 * @desc:
 */
export class CardSharedAnimationProperties {
  public stack1Modifier: StackAnimationModifier = new StackAnimationModifier();
  public stack2Modifier: StackAnimationModifier = new StackAnimationModifier();
  public stack3Modifier: StackAnimationModifier = new StackAnimationModifier();
  public imageModifier: ImageAnimationModifier = new ImageAnimationModifier();
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
  public clickedCardId: string = '';

  public registerSharedCardAnim(): void {
    let prePageCardId = ZRouter.getParamByKey(CardUtil.KEY_CLICKED_COMPONENT_ID) as string;
    if (prePageCardId) {
      this.clickedCardId = prePageCardId;
      this.cardItemInfo_px = ComponentAttrUtils.getRectInfoById(WindowUtils.window.getUIContext(), prePageCardId);
    }
  }

  public initParams(): void {
    let postNode = WindowUtils.window.getUIContext().getFrameNodeById(CardUtil.getPostPageImageId(this.clickedCardId));
    let postNodePositionX_vp: number = 0;
    let postNodePositionY_vp: number = 0;
    let postNodeWidth_px: number = 0;
    let postNodeHeight_px: number = 0;

    if (postNode) {
      postNodePositionX_vp = postNode.getPositionToWindowWithTransform().x;
      postNodePositionY_vp = postNode.getPositionToWindowWithTransform().y;
      postNodeWidth_px = postNode.getMeasuredSize().width;
      postNodeHeight_px = postNode.getMeasuredSize().height;
    }

    this.initPositionValueX = -postNodePositionX_vp;
    this.initPositionValueY = -postNodePositionY_vp + px2vp(WindowUtils.topAvoidAreaHeight_px);
    this.snapShotPositionY = postNodePositionY_vp - px2vp(WindowUtils.topAvoidAreaHeight_px);
    this.snapShotPositionX = postNodePositionX_vp;

    // 计算卡片的宽高与窗口的宽高之比。
    this.initScale = this.cardItemInfo_px.width / postNodeWidth_px;
    if (!CardUtil.isLargeSize()) {
      this.initTranslateX = px2vp(this.cardItemInfo_px.left -
        (WindowUtils.windowWidth_px - this.cardItemInfo_px.width) / 2);
      this.initClipWidth = '100%';
      this.initClipHeight = px2vp((this.cardItemInfo_px.height) / this.initScale);
      this.snapShotSize = { width: '100%' };
      this.initTranslateY = px2vp(this.cardItemInfo_px.top -
        ((vp2px(this.initClipHeight) - vp2px(this.initClipHeight) * this.initScale) / 2) -
      WindowUtils.topAvoidAreaHeight_px);
    } else {
      this.initClipHeight = px2vp(this.cardItemInfo_px.height / this.initScale);
      this.initTranslateY = px2vp(this.cardItemInfo_px.top -
        ((vp2px(this.initClipHeight) - vp2px(this.initClipHeight) * this.initScale) / 2) -
      WindowUtils.topAvoidAreaHeight_px);
      this.initClipWidth = px2vp((this.cardItemInfo_px.width) / this.initScale);
      this.snapShotSize = { width: px2vp(postNodeWidth_px) };
      this.initTranslateX = px2vp(this.cardItemInfo_px.left -
        (WindowUtils.windowWidth_px / 2 - this.cardItemInfo_px.width / 2));
    }
  }
}