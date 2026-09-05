"use strict";

var s = "~~/shaders/pause-mosaic.glsl";
mp.observe_property("pause", "bool", function (a, e) {
  e ? mp.command("change-list glsl-shaders add ".concat(s)) : mp.command("change-list glsl-shaders remove ".concat(s));
});