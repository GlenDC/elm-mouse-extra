Elm.Native.MouseExtra = {};
Elm.Native.MouseExtra.make = function(localRuntime) {
  localRuntime.Native = localRuntime.Native || {};
  localRuntime.Native.MouseExtra = localRuntime.Native.MouseExtra || {};
  if (localRuntime.Native.MouseExtra.values)
  {
    return localRuntime.Native.MouseExtra.values;
  }

  return localRuntime.Native.MouseExtra.values = {
    greeting : function(name) { console.log("Hello, " + name + "!"); return name; },
  };
};