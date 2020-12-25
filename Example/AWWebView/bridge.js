/**
 * script标签引入该js， 即可调用callApp
 * vue项目，在main.js引入该js，其他页面引入callApp即可调用callApp
 *
 * 调用方法传参 统一格式 JSON格式字符串, 使用封装好的callApp方法，直接传js对象即可，方法内部已经转换JSON字符串了
 * {actionID: 1, param: {key1: "val1", key2: someOtherVal}}
 */

const clientRegistedMethodName = "clientRegistedMethod"; // 客户端注册的js handle
const jsHandleFunctionName = "jsRegistedFunction"; // js注册的方法名称

/**
 * 处理APP调用js的请求
 * @param {*} data
 * @param {*} responseCallback
 */
function dealAppRequest(data, responseCallback) {
  console.log(data);

  // document.getElementById("text2").innerText = data;
  // 这里取出data里actionID 判断该做什么
  var dataObj = JSON.parse(data);
  if (dataObj.actionID == 1) {
    // dataObj.param 为用户信息, 这里js后续处理
  }

  // 如果需要返回结果给原生调用下面的方法
  var result = {
    info: "js执行后返回的结果",
  };
  responseCallback(JSON.stringify(result));
}

function setupWebViewJavascriptBridge(callback) {
  if (window.WebViewJavascriptBridge) {
    return callback(WebViewJavascriptBridge);
  } else if (window.WVJBCallbacks) {
    return window.WVJBCallbacks.push(callback);
  } else {
    document.addEventListener(
      "WebViewJavascriptBridgeReady",
      function () {
        return callback(WebViewJavascriptBridge);
      },
      false
    );
  }
  window.WVJBCallbacks = [callback];
  var WVJBIframe = document.createElement("iframe");
  WVJBIframe.style.display = "none";
  WVJBIframe.src = "https://__bridge_loaded__";
  document.documentElement.appendChild(WVJBIframe);
  setTimeout(function () {
    document.documentElement.removeChild(WVJBIframe);
  }, 0);
}

setupWebViewJavascriptBridge(function (bridge) {
  // 这里主要是注册 JS 方法。
  bridge.registerHandler(jsHandleFunctionName, dealAppRequest);

  // 初始化
  bridge.init(function (message, responseCallback) {
    var data = {
      "Javascript Responds": "Wee!",
    };
    responseCallback(data);
  });
});

/**
 * 调用App方法 （使用的地方 导入此函数即可）
 * @param {*} param: 参数对象,js对象即可，方法内部转换为JSON字符串，如： {actionID: 1, param: {key1: "val1", key2: someOtherVal}}
 * @param {*} cb: App执行之后的回调，类型为function(result), js处理result
 */
function callApp(param, cb) {
  if (window.WebViewJavascriptBridge) {
    window.WebViewJavascriptBridge.callHandler(
      clientRegistedMethodName,
      JSON.stringify(param),
      cb
    );
  }
}
