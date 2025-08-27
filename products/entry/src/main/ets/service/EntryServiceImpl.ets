/**
 * @author: HZWei
 * @date: 2025/8/16
 * @desc:
 */
import { IEntryService, RouterConstants } from "@hzw/common_library";
import { BannerBuilder } from "../views/Banner";
import { ZService } from "routerapi";

@ZService({ name: RouterConstants.SERVICE_ENTRY_IMPL })
export class EntryServiceImpl implements IEntryService {
  getBannerView(): WrappedBuilder<Object[]> {
    return wrapBuilder(BannerBuilder) as WrappedBuilder<Object[]>;
  }
}