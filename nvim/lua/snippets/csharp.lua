local ls = require("luasnip")

return {
  ls.parser.parse_snippet(
    "nsp",
    "namespace " .. _G.calculate_csharp_namespace() .. "\n{\n    $0\n}"
  ),
}
