/**
 * @author: HZWei
 * @date: 2025/8/27
 * @desc:
 */

export interface RouterMapGenerator {
  routerMap: RouterMap[];
}

export interface RouterMap {
  name:           string;
  pageSourceFile: string;
  buildFunction:  string;
  data:           RouteMetadata;
}

export interface RouteMetadata {
  needLogin:    string;
  /**
   * 是一个base64编码的字符串，自行解码获取其他参数
   */
  others:       string;
  description?: string;
  extra?:       string;
}
