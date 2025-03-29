# JustRadUtils
**Delphi IDE wizard for insert Int64 ID (YYYYMMDDhhnnss) to source code, for asserts**

### Using:
1) Install
2) Just click "Insert Int64 ID (YYYYMMDDhhnnss)" in editor menu

### Examples of use:
```pascal
if TryGetNamedSymbol(Name, Symbol) then
  WriteSymbol(Symbol)
else
  CompilerFail(20240723054605); // <- YYYYMMDDhhnnss id
```
```pascal
CompilerAssert(Declaration.Name <> nil, 20250214033529); // <- YYYYMMDDhhnnss id
```
