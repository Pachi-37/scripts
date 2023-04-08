# Shell Script learning

### Variable substitution
* Delete
    * `${var#parrent}` (Matching the rules at the beginning of the variables and delete the shortest data)
    * `${var##parrent}` (Matching the rules at the beginning of the variables and delete the longest data)
    * `${var%parrent}` (Matching the rules at the end of the variables and delete the shortest data)
    * `${var%%parrent}` (Matching the rules at the end of the variables and delete the longest data)
* Replace
    * `${var/old/new}` (Replace the first matching variable)
    * `${var//old/new}` (Replace all matching variables)

### Variable test
| Use | str is null | str is empty | str ! null & ! empty |
|  ----  | ----  | ---- | ---- |
| var=${str-expr} | var=expr | var= | var=$str |
| var=${str:-expr} | var=expr | var=expr | var=$str |
| var=${str+expr} | var= | var=expr | var=expr |
| var=${str:+expr} | var= | var= | var=expr |
| var=${str=expr} | var=expr | var= | var=$str |
| var=${str:=expr} | var=expr | var=expr | var=$str |
| var=${str?expr} | print | var= | var=$str |
| var=${str:?expr} | print | print | var=$str |

> `:` Variables that are empty and not set are treated the same
> `=` Both variables change at the same time(var & str)

### String
* length
    * ${#string}
    * `expr length "$string"`
        > if the string has spaces, use `"`
* index
    * `expr index "$string" substr`
* substr length
    * `expr match "$string" substr`
        > Substring matches from the beginning
* get Substring
    * `${string:position}`
    * `${string:position:length}`
    * `${string: -position}` `${string:(position)}`
    * `expr substr $string $position $length`

### Command substitution
* \`command\`
* $(command)

### Set a specific type
* `declare`
* `typeset`

### Computation
* `expr $num operator $num`
* `$((num operator num))`
* `bc` (Support float operation)

### Function
Use `.` to load function lib, if it is not in the environment variable, you need to use the absolute path
> Library files generally end in `.lib`
> Library files do not require execute permissions
> Output a warning message `/#!bin/echo`

### Find
* Search
    * `-prune` 
    > Usually used with-path
    > `find . -path ./etc -prune -o -type f`
    > `find . -path ./etc -prune -o -path ./test -prune -o -type f`
* Modify
    * `find ... -exec rm -rf {} \;`
> `locate` similar to find; Find from database file(Update db: updatedb)
> `whereis` usually used to find binary
> `which` usually used to find the absolute path of binary

### Tools
* grep
    * `-v` Show unmatched lines
    * `-i` Ignore case
    * `-n` Show line num
    * `-E` Use regex
    * `-F` Disable regex
    * `-r` recursion
    * `-c` Only show match num
    * `-w` Search word
    * `-x` Search line
    * `-l` Only dispaly file name
> `egrep` equal to `grep -E`

* sed (Stream Editor)
    * `stdout | sed [opt] "command"`
    * `sed [opt] "command" file`
    * `-n` Only print lines that match the pattern
    * `-e` Run the `sed` command on the command line, which is added by default(Multiple modes needed)
    * `-f` Call a file which save command
    * `-r` Use regex
    * `-i` Modify file
    * Parrent
        * `[_]command`
        * `[_], [_]command`
        > `[_]`(`num`, `+num`, `/pattern/`)
        > If parrent uses ', also use ' when referring to variables
    * Command
        * `p` print
        * `a` append (behind line)
        * `i` insert (before line)
        * `r` read from external file and then append
        * `w` write external file at matching line
        * `d` delete
        * `s/old/new` replace old to new 
            * `s/old/new/g` replace all
            * `s/odl/new/ig` repalce all and ignore case
        * `=` show line num
    * back reference
        * `&` represent the entire string
        * `\1` represent `()` string
* awk
    * `awk 'BEGIN{}pattern{command}END{}' file`
    * `stdout | awk 'BEGIN{}pattern{command}END{}'}'`
    * `build-in vars`
        * `$0`  whole line
        * `$1-$n` fileds
        * `NF`  number filed
        * `NR`  number row
        * `FNR` file number row
        * `FS`  filed separator
        * `RS`  row separator
        * `OFS` Output filed separator
        * `ORS` Output filed separator
        * `FILENAME`
        * `ARGC`
        * `ARGV`
    * Parrent
        * regex
        * relation operation
            * `~` match regex
            * `!~` exclude regex
    * condition judgement
        * `do-while`
        * `if-else`
    * string
        * `length(str)`
        * `index(str)`
        * `toupper(str)`
        * `split(str,arr,fs)`
        * `match(str, RE)`
        * `sub(RE, Repstr, str)`
    * option
        * `-v` parameter passing
        * `-f` use script file
        * `-F` set separator
        * `-V` version
