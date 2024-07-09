# learn-love
## TODO
1.  unit coordinate [-1,1]
2.  practice some animation principle, stretch, anticipation
3. Scene class
4.  rewrite classic.lua, `__index` should be carefully done

## note
- use `Array:push`, DO NOT use `Array.push`
- line
- `__index`: when the key not found in table, search the key in __index
- to debug in vscode, use `tomblind.local-lua-debugger-vscode`
- lua 5.1
- lÖve 11.5
> Conditionals (such as the ones in control structures) consider `false` and `nil` as false and `anything else` as true. Beware that, unlike some other scripting languages, Lua considers both zero and the empty string as true in conditional tests.

## ref
- [hexgrid](https://www.redblobgames.com/grids/hexagons/#pixel-to-hex)