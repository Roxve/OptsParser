# OptsParser
an option parser for nim
*(for now it cannot parse)*

## Example 1
```nim
var eParser = makeOptParser(colmunSize=13, spaceSize=2):
    setBanner("ptVoid parser!")
    addOpt("-s:text", "--say:text", "text to say"):
      text = item.value
    addOpt("-l", "--loudly", "says it loudly"):
      loud = true
    addOpt("-s", "", "short only!"):
      echo "short"
    # empty info means its hidden in showOpts
    addOpt("?s", "?secert", ""):
      echo "you found the secert option"
  eParser.showOpts() 
  eParser.parse(@["-s", "'Hello, world'", "127", "?s", "-l"])
  if loud:
    echo text.toUpper();
  else:
    echo text.toLower()
``````
the showOpts() proc echoes the options with their info
the colmunSize and spaceSize args in makeOptParser
control how the options is showen each option has 13 chars space of text and after it is 2 spaces to spilt it with
the other option (only useful if the option is 13 chars long if not the remaning chars are going to be replaced with spaces)
output:
```bash
ptVoid parser!
-s             --say          text to say
-l             --loudly       says it loudly
-s                            short only!
```

