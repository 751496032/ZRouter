/**
 * @author: HZWei
 * @date: 2024/9/10
 * @desc:
 */
import { ObjectOrNull, OnPopResultCallback } from './Model';

export interface  INavOptions<T> {
  animated: boolean;
  lunchMode: LaunchMode;
  params?: ObjectOrNull;
  navStackName:string;
  enableCrossPageParamReturn?: boolean;
  onPopCallback?: OnPopResultCallback<T | ObjectOrNull>;
}

export class NavOptionsImpl<T> implements  INavOptions<T> {
  animated: boolean = true;
  lunchMode: LaunchMode = LaunchMode.STANDARD;
  navStackName: string = ''
}