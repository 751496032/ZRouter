/**
 * @author: HZWei
 * @date: 2025/8/27
 * @desc:
 */
import { RouteMetadata } from './Model'
export interface RouterMapGenerator {
  routerMap: RouterMap[];
}

export interface RouterMap {
  name:           string;
  pageSourceFile: string;
  buildFunction:  string;
  data:           RouteMetadata;
}

