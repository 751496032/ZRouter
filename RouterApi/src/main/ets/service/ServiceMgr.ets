import { IProvider } from "./IProvider";
import LogUtil from "../utlis/LogUtil";

/**
 * @author: HZWei
 * @date: 2024/10/17
 * @desc: 服务管理类
 */
export class ServiceMgr {

    private static _instance: ServiceMgr;

    private _services: Map<string, IProvider> = new Map();

    private constructor() {
    }

    public static get instance(): ServiceMgr {
        if (!this._instance) {
            this._instance = new ServiceMgr();
        }
        return this._instance;
    }

    public addService(name: string, service: IProvider) {
        if (!this._services.has(name)) {
            this._services.set(name, service)
        } else {
            LogUtil.error(`已存在[${name}]服务`)
        }
    }

    public getService<T extends IProvider | null>(name: string): T | null {
        try {
            if (this._services.has(name)) {
                return this._services.get(name) as T
            }
        } catch (e) {
            LogUtil.error(e)
        }
        return null
    }

}