# OptsParser
an option parser for nim
_*(for now it cannot parse)*_

## Example 1
```ni
var eParser = makeOptParser(13, 2):
    setBanner("ptVoid parser!")
    addOpt("-s", "--say", "text to say"):
      text = "passed"
    addOpt("-l", "--loudly", "says it loudly"):
      loud = true
    addOpt("-s", "", "short only!"):
      echo "short"
    # empty info means its hidden in showOpts
    addOpt("?s", "?secert", ""):
      echo "you found the secert option"

`````````
