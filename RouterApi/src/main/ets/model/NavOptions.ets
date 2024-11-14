/**
 * @author: HZWei
 * @date: 2024/9/10
 * @desc:
 */
import { DEFAULT_STACK_NAME, ObjectOrNull, OnPopResultCallback } from './Model';
import { INavAnimationOptions } from '../animation/callback/INavAnimationOptions';

export interface  INavOptions<T> {
  animated: boolean;
  animationOptions?: INavAnimationOptions;
  lunchMode: LaunchMode;
  params?: ObjectOrNull;
  navStackName:string;
  enableCrossPageParamReturn?: boolean;
  onPopListener?: OnPopResultCallback<T | ObjectOrNull>;
}

export class NavOptionsImpl<T> implements  INavOptions<T> {
  animated: boolean = true;
  lunchMode: LaunchMode = LaunchMode.STANDARD;
  navStackName: string = DEFAULT_STACK_NAME
}