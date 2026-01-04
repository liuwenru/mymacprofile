// ==UserScript==
// @name         title
// @namespace    http://tampermonkey.net/
// @version      2025-12-16
// @description  try to take over the world!
// @author       You
// @match        *://*/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=tampermonkey.net
// @grant        none
// ==/UserScript==

(function() {
    'use strict';
    // 检查 hostname 是否以 "192.168." 开头
    //if (!location.hostname.startsWith('192.168.')) {
    //    return; // 不是目标网站，直接退出
    //}
    // 获取当前域名（不带 www）
    let hostname = window.location.hostname;

    // 去掉常见的 www. 前缀（可选）
    //if (hostname.startsWith('www.')) {
    //    hostname = hostname.substring(4);
    //}

    // 直接设置标题为域名
    document.title = hostname;

    // 支持单页应用（SPA）如 React/Vue，标题变化时继续强制改回域名
    const observer = new MutationObserver(() => {
        if (document.title !== hostname) {
            document.title = hostname;
        }
    });

    observer.observe(document.querySelector('title'), {
        subtree: true,
        characterData: true,
        childList: true
    });
})();