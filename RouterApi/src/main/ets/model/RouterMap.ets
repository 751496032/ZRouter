/**
 * @author: HZWei
 * @date: 2025/8/27
 * @desc:
 */
import { RouteMetadata } from './Model'
export interface RouterMapWrapper {
  routerMap: RouteItem[];
}

export interface RouteItem {
  name:           string;
  pageSourceFile: string;
  buildFunction:  string;
  data:           RouteMetadata;
}

