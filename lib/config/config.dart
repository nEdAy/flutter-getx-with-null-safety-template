// 开发环境
import 'env.dart';

const devBaseUrl = "https://international.v1.hitokoto.cn";

// 生产环境
// 生产环境地址禁止随意修改！！！
const prodBaseUrl = "https://v1.hitokoto.cn/";

const baseUrl = envIsDev ? devBaseUrl : prodBaseUrl;

const envIsDev = env == "DEV";
