import { IProvider } from "./IProvider";

/**
 * @author: HZWei
 * @date: 2024/10/17
 * @desc: 服务管理类
 */
export class ServiceMgr {

    private static _instance: ServiceMgr;

    private _services: Map<string, IProvider> = new Map();

    public static get getInstance(): ServiceMgr {
        if (!this._instance) {
            this._instance = new ServiceMgr();
        }
        return this._instance;
    }


}