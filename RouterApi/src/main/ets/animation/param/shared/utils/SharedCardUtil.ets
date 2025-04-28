import { CardSharedAnimationProperties } from '../CardSharedAnimationProperties';
import { CardUtil } from './CardUtil';
import { WindowUtils } from './WindowUtils';

/**
 * @author: HHBin
 * @date: 2025/4/28
 * @desc:
 */
export class SharedCardUtil {
  public static createSharedAnimationProperties(): CardSharedAnimationProperties {
    return new CardSharedAnimationProperties();
  }

  public static getPostPageImageId(prePageClickedCardId: string | undefined): string | undefined {
    return CardUtil.getPostPageImageId(prePageClickedCardId);
  }

  public static getFlowItemIdByIndex(index: string): string {
    return CardUtil.getFlowItemIdByIndex(index);
  }

  public static getWindowWidthPx(): number {
    return WindowUtils.windowWidth_px
  }

  public static getWindowHeightPx(): number {
    return WindowUtils.windowHeight_px
  }

  public static getTopAvoidAreaHeightPx(): number {
    return WindowUtils.topAvoidAreaHeight_px
  }

  public static getNavigationIndicatorHeightPx(): number {
    return WindowUtils.navigationIndicatorHeight_px
  }
}