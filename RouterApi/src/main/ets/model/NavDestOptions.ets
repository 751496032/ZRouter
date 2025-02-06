/**
 * @author: HZWei
 * @date: 2024/9/10
 * @desc:
 */
import { RedirectType } from './Const';
import { DEFAULT_STACK_NAME, ObjectOrNull, OnPopResultCallback } from './Model';
import { LaunchMode } from './LaunchMode';

export interface INavDestOptions<T> {
  animated: boolean;
  lunchMode: LaunchMode;
  params?: ObjectOrNull;
  navStackName: string;
  enableCrossPageParamReturn?: boolean;
  onPopListener?: OnPopResultCallback<T | ObjectOrNull>;
  redirectType?: RedirectType;
  isConvertJumpParamZeroAndFalseToString?: boolean;
}

export class NavDestOptionsImpl<T> implements INavDestOptions<T> {
  animated: boolean = true;
  lunchMode: LaunchMode = LaunchMode.STANDARD;
  navStackName: string = DEFAULT_STACK_NAME;
  redirectType: RedirectType = RedirectType.REPLACE;
  isConvertJumpParamZeroAndFalseToString: boolean = false
}