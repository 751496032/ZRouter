import { IProvider } from "@hzw/zrouter";

/**
 * @author: HZWei
 * @date: 2025/8/16
 * @desc:
 */
export interface IEntryService extends IProvider {

  /**
   * 在底层模块 获取首页的视图
   * @returns
   */
  getBannerView(): WrappedBuilder<[]>;
}

export interface UIView<T> {
  data: T[];
}
