/**
 * NWLogon.js
 *  
 * Phonegap MyPlugin Instance plugin
 * Copyright (c) Nimish Nayak 2011
 *
 */
var NwLogon = {
nativeFunction: function(types, success, fail) {
    return Cordova.exec(success, fail, "NwLogon", "logon", types);
}
};