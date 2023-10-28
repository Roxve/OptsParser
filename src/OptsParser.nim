import sugar
import os
type ParserException = object of CatchableError


var progArgs = commandLineParams()
type
  TType = enum
    Opt,
    String,
    Number,
    Value,
    Error
  Token = ref object
    value: string
    ttype: TType
    num: int

type opt = object
  flag: string
  longflag: string
  info: string
  code: (Token) -> int

proc newOpt(flag : string, longflag : string, info : string, code : (Token) -> int): opt=
  return opt(flag: flag, longflag: long_flag, info: info, code: code);

type OptsParser = ref object
  opts: seq[opt]
  banner: string
  colmunSize: int
  spaceSize: int


proc newOptParser*(colmunSize: int = 13, spaceSize: int = 2): OptsParser =
  var opts: seq[opt] = @[]
  var banner = "Welcome to the option parser main!"
  return OptsParser(opts: opts, banner: banner, colmunSize: colmunSize, spaceSize: spaceSize)
 
proc makeSpaces(num: int): string =
  var i = 0
  var res : string = ""
  while i != num:
    res = res & " "
    i = i + 1
  return res

proc showOpts*(self: OptsParser) =
  echo self.banner

  for opt in self.opts:
    if opt.info != "":
      var optInfo = opt.flag & makeSpaces((self.colmunSize + self.spaceSize) - opt.flag.len) & opt.longflag & makespaces((self.colmunSize + self.spaceSize) - opt.longflag.len) & opt.info
      echo optInfo
proc OptAdd*(self: OptsParser, flag: string, lflag: string = "", info: string = "",code: (Token) -> int): OptsParser = 
    var size = self.colmunSize
    if flag.len > self.colmunSize or lflag.len > self.colmunSize:
      raise ParserException.newException("flags must be less or equal to " & $size)
    self.opts.add(newOpt(flag, lflag, info,code))
    return self

template makeOptParser*(colmunSize: int = 13, spaceSize: int = 2, body: untyped): OptsParser =
  var self = newOptParser(colmunSize, spaceSize)
  proc setBanner(banner: string) =
    self.banner = banner
  template addOpt(flag: string, lflag: string = "", info: string = "",code: untyped): untyped = 
    discard self.OptAdd(flag, lflag, info, (item: Token) => (block:
      code
      0
    ))
  body
  self

proc setBanner*(self: OptsParser,ubanner: string): OptsParser = 
  self.banner = ubanner
  return self


proc newToken(value: string, ttype: TType, num: int): Token = 
  return Token(value: value, ttype: ttype, num: num)

proc isAlphabet(x: char): bool =
  return "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM".contains(x)
proc isNum(x: char): bool=
  return "1234567890".contains(x)
proc tokenize(args = progArgs): seq[Token] =
  var tokens: seq[Token] = @[]
  var x = 0
  for arg in args:
    x = x + 1
    var pos = 0
    case arg[pos]:
      of '1','2','3','4','5', '6', '7', '8', '9', '0':
        var res = "";
        while arg.len > pos and isNum(arg[pos]):
          res = res & arg[pos]
          pos = pos + 1
        tokens.add(newToken(res, TType.Number, x))
      of '-', '?':
        var res = ""
        while arg.len > pos:
          res= res & arg[pos]
          pos = pos + 1
        tokens.add(newToken(res, TType.Opt, x))

      else:
        var res = ""
        while arg.len > pos:
          res= res & arg[pos]
          pos = pos + 1
        tokens.add(newToken(res, TType.Value, x))
  return tokens

proc parse*(self: OptsParser, args=progArgs) =
  var tokens = tokenize(args)
  for token in tokens:
    echo "=> ", token.value
    echo "=> ", token.ttype

  var optLoop = 0
  for opt in self.opts:
    optLoop = optLoop + 1
    var tokenPos = 0
    var flag = opt.flag
    var lflag = opt.longflag
    var requires_val = false
    if flag.contains(':'):
      flag = flag.substr(0, flag.find(':') - 1)
      requires_val = true
    if lflag.contains(':'):
        lflag = lflag.substr(0,flag.find(':') - 1)
        requires_val = true

    while tokens.len > tokenPos:
      if tokens[tokenPos].ttype == TType.Opt and (tokens[tokenPos].value == flag or tokens[tokenPos].value == lflag):
        if requires_val:
          if tokens.len >= tokenPos and tokens[tokenPos+1].ttype != TType.Opt:
            tokenPos = tokenPos + 1
            opt.code(tokens[tokenPos])
          else:
            raise ParserException.newException("required value after " & flag);
        else: 
          discard opt.code(tokens[tokenPos])
      tokenPos = tokenPos + 1

