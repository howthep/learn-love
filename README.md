# learn-love
##
- todo: practice some animation principle
- todo: rewrite classic.lua, `__index` should be carefully done
## note
- use `Array:push`, DO NOT use `Array.push`
- `__index`: when the key not found in table, search the key in __index
- to debug in vscode, use `tomblind.local-lua-debugger-vscode`
- lua 5.1
- lÖve 11.3
> Conditionals (such as the ones in control structures) consider `false` and `nil` as false and `anything else` as true. Beware that, unlike some other scripting languages, Lua considers both zero and the empty string as true in conditional tests.