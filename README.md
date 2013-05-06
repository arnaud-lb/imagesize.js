# imagesize.js

Determines the size of an image without reading or downloading it entirely.

Implemented using an incremental parser, and can be fed multiple times with data
chunks of any size.

## Usage

```
var imagesize = require('imagesize');

imagesize(stream, function (err, result) {
  if (!err) {
    console.log(result); // {type, width, height}
  }
});
```

The first argument should be a stream emitting `data` and `end` events.

Full example:

```
var http = require('http');
var imagesize = require('imagesize');

var request = http.get('http://nodejs.org/images/logo-light.png', function (response) {
  imagesize(response, function (err, result) {
    // do something with result

    // we don't need more data
    request.abort();
  });
});
```

## Advanced usage:

You can also use the incremental parser directly:

```
var Parser = require('imagesize').Parser;
var parser = Parser();

switch (parser.parse(buffer)) {
  case Parser.EOF:
    // needs moar data
    break;
  case Parser.INVALID:
    // invalid input, abort
    break;
  case Parser.DONE:
    var result = parser.getResult();
    break;
}
```

