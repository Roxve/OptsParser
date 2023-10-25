import sugar
type ParserException = object of ValueError


type opt = object
  flag: string
  longflag: string
  info: string
  code: (Exception) -> int
proc newOpt(flag : string, longflag : string, info : string, code : (Exception) -> int): opt=
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
proc OptAdd*(self: OptsParser, flag: string, lflag: string = "", info: string = "",code: (Exception) -> int): OptsParser = 
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
    discard self.OptAdd(flag, lflag, info, (e: Exception) => (block:
      code
      0
    ))
  body
  self

proc setBanner*(self: OptsParser,ubanner: string): OptsParser = 
  self.banner = ubanner
  return self
