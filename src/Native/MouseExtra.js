Elm.Native.MouseExtra = {};
Elm.Native.MouseExtra.make = function(localRuntime) {
  localRuntime.Native = localRuntime.Native || {};
  localRuntime.Native.MouseExtra = localRuntime.Native.MouseExtra || {};
  if (localRuntime.Native.MouseExtra.values)
  {
    return localRuntime.Native.MouseExtra.values;
  }

  var NS = Elm.Native.Signal.make(localRuntime);
  var Utils = Elm.Native.Utils.make(localRuntime);

  var node = localRuntime.isFullscreen()
    ? document
    : localRuntime.node;

  function mouseKeyEvent(event) {
    return {
      _: {},
      buttonCode: event.button,
      };
  }

  function mouseKeyStream(eventName, handler) {
    var stream = NS.input(eventName, '\0');

    localRuntime.addListener([stream.id], node, eventName, function(e) {
      localRuntime.notify(stream.id, handler(e));
    });

    return stream;
  }

  // Disabling Context Menu (as it interferes with right click)
  node.addEventListener('contextmenu', function(event) {
    event.preventDefault();
  }, false);

  var downs = mouseKeyStream('mousedown', mouseKeyEvent);
  var ups = mouseKeyStream('mouseup', mouseKeyEvent)

  return localRuntime.Native.MouseExtra.values = {
    downs: downs,
    ups: ups,
  };
};