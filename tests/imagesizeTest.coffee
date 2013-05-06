
imagesize = require '../lib/imagesize'
fs = require 'fs'

exports["test imagesize"] = (test) ->

  inputs = [
    [
      "200x100.png"
      imagesize.Parser.DONE
      "png"
      200
      100
    ]
    [
      "200x100.gif"
      imagesize.Parser.DONE
      "gif"
      200
      100
    ]
    [
      "200x100.jpg"
      imagesize.Parser.DONE
      "jpeg"
      200
      100
    ]
    [
      "246x247.png"
      imagesize.Parser.DONE
      "png"
      246
      247
    ]
    [
      "384x385.png"
      imagesize.Parser.DONE
      "png"
      384
      385
    ]
    [
      "test.gif"
      imagesize.Parser.DONE
      "gif"
      245
      66
    ]
    [
      "testAPP.jpg"
      imagesize.Parser.DONE
      "jpeg"
      300
      300
    ]
    [
      "test1pix.jpg"
      imagesize.Parser.DONE
      "jpeg"
      1
      1
    ]
    [
      "test.txt"
      imagesize.Parser.INVALID
    ]
    [
      "blank.gif"
      imagesize.Parser.EOF
    ]
  ]

  testSingleParse = (image, status, format, width, height) ->
    
    parser = imagesize.Parser()
    data = fs.readFileSync "tests/fixtures/imagesize/#{image}"
    
    retStatus = parser.parse data

    test.equal retStatus, status

    if imagesize.Parser.DONE == status

      result = parser.getResult()

      test.equal result.format, format
      test.equal result.width, width
      test.equal result.height, height

  test1byteParses = (image, status, format, width, height) ->
    
    parser = imagesize.Parser()
    fd = fs.openSync "tests/fixtures/imagesize/#{image}", "r"
    buf = new Buffer 1
    retStatus = imagesize.Parser.EOF
    
    while 0 < fs.readSync fd, buf, 0, 1, null

      retStatus = parser.parse buf

      break if imagesize.Parser.EOF != retStatus

    test.equal retStatus, status

    if imagesize.Parser.DONE == status

      result = parser.getResult()

      test.equal result.format, format
      test.equal result.width, width
      test.equal result.height, height

  for input in inputs
    testSingleParse input...
    test1byteParses input...

  test.done()

