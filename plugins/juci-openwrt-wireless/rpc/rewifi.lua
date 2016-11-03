#!/usr/bin/lua

-- JUCI Lua Backend Server API
-- Copyright (c) 2016 Baozhu Zuo <zuobaozhu@gmail.com>. All rights reserved. 
-- This module is distributed under GNU GPLv3 with additional permission for signed images.
-- See LICENSE file for more details. 

local ubus = require("orange/ubus"); 
local juci = require("orange/core");


local function rewifi_scan()
        local result = {};
        local lines = {};
        result["results"] = lines;
        local stdout = juci.shell("iwpriv ra0 get_site_survey | tail -n+3");
        for line in stdout:gmatch("[^\r\n]+") do
                local channel,ssid,bssid,security,siganl,mode,extch,nt,wps,dpid= line:match("([^%s]*)%s*([^%s]*)%s*([^%s]*)%s*([^%s]*)%s*([^%s]*)%s*([^%s]*)%s*([^%s]*)%s*([^%s]*)%s*");
                local obj = {
                        ["channel"] = channel,
                        ["ssid"] = ssid,
                        ["bssid"] = bssid,
                        ["security"] = security,
                        ["siganl"] = siganl,
                };
                table.insert(lines, obj);
        end
        return result;
end

local function rewifi_connect(msg)
        return ubus.call("rewifi", "connect", msg);
end

return {
	scan = rewifi_scan,
	connect = rewifi_connect
};
