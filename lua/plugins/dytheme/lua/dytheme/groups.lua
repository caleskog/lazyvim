local M = {}

---@param c DyPalette
function M.apply(c)
  local blend = require("dytheme.util").blend

  -- Diff colors now come directly from DyPalette.
  -- Only derive the headline tints that have no DyPalette slot.
  local d = {
    hi_blue = blend(c.bg_surface, c.primary, 0.18),
    hi_magenta = blend(c.bg_surface, c.secondary, 0.18),
    hi_green = blend(c.bg_surface, c.success, 0.18),
  }

  local function hi(groups)
    for name, opts in pairs(groups) do
      vim.api.nvim_set_hl(0, name, opts)
    end
  end

  -- ── 1. Base editor ───────────────────────────────────────────────────────
  hi({
    Normal = { fg = c.fg, bg = c.bg },
    NormalNC = { fg = c.fg_muted, bg = c.bg },
    NormalFloat = { fg = c.on_floating, bg = c.bg_floating },
    FloatBorder = { fg = c.primary, bg = c.bg_floating },
    FloatTitle = { fg = c.primary, bg = c.bg_floating, bold = true },
    FloatFooter = { fg = c.fg_muted, bg = c.bg_floating },
    -- NormalFloat = { fg = c.fg, bg = c.bg },
    -- FloatBorder = { fg = c.primary, bg = c.bg },
    -- FloatTitle = { fg = c.primary, bg = c.bg, bold = true },
    -- FloatFooter = { fg = c.fg_muted, bg = c.bg },

    CursorLine = { bg = c.bg_cursorline },
    CursorColumn = { bg = c.bg_cursorline },
    CursorLineNr = { fg = c.indicator, bold = true },
    LineNr = { fg = c.fg_muted },
    LineNrAbove = { link = "LineNr" },
    LineNrBelow = { link = "LineNr" },
    SignColumn = { bg = c.bg },
    ColorColumn = { bg = c.bg_surface },

    VertSplit = { fg = c.border },
    WinSeparator = { link = "VertSplit" },

    Folded = { fg = c.fg_muted, bg = c.bg_surface },
    FoldColumn = { fg = c.fg_muted, bg = c.bg },

    Visual = { bg = c.visual },
    VisualNOS = { link = "Visual" },
    Search = { fg = c.match_fg, bg = c.bg_match },
    IncSearch = { fg = c.match_fg, bg = c.bg_search },
    CurSearch = { link = "IncSearch" },
    Substitute = { fg = c.on_error, bg = c.error },

    Pmenu = { fg = c.on_surface, bg = c.bg_surface },
    PmenuSel = { fg = c.on_primary, bg = c.primary },
    PmenuSbar = { bg = c.bg_surface },
    PmenuThumb = { bg = c.border },
    PmenuKind = { link = "Pmenu" },
    PmenuKindSel = { link = "PmenuSel" },
    PmenuExtra = { fg = c.fg_muted, bg = c.bg_surface },
    PmenuExtraSel = { link = "PmenuSel" },

    StatusLine = { fg = c.fg, bg = c.bg_statusline },
    StatusLineNC = { fg = c.fg_muted, bg = c.bg_statusline },
    TabLine = { fg = c.fg_muted, bg = c.bg_surface },
    TabLineSel = { fg = c.fg, bg = c.bg, bold = true },
    TabLineFill = { bg = c.bg_surface },
    WinBar = { fg = c.fg_muted, bg = c.bg },
    WinBarNC = { fg = c.fg_muted, bg = c.bg },

    MatchParen = { fg = c.syntax_constant, bold = true, underline = true },
    Conceal = { fg = c.fg_muted },
    SpecialKey = { fg = c.fg_muted },
    NonText = { fg = c.fg_nontext },
    Whitespace = { fg = c.border },
    EndOfBuffer = { fg = c.bg },

    SpellBad = { undercurl = true, sp = c.error },
    SpellCap = { undercurl = true, sp = c.syntax_type },
    SpellRare = { undercurl = true, sp = c.syntax_escape },
    SpellLocal = { undercurl = true, sp = c.success },

    Question = { fg = c.primary },
    MoreMsg = { fg = c.success },
    ModeMsg = { fg = c.fg, bold = true },
    WarningMsg = { fg = c.warning },
    ErrorMsg = { fg = c.error },

    Directory = { fg = c.primary },
    Title = { fg = c.primary, bold = true },
    QuickFixLine = { bg = c.bg_highlight, bold = true },
    qfLineNr = { link = "LineNr" },
    qfFileName = { link = "Directory" },
  })

  -- ── 2. Syntax (classic groups — Treesitter links to these) ───────────────
  hi({
    Comment = { fg = c.syntax_comment, italic = true },

    Constant = { fg = c.syntax_constant },
    String = { fg = c.syntax_string },
    Character = { link = "String" },
    Number = { fg = c.syntax_constant },
    Float = { link = "Number" },
    Boolean = { fg = c.syntax_constant },

    Identifier = { fg = c.fg },
    Function = { fg = c.syntax_function },

    Statement = { fg = c.syntax_keyword },
    Conditional = { link = "Statement" },
    Repeat = { link = "Statement" },
    Label = { link = "Statement" },
    Keyword = { fg = c.syntax_keyword, bold = true },
    Exception = { fg = c.error },

    Operator = { fg = c.syntax_escape },
    PreProc = { fg = c.syntax_variable },
    Include = { link = "PreProc" },
    Define = { link = "PreProc" },
    Macro = { link = "PreProc" },
    PreCondit = { link = "PreProc" },

    Type = { fg = c.syntax_type },
    StorageClass = { link = "Type" },
    Structure = { link = "Type" },
    Typedef = { link = "Type" },

    Special = { fg = c.syntax_escape },
    SpecialChar = { link = "Special" },
    Tag = { link = "Special" },
    Delimiter = { fg = c.syntax_punctuation },
    SpecialComment = { fg = c.syntax_comment, italic = true },
    Debug = { fg = c.syntax_constant },

    Underlined = { fg = c.primary, underline = true },
    Ignore = { fg = c.fg_muted },
    Error = { fg = c.error },
    Todo = { fg = c.syntax_type, bold = true, reverse = true },
  })

  -- ── 3. Treesitter ─────────────────────────────────────────────────────────
  hi({
    ["@comment"] = { link = "Comment" },
    ["@comment.documentation"] = { fg = c.syntax_comment, italic = true },

    ["@string"] = { link = "String" },
    ["@string.escape"] = { fg = c.syntax_escape },
    ["@string.special"] = { link = "SpecialChar" },
    ["@string.regex"] = { fg = c.syntax_escape },

    ["@number"] = { link = "Number" },
    ["@float"] = { link = "Float" },
    ["@boolean"] = { link = "Boolean" },

    ["@keyword"] = { link = "Keyword" },
    ["@keyword.return"] = { fg = c.error },
    ["@keyword.operator"] = { link = "Operator" },
    ["@keyword.import"] = { link = "Include" },
    ["@keyword.coroutine"] = { fg = c.syntax_keyword, italic = true },
    ["@keyword.exception"] = { link = "Exception" },

    ["@function"] = { link = "Function" },
    ["@function.builtin"] = { fg = c.syntax_escape },
    ["@function.call"] = { link = "Function" },
    ["@function.macro"] = { link = "Macro" },
    ["@function.method"] = { link = "Function" },
    ["@function.method.call"] = { link = "Function" },

    ["@constructor"] = { fg = c.syntax_function },
    ["@parameter"] = { fg = c.syntax_constant },
    ["@variable"] = { link = "Identifier" },
    ["@variable.builtin"] = { fg = c.syntax_variable },
    ["@variable.member"] = { fg = c.syntax_escape },
    ["@variable.parameter"] = { link = "@parameter" },

    ["@type"] = { link = "Type" },
    ["@type.builtin"] = { fg = c.syntax_type, italic = true },
    ["@type.definition"] = { link = "Typedef" },
    ["@type.qualifier"] = { link = "Type" },

    ["@field"] = { fg = c.syntax_escape },
    ["@property"] = { link = "@field" },
    ["@attribute"] = { fg = c.syntax_type },
    ["@namespace"] = { fg = c.syntax_function, italic = true },
    ["@module"] = { link = "@namespace" },

    ["@operator"] = { link = "Operator" },
    ["@punctuation.bracket"] = { fg = c.syntax_punctuation },
    ["@punctuation.delimiter"] = { fg = c.syntax_punctuation },
    ["@punctuation.special"] = { fg = c.syntax_escape },

    ["@tag"] = { fg = c.syntax_variable },
    ["@tag.attribute"] = { fg = c.syntax_type },
    ["@tag.delimiter"] = { fg = c.border },

    ["@text"] = { link = "Normal" },
    ["@text.title"] = { link = "Title" },
    ["@text.strong"] = { bold = true },
    ["@text.emphasis"] = { italic = true },
    ["@text.underline"] = { underline = true },
    ["@text.strike"] = { strikethrough = true },
    ["@text.literal"] = { fg = c.syntax_string },
    ["@text.uri"] = { fg = c.url, underline = true },
    ["@text.todo"] = { link = "Todo" },
    ["@text.warning"] = { link = "WarningMsg" },
    ["@text.danger"] = { link = "ErrorMsg" },
    ["@text.reference"] = { fg = c.primary },
    ["@text.diff.add"] = { link = "DiffAdd" },
    ["@text.diff.delete"] = { link = "DiffDelete" },

    ["@markup.heading"] = { link = "Title" },
    ["@markup.strong"] = { bold = true },
    ["@markup.italic"] = { italic = true },
    ["@markup.strikethrough"] = { strikethrough = true },
    ["@markup.underline"] = { underline = true },
    ["@markup.raw"] = { fg = c.syntax_string },
    ["@markup.link"] = { fg = c.primary },
    ["@markup.link.url"] = { fg = c.url, underline = true },
    ["@markup.link.label"] = { fg = c.primary },
    ["@markup.list"] = { fg = c.syntax_keyword },
    ["@markup.list.checked"] = { fg = c.success },
    ["@markup.list.unchecked"] = { fg = c.fg_muted },
  })

  -- ── 4. LSP semantic tokens ────────────────────────────────────────────────
  hi({
    ["@lsp.type.class"] = { link = "@type" },
    ["@lsp.type.comment"] = { link = "@comment" },
    ["@lsp.type.decorator"] = { link = "@attribute" },
    ["@lsp.type.enum"] = { link = "@type" },
    ["@lsp.type.enumMember"] = { link = "@field" },
    ["@lsp.type.event"] = { link = "@field" },
    ["@lsp.type.function"] = { link = "@function" },
    ["@lsp.type.interface"] = { link = "@type" },
    ["@lsp.type.keyword"] = { link = "@keyword" },
    ["@lsp.type.macro"] = { link = "@function.macro" },
    ["@lsp.type.method"] = { link = "@function.method" },
    ["@lsp.type.modifier"] = { link = "@type.qualifier" },
    ["@lsp.type.namespace"] = { link = "@namespace" },
    ["@lsp.type.number"] = { link = "@number" },
    ["@lsp.type.operator"] = { link = "@operator" },
    ["@lsp.type.parameter"] = { link = "@parameter" },
    ["@lsp.type.property"] = { link = "@property" },
    ["@lsp.type.regexp"] = { link = "@string.regex" },
    ["@lsp.type.string"] = { link = "@string" },
    ["@lsp.type.struct"] = { link = "@type" },
    ["@lsp.type.type"] = { link = "@type" },
    ["@lsp.type.typeParameter"] = { link = "@type" },
    ["@lsp.type.variable"] = { link = "@variable" },
    ["@lsp.mod.deprecated"] = { strikethrough = true },
    ["@lsp.mod.readonly"] = { italic = true },
    ["@lsp.mod.static"] = { italic = true },

    LspReferenceText = { bg = c.bg_highlight },
    LspReferenceRead = { bg = c.bg_highlight },
    LspReferenceWrite = { bg = c.bg_highlight, bold = true },
    LspReferenceTarget = { bg = c.bg_highlight, reverse = true },
    LspSignatureActiveParameter = { fg = c.syntax_constant, bold = true },
    LspInfoBorder = { link = "FloatBorder" },
    LspCodeLens = { fg = c.fg_muted, italic = true },
    LspCodeLensSeparator = { fg = c.border },
    LspInlayHint = { fg = c.fg_muted },
  })

  -- ── 5. Diagnostics ────────────────────────────────────────────────────────
  hi({
    DiagnosticError = { fg = c.error },
    DiagnosticWarn = { fg = c.warning },
    DiagnosticInfo = { fg = c.info },
    DiagnosticHint = { fg = c.hint },
    DiagnosticOk = { fg = c.success },
    DiagnosticUnnecessary = { fg = c.fg_muted, italic = true },
    DiagnosticDeprecated = { fg = c.fg_muted, strikethrough = true },

    DiagnosticUnderlineError = { undercurl = true, sp = c.error },
    DiagnosticUnderlineWarn = { undercurl = true, sp = c.warning },
    DiagnosticUnderlineInfo = { undercurl = true, sp = c.info },
    DiagnosticUnderlineHint = { undercurl = true, sp = c.hint },

    DiagnosticVirtualTextError = { fg = c.error, bg = c.bg_surface, italic = true },
    DiagnosticVirtualTextWarn = { fg = c.warning, bg = c.bg_surface, italic = true },
    DiagnosticVirtualTextInfo = { fg = c.info, bg = c.bg_surface, italic = true },
    DiagnosticVirtualTextHint = { fg = c.hint, bg = c.bg_surface, italic = true },

    DiagnosticSignError = { link = "DiagnosticError" },
    DiagnosticSignWarn = { link = "DiagnosticWarn" },
    DiagnosticSignInfo = { link = "DiagnosticInfo" },
    DiagnosticSignHint = { link = "DiagnosticHint" },

    DiagnosticFloatingError = { link = "DiagnosticError" },
    DiagnosticFloatingWarn = { link = "DiagnosticWarn" },
    DiagnosticFloatingInfo = { link = "DiagnosticInfo" },
    DiagnosticFloatingHint = { link = "DiagnosticHint" },
  })

  -- ── 6. Git ────────────────────────────────────────────────────────────────
  hi({
    DiffAdd = { fg = c.success, bg = c.diff_add },
    DiffChange = { fg = c.warning, bg = c.diff_change },
    DiffDelete = { fg = c.error, bg = c.diff_delete },
    DiffText = { fg = c.syntax_constant, bg = c.diff_text, bold = true },
    Added = { link = "DiffAdd" },
    Changed = { link = "DiffChange" },
    Removed = { link = "DiffDelete" },
  })

  -- ── 7. gitsigns.nvim ──────────────────────────────────────────────────────
  hi({
    GitSignsAdd = { fg = c.success },
    GitSignsChange = { fg = c.warning },
    GitSignsDelete = { fg = c.error },

    GitSignsAddNr = { link = "GitSignsAdd" },
    GitSignsChangeNr = { link = "GitSignsChange" },
    GitSignsDeleteNr = { link = "GitSignsDelete" },
    GitSignsAddLn = { link = "DiffAdd" },
    GitSignsChangeLn = { link = "DiffChange" },
    GitSignsDeleteLn = { link = "DiffDelete" },

    GitSignsCurrentLineBlame = { fg = c.fg_muted, italic = true },
    GitSignsAddInline = { fg = c.bg, bg = c.success },
    GitSignsDeleteInline = { fg = c.bg, bg = c.error },
    GitSignsChangeInline = { fg = c.bg, bg = c.warning },
  })

  -- ── 8. Telescope ──────────────────────────────────────────────────────────
  hi({
    TelescopeNormal = { fg = c.fg, bg = c.bg_surface },
    TelescopeBorder = { fg = c.border, bg = c.bg_surface },
    TelescopePromptNormal = { fg = c.fg, bg = c.bg_highlight },
    TelescopePromptBorder = { fg = c.primary, bg = c.bg_highlight },
    TelescopePromptTitle = { fg = c.on_primary, bg = c.primary, bold = true },
    TelescopePreviewTitle = { fg = c.bg, bg = c.success, bold = true },
    TelescopeResultsTitle = { fg = c.border, bg = c.bg_surface },
    TelescopeSelection = { bg = c.selection },
    TelescopeSelectionCaret = { fg = c.primary, bg = c.selection },
    TelescopeMultiSelection = { fg = c.syntax_escape, bg = c.selection },
    TelescopeMatching = { fg = c.match_fg, bold = true },
    TelescopePromptPrefix = { fg = c.primary },
    TelescopePromptCounter = { fg = c.fg_muted },
    TelescopePreviewLine = { link = "CursorLine" },
    TelescopePreviewMatch = { link = "Search" },
  })

  -- ── 9. fzf-lua ────────────────────────────────────────────────────────────
  hi({
    FzfLuaNormal = { link = "NormalFloat" },
    FzfLuaBorder = { link = "FloatBorder" },
    FzfLuaTitle = { link = "FloatTitle" },
    FzfLuaPreviewNormal = { link = "NormalFloat" },
    FzfLuaPreviewBorder = { link = "FloatBorder" },
    FzfLuaPreviewTitle = { link = "FloatTitle" },
    FzfLuaCursorLine = { link = "CursorLine" },
    FzfLuaSearch = { link = "Search" },
    FzfLuaSel = { fg = c.on_primary, bg = c.primary },
    FzfLuaSelMulti = { fg = c.bg, bg = c.syntax_escape },
    FzfLuaHeader = { fg = c.success, bold = true },
    FzfLuaHeaderBind = { fg = c.match_fg },
  })

  -- ── 10. nvim-cmp ──────────────────────────────────────────────────────────
  hi({
    CmpItemAbbr = { fg = c.fg },
    CmpItemAbbrMatch = { fg = c.primary, bold = true },
    CmpItemAbbrMatchFuzzy = { fg = c.syntax_escape, bold = true },
    CmpItemAbbrDeprecated = { fg = c.fg_muted, strikethrough = true },
    CmpItemMenu = { fg = c.fg_muted, italic = true },
    CmpGhostText = { fg = c.fg_muted, italic = true },

    CmpItemKindText = { link = "String" },
    CmpItemKindMethod = { link = "Function" },
    CmpItemKindFunction = { link = "Function" },
    CmpItemKindConstructor = { link = "Function" },
    CmpItemKindField = { link = "@field" },
    CmpItemKindVariable = { link = "Identifier" },
    CmpItemKindClass = { link = "Type" },
    CmpItemKindInterface = { link = "Type" },
    CmpItemKindModule = { link = "@namespace" },
    CmpItemKindProperty = { link = "@property" },
    CmpItemKindUnit = { link = "Number" },
    CmpItemKindValue = { link = "Constant" },
    CmpItemKindEnum = { link = "Type" },
    CmpItemKindKeyword = { link = "Keyword" },
    CmpItemKindSnippet = { fg = c.syntax_string },
    CmpItemKindColor = { fg = c.syntax_constant },
    CmpItemKindFile = { link = "Directory" },
    CmpItemKindReference = { link = "@text.reference" },
    CmpItemKindFolder = { link = "Directory" },
    CmpItemKindEnumMember = { link = "@field" },
    CmpItemKindConstant = { link = "Constant" },
    CmpItemKindStruct = { link = "Structure" },
    CmpItemKindEvent = { fg = c.secondary },
    CmpItemKindOperator = { link = "Operator" },
    CmpItemKindTypeParameter = { link = "Type" },
    CmpItemKindCopilot = { fg = c.fg_muted },
  })

  -- ── 11. blink.cmp ─────────────────────────────────────────────────────────
  hi({
    BlinkCmpMenu = { link = "Pmenu" },
    BlinkCmpMenuBorder = { link = "FloatBorder" },
    BlinkCmpMenuSelection = { link = "PmenuSel" },
    BlinkCmpScrollBarThumb = { link = "PmenuThumb" },
    BlinkCmpScrollBarGutter = { link = "PmenuSbar" },
    BlinkCmpLabel = { link = "CmpItemAbbr" },
    BlinkCmpLabelMatch = { link = "CmpItemAbbrMatch" },
    BlinkCmpLabelDeprecated = { link = "CmpItemAbbrDeprecated" },
    BlinkCmpGhostText = { link = "CmpGhostText" },
    BlinkCmpDoc = { link = "NormalFloat" },
    BlinkCmpDocBorder = { link = "FloatBorder" },
    BlinkCmpDocSeparator = { link = "FloatBorder" },
    BlinkCmpSignatureHelp = { link = "NormalFloat" },
    BlinkCmpSignatureHelpBorder = { link = "FloatBorder" },
    BlinkCmpKindText = { link = "CmpItemKindText" },
    BlinkCmpKindMethod = { link = "CmpItemKindMethod" },
    BlinkCmpKindFunction = { link = "CmpItemKindFunction" },
    BlinkCmpKindConstructor = { link = "CmpItemKindConstructor" },
    BlinkCmpKindField = { link = "CmpItemKindField" },
    BlinkCmpKindVariable = { link = "CmpItemKindVariable" },
    BlinkCmpKindClass = { link = "CmpItemKindClass" },
    BlinkCmpKindInterface = { link = "CmpItemKindInterface" },
    BlinkCmpKindModule = { link = "CmpItemKindModule" },
    BlinkCmpKindProperty = { link = "CmpItemKindProperty" },
    BlinkCmpKindKeyword = { link = "CmpItemKindKeyword" },
    BlinkCmpKindSnippet = { link = "CmpItemKindSnippet" },
    BlinkCmpKindEnum = { link = "CmpItemKindEnum" },
    BlinkCmpKindEnumMember = { link = "CmpItemKindEnumMember" },
    BlinkCmpKindConstant = { link = "CmpItemKindConstant" },
    BlinkCmpKindStruct = { link = "CmpItemKindStruct" },
    BlinkCmpKindTypeParameter = { link = "CmpItemKindTypeParameter" },
    BlinkCmpKindOperator = { link = "CmpItemKindOperator" },
    BlinkCmpKindReference = { link = "CmpItemKindReference" },
    BlinkCmpKindEvent = { link = "CmpItemKindEvent" },
    BlinkCmpKindCopilot = { link = "CmpItemKindCopilot" },
    BlinkCmpKindColor = { link = "CmpItemKindColor" },
    BlinkCmpKindFile = { link = "CmpItemKindFile" },
    BlinkCmpKindFolder = { link = "CmpItemKindFolder" },
  })

  -- ── 12. which-key.nvim ────────────────────────────────────────────────────
  hi({
    WhichKey = { fg = c.syntax_escape },
    WhichKeyGroup = { fg = c.primary },
    WhichKeyDesc = { fg = c.fg },
    WhichKeySeparator = { fg = c.fg_muted },
    WhichKeyFloat = { link = "NormalFloat" },
    WhichKeyBorder = { link = "FloatBorder" },
    WhichKeyTitle = { link = "FloatTitle" },
    WhichKeyValue = { fg = c.fg_muted },
    WhichKeyIcon = { fg = c.match_fg },
  })

  -- ── 13. neo-tree ──────────────────────────────────────────────────────────
  hi({
    NeoTreeNormal = { fg = c.fg, bg = c.bg_surface },
    NeoTreeNormalNC = { fg = c.fg_muted, bg = c.bg_surface },
    NeoTreeEndOfBuffer = { fg = c.bg_surface, bg = c.bg_surface },
    NeoTreeCursorLine = { link = "CursorLine" },
    NeoTreeVertSplit = { link = "VertSplit" },
    NeoTreeWinSeparator = { link = "WinSeparator" },
    NeoTreeStatusLine = { link = "StatusLine" },
    NeoTreeStatusLineNC = { link = "StatusLineNC" },

    NeoTreeRootName = { fg = c.primary, bold = true },
    NeoTreeDirectoryName = { link = "Directory" },
    NeoTreeDirectoryIcon = { link = "Directory" },
    NeoTreeFileName = { fg = c.fg },
    NeoTreeFileNameOpened = { fg = c.primary },
    NeoTreeFileIcon = { fg = c.fg_muted },
    NeoTreeSymbolicLinkTarget = { fg = c.url, italic = true },

    NeoTreeGitAdded = { fg = c.success },
    NeoTreeGitConflict = { fg = c.error, bold = true },
    NeoTreeGitDeleted = { fg = c.error },
    NeoTreeGitIgnored = { fg = c.fg_muted },
    NeoTreeGitModified = { fg = c.warning },
    NeoTreeGitUnstaged = { link = "NeoTreeGitModified" },
    NeoTreeGitUntracked = { fg = c.syntax_constant },
    NeoTreeGitStaged = { link = "NeoTreeGitAdded" },

    NeoTreeIndentMarker = { fg = c.border },
    NeoTreeExpander = { fg = c.border },
    NeoTreeTitleBar = { fg = c.on_primary, bg = c.primary },
    NeoTreeFloatBorder = { link = "FloatBorder" },
    NeoTreeFloatTitle = { link = "FloatTitle" },

    NeoTreeDimText = { fg = c.fg_muted },
    NeoTreeFilterTerm = { fg = c.match_fg, bold = true },
    NeoTreeModified = { fg = c.warning },
    NeoTreeTabActive = { link = "TabLineSel" },
    NeoTreeTabInactive = { link = "TabLine" },
    NeoTreeTabSeparatorActive = { fg = c.primary, bg = c.bg },
    NeoTreeTabSeparatorInactive = { fg = c.border, bg = c.bg_surface },
  })

  -- ── 14. nvim-tree ─────────────────────────────────────────────────────────
  hi({
    NvimTreeNormal = { link = "NeoTreeNormal" },
    NvimTreeNormalNC = { link = "NeoTreeNormalNC" },
    NvimTreeFolderName = { link = "Directory" },
    NvimTreeRootFolder = { fg = c.primary, bold = true },
    NvimTreeFolderIcon = { link = "Directory" },
    NvimTreeFileIcon = { fg = c.fg_muted },
    NvimTreeFileName = { fg = c.fg },
    NvimTreeOpenedFile = { fg = c.primary },
    NvimTreeExecFile = { fg = c.success, bold = true },
    NvimTreeSpecialFile = { fg = c.match_fg },
    NvimTreeSymlink = { fg = c.url, italic = true },
    NvimTreeGitDirty = { link = "NeoTreeGitModified" },
    NvimTreeGitStaged = { link = "NeoTreeGitAdded" },
    NvimTreeGitNew = { link = "NeoTreeGitUntracked" },
    NvimTreeGitDeleted = { link = "NeoTreeGitDeleted" },
    NvimTreeIndentMarker = { link = "NeoTreeIndentMarker" },
    NvimTreeCursorLine = { link = "CursorLine" },
    NvimTreeVertSplit = { link = "VertSplit" },
    NvimTreeWindowPicker = { fg = c.on_primary, bg = c.primary, bold = true },
  })

  -- ── 15. indent-blankline / ibl ────────────────────────────────────────────
  hi({
    IblIndent = { fg = c.border },
    IblScope = { fg = c.fg_muted },
    IblWhitespace = { fg = c.border },
    IndentBlanklineChar = { link = "IblIndent" },
    IndentBlanklineContextChar = { link = "IblScope" },
    IndentBlanklineSpaceChar = { link = "IblWhitespace" },
  })

  -- ── 16. statusline (terminal buffers) ────────────────────────────────────
  hi({
    StatusLineTerm = { link = "StatusLine" },
    StatusLineTermNC = { link = "StatusLineNC" },
  })

  -- ── 17. bufferline.nvim ───────────────────────────────────────────────────
  hi({
    BufferLineBackground = { fg = c.fg_muted, bg = c.bg_surface },
    BufferLineFill = { bg = c.bg_surface },
    BufferLineBufferSelected = { fg = c.fg, bg = c.bg, bold = true },
    BufferLineBufferVisible = { fg = c.fg_muted, bg = c.bg_surface },
    BufferLineCloseButton = { fg = c.fg_muted, bg = c.bg_surface },
    BufferLineCloseButtonSelected = { fg = c.error, bg = c.bg },
    BufferLineCloseButtonVisible = { link = "BufferLineCloseButton" },
    BufferLineSeparator = { fg = c.border, bg = c.bg_surface },
    BufferLineSeparatorSelected = { fg = c.border, bg = c.bg },
    BufferLineModified = { fg = c.warning, bg = c.bg_surface },
    BufferLineModifiedSelected = { fg = c.warning, bg = c.bg },
    BufferLinePick = { fg = c.error, bg = c.bg_surface, bold = true },
    BufferLinePickSelected = { fg = c.error, bg = c.bg, bold = true },
    BufferLineTab = { link = "TabLine" },
    BufferLineTabSelected = { link = "TabLineSel" },
    BufferLineTabClose = { link = "BufferLineCloseButton" },
    BufferLineIndicatorSelected = { fg = c.primary, bg = c.bg },
    BufferLineError = { link = "DiagnosticError" },
    BufferLineErrorSelected = { link = "DiagnosticError" },
    BufferLineWarning = { link = "DiagnosticWarn" },
    BufferLineWarningSelected = { link = "DiagnosticWarn" },
    BufferLineInfo = { link = "DiagnosticInfo" },
    BufferLineInfoSelected = { link = "DiagnosticInfo" },
    BufferLineHint = { link = "DiagnosticHint" },
    BufferLineHintSelected = { link = "DiagnosticHint" },
  })

  -- ── 18. Snacks.nvim ───────────────────────────────────────────────────────
  hi({
    SnacksDashboardHeader = { fg = c.primary, bold = true },
    SnacksDashboardFooter = { fg = c.fg_muted, italic = true },
    SnacksDashboardKey = { fg = c.match_fg },
    SnacksDashboardDesc = { fg = c.fg },
    SnacksDashboardIcon = { fg = c.syntax_escape },
    SnacksDashboardTitle = { link = "Title" },
    SnacksDashboardDir = { fg = c.fg_muted },
    SnacksDashboardFile = { link = "Directory" },
    SnacksDashboardSpecial = { fg = c.secondary },

    SnacksNotifierInfo = { link = "DiagnosticInfo" },
    SnacksNotifierWarn = { link = "DiagnosticWarn" },
    SnacksNotifierError = { link = "DiagnosticError" },
    SnacksNotifierDebug = { fg = c.fg_muted },
    SnacksNotifierTrace = { fg = c.fg_muted },
    SnacksNotifierBorderInfo = { fg = c.primary },
    SnacksNotifierBorderWarn = { fg = c.warning },
    SnacksNotifierBorderError = { fg = c.error },

    SnacksPickerMatch = { link = "Search" },
    SnacksPickerListCursorLine = { link = "CursorLine" },
    SnacksPickerSelected = { fg = c.syntax_escape },
    SnacksPickerBorder = { link = "FloatBorder" },
    SnacksPickerTitle = { link = "FloatTitle" },

    SnacksWordsReference = { link = "LspReferenceText" },
    SnacksWordsWrite = { link = "LspReferenceWrite" },
    SnacksIndent = { link = "IblIndent" },
    SnacksIndentScope = { link = "IblScope" },
    SnacksScrollBar = { fg = c.border },
    SnacksScrollCurrent = { fg = c.primary },
  })

  -- ── 19. noice.nvim ────────────────────────────────────────────────────────
  hi({
    NoiceCompletionItemKindDefault = { link = "CmpItemAbbr" },
    NoiceCmdline = { fg = c.fg, bg = c.bg_surface },
    NoiceCmdlineIcon = { fg = c.primary },
    NoiceCmdlineIconSearch = { fg = c.match_fg },
    NoiceCmdlinePopup = { link = "NormalFloat" },
    NoiceCmdlinePopupBorder = { link = "FloatBorder" },
    NoiceCmdlinePopupTitle = { link = "FloatTitle" },
    NoiceConfirm = { link = "NormalFloat" },
    NoiceConfirmBorder = { link = "FloatBorder" },
    NoicePopup = { link = "NormalFloat" },
    NoicePopupBorder = { link = "FloatBorder" },
    NoiceSplitBorder = { link = "FloatBorder" },
    NoiceFormatProgressTodo = { fg = c.fg_muted },
    NoiceFormatProgressDone = { fg = c.success, bold = true },
    NoiceLspProgressTitle = { fg = c.fg },
    NoiceLspProgressClient = { fg = c.primary },
    NoiceLspProgressSpinner = { fg = c.syntax_escape },
    NoiceMini = { link = "NormalFloat" },
    NoiceScrollbar = { link = "PmenuSbar" },
    NoiceScrollbarThumb = { link = "PmenuThumb" },
  })

  -- ── 20. nvim-notify ───────────────────────────────────────────────────────
  hi({
    NotifyBackground = { bg = c.bg },
    NotifyERRORBorder = { fg = c.error },
    NotifyWARNBorder = { fg = c.warning },
    NotifyINFOBorder = { fg = c.primary },
    NotifyDEBUGBorder = { fg = c.fg_muted },
    NotifyTRACEBorder = { fg = c.secondary },
    NotifyERRORIcon = { link = "DiagnosticError" },
    NotifyWARNIcon = { link = "DiagnosticWarn" },
    NotifyINFOIcon = { link = "DiagnosticInfo" },
    NotifyDEBUGIcon = { fg = c.fg_muted },
    NotifyTRACEIcon = { fg = c.secondary },
    NotifyERRORTitle = { link = "DiagnosticError" },
    NotifyWARNTitle = { link = "DiagnosticWarn" },
    NotifyINFOTitle = { link = "DiagnosticInfo" },
    NotifyDEBUGTitle = { fg = c.fg_muted },
    NotifyTRACETitle = { fg = c.secondary },
    NotifyERRORBody = { link = "Normal" },
    NotifyWARNBody = { link = "Normal" },
    NotifyINFOBody = { link = "Normal" },
    NotifyDEBUGBody = { link = "Normal" },
    NotifyTRACEBody = { link = "Normal" },
  })

  -- ── 21. trouble.nvim ──────────────────────────────────────────────────────
  hi({
    TroubleNormal = { link = "NormalFloat" },
    TroubleNormalNC = { link = "NormalFloat" },
    TroubleCount = { fg = c.secondary, bold = true },
    TroubleError = { link = "DiagnosticError" },
    TroubleWarning = { link = "DiagnosticWarn" },
    TroubleInformation = { link = "DiagnosticInfo" },
    TroubleHint = { link = "DiagnosticHint" },
    TroubleText = { fg = c.fg },
    TroubleDirectory = { link = "Directory" },
    TroubleFile = { fg = c.fg },
    TroubleLocation = { fg = c.fg_muted },
    TroubleSignError = { link = "DiagnosticError" },
    TroubleSignWarning = { link = "DiagnosticWarn" },
    TroubleSignInformation = { link = "DiagnosticInfo" },
    TroubleSignHint = { link = "DiagnosticHint" },
    TroubleIndent = { link = "IblIndent" },
    TroublePos = { fg = c.fg_muted },
    TroubleCode = { fg = c.fg_muted },
    TroubleSource = { fg = c.fg_muted, italic = true },
    TroublePreview = { link = "CursorLine" },
  })

  -- ── 22. flash.nvim ────────────────────────────────────────────────────────
  hi({
    FlashBackdrop = { fg = c.fg_muted },
    FlashMatch = { fg = c.bg, bg = c.match_fg },
    FlashCurrent = { fg = c.bg, bg = c.warning },
    FlashLabel = { fg = c.bg, bg = c.error, bold = true },
    FlashPrompt = { link = "NoiceCmdline" },
    FlashPromptIcon = { fg = c.error },
    FlashCursor = { link = "Cursor" },
  })

  -- ── 23. leap.nvim ─────────────────────────────────────────────────────────
  hi({
    LeapMatch = { link = "FlashMatch" },
    LeapLabelPrimary = { link = "FlashLabel" },
    LeapLabelSecondary = { fg = c.bg, bg = c.secondary, bold = true },
    LeapBackdrop = { link = "FlashBackdrop" },
  })

  -- ── 24. mini.nvim ─────────────────────────────────────────────────────────
  hi({
    MiniStatuslineModeNormal = { fg = c.on_primary, bg = c.primary, bold = true },
    MiniStatuslineModeInsert = { fg = c.bg, bg = c.success, bold = true },
    MiniStatuslineModeVisual = { fg = c.bg, bg = c.secondary, bold = true },
    MiniStatuslineModeReplace = { fg = c.bg, bg = c.error, bold = true },
    MiniStatuslineModeCommand = { fg = c.bg, bg = c.match_fg, bold = true },
    MiniStatuslineModeOther = { fg = c.bg, bg = c.syntax_escape, bold = true },
    MiniStatuslineFilename = { link = "StatusLine" },
    MiniStatuslineFileinfo = { link = "StatusLine" },
    MiniStatuslineDevinfo = { link = "StatusLine" },
    MiniStatuslineInactive = { link = "StatusLineNC" },

    MiniTablineCurrent = { link = "TabLineSel" },
    MiniTablineVisible = { link = "TabLine" },
    MiniTablineHidden = { link = "TabLine" },
    MiniTablineFill = { link = "TabLineFill" },
    MiniTablineModifiedCurrent = { fg = c.warning, bg = c.bg, bold = true },
    MiniTablineModifiedVisible = { fg = c.warning, bg = c.bg_surface },
    MiniTablineModifiedHidden = { link = "MiniTablineModifiedVisible" },

    MiniCompletionActiveParameter = { link = "LspSignatureActiveParameter" },
    MiniCursorword = { link = "LspReferenceText" },
    MiniCursorwordCurrent = { link = "LspReferenceText" },
    MiniIndentscopeSymbol = { link = "IblScope" },
    MiniIndentscopePrefix = { link = "IblIndent" },
    MiniJump = { link = "FlashLabel" },
    MiniJump2dSpot = { link = "FlashLabel" },
    MiniJump2dSpotAhead = { link = "FlashMatch" },
    MiniJump2dSpotUnique = { fg = c.bg, bg = c.syntax_escape, bold = true },

    MiniMapNormal = { link = "NormalFloat" },
    MiniMapSymbolLine = { link = "CursorLine" },
    MiniMapSymbolView = { fg = c.primary },

    MiniPickBorder = { link = "FloatBorder" },
    MiniPickBorderBusy = { fg = c.warning },
    MiniPickBorderText = { link = "FloatTitle" },
    MiniPickNormal = { link = "NormalFloat" },
    MiniPickMatchCurrent = { link = "CursorLine" },
    MiniPickMatchMarked = { fg = c.syntax_escape },
    MiniPickMatchRanges = { link = "TelescopeMatching" },
    MiniPickPrompt = { fg = c.primary },

    MiniDiffSignAdd = { link = "GitSignsAdd" },
    MiniDiffSignChange = { link = "GitSignsChange" },
    MiniDiffSignDelete = { link = "GitSignsDelete" },
    MiniDiffOverAdd = { link = "DiffAdd" },
    MiniDiffOverChange = { link = "DiffChange" },
    MiniDiffOverDelete = { link = "DiffDelete" },

    MiniNotifyBorder = { link = "FloatBorder" },
    MiniNotifyNormal = { link = "NormalFloat" },
    MiniNotifyTitle = { link = "FloatTitle" },

    MiniClueBorder = { link = "FloatBorder" },
    MiniClueNormal = { link = "NormalFloat" },
    MiniClueTitle = { link = "FloatTitle" },
    MiniClueDescGroup = { link = "WhichKeyGroup" },
    MiniClueDescSingle = { link = "WhichKeyDesc" },
    MiniClueNextKey = { link = "WhichKey" },
    MiniClueSeparator = { link = "WhichKeySeparator" },

    MiniFilesBorder = { link = "FloatBorder" },
    MiniFilesNormal = { link = "NormalFloat" },
    MiniFilesTitle = { link = "FloatTitle" },
    MiniFilesTitleFocused = { fg = c.on_primary, bg = c.primary, bold = true },
    MiniFilesCursorLine = { link = "CursorLine" },
    MiniFilesDirectory = { link = "Directory" },
    MiniFilesFile = { link = "Normal" },
  })

  -- ── 25. illuminate.nvim ───────────────────────────────────────────────────
  hi({
    IlluminatedWordText = { link = "LspReferenceText" },
    IlluminatedWordRead = { link = "LspReferenceRead" },
    IlluminatedWordWrite = { link = "LspReferenceWrite" },
  })

  -- ── 26. nvim-dap / dap-ui ────────────────────────────────────────────────
  hi({
    DapBreakpoint = { fg = c.error },
    DapBreakpointCondition = { fg = c.warning },
    DapBreakpointRejected = { fg = c.fg_muted },
    DapLogPoint = { fg = c.syntax_escape },
    DapStopped = { fg = c.success },
    DapStoppedLine = { bg = c.diff_add },

    DapUIScope = { link = "Title" },
    DapUIType = { link = "Type" },
    DapUIModifiedValue = { fg = c.warning, bold = true },
    DapUIDecoration = { fg = c.primary },
    DapUIThread = { link = "Function" },
    DapUIStoppedThread = { fg = c.success, bold = true },
    DapUISource = { fg = c.syntax_escape },
    DapUILineNumber = { link = "LineNr" },
    DapUIFloatBorder = { link = "FloatBorder" },
    DapUIWatchesValue = { fg = c.success },
    DapUIWatchesError = { link = "DiagnosticError" },
    DapUIWatchesEmpty = { fg = c.fg_muted },
    DapUIBreakpointsPath = { link = "Directory" },
    DapUIBreakpointsInfo = { link = "DiagnosticInfo" },
    DapUIBreakpointsCurrentLine = { fg = c.success, bold = true },
    DapUIBreakpointsDisabledLine = { fg = c.fg_muted },
    DapUICurrentFrameName = { link = "DapUIStoppedThread" },
    DapUIEndofBuffer = { link = "EndOfBuffer" },
    DapUIFrameName = { fg = c.fg },
    DapUIBar = { fg = c.border },
    DapUIPlayPause = { fg = c.success },
    DapUIRestart = { link = "DapUIPlayPause" },
    DapUIStop = { fg = c.error },
    DapUIUnavailable = { fg = c.fg_muted },
    DapUIStepOver = { fg = c.primary },
    DapUIStepInto = { link = "DapUIStepOver" },
    DapUIStepBack = { link = "DapUIStepOver" },
    DapUIStepOut = { link = "DapUIStepOver" },
  })

  -- ── 27. neotest ───────────────────────────────────────────────────────────
  hi({
    NeotestPassed = { fg = c.success },
    NeotestFailed = { fg = c.error },
    NeotestRunning = { fg = c.warning },
    NeotestSkipped = { fg = c.fg_muted },
    NeotestUnknown = { fg = c.fg_muted },
    NeotestFile = { link = "Directory" },
    NeotestDir = { link = "Directory" },
    NeotestNamespace = { link = "@namespace" },
    NeotestAdapter = { link = "Title" },
    NeotestIndent = { link = "IblIndent" },
    NeotestExpandMarker = { link = "IblIndent" },
    NeotestFocused = { link = "CursorLine" },
    NeotestWatching = { fg = c.syntax_escape },
    NeotestWinSelect = { fg = c.primary, bold = true },
    NeotestMarked = { fg = c.syntax_constant, bold = true },
    NeotestTest = { fg = c.fg },
  })

  -- ── 28. mason.nvim ────────────────────────────────────────────────────────
  hi({
    MasonNormal = { link = "NormalFloat" },
    MasonHeader = { fg = c.on_primary, bg = c.primary, bold = true },
    MasonHeaderSecondary = { fg = c.bg, bg = c.success, bold = true },
    MasonHighlight = { fg = c.primary },
    MasonHighlightBlock = { fg = c.on_primary, bg = c.primary },
    MasonHighlightBlockBold = { fg = c.on_primary, bg = c.primary, bold = true },
    MasonHighlightSecondary = { fg = c.syntax_escape },
    MasonHighlightBlockSecondary = { fg = c.bg, bg = c.syntax_escape },
    MasonHighlightBlockBoldSecondary = { fg = c.bg, bg = c.syntax_escape, bold = true },
    MasonLink = { fg = c.primary, underline = true },
    MasonMuted = { fg = c.fg_muted },
    MasonMutedBlock = { fg = c.bg, bg = c.fg_muted },
    MasonError = { link = "DiagnosticError" },
    MasonWarning = { link = "DiagnosticWarn" },
    MasonHeading = { link = "Title" },
  })

  -- ── 29. lazy.nvim ────────────────────────────────────────────────────────
  hi({
    LazyNormal = { link = "NormalFloat" },
    LazyBorder = { link = "FloatBorder" },
    LazyButton = { fg = c.fg, bg = c.bg_highlight },
    LazyButtonActive = { fg = c.on_primary, bg = c.primary, bold = true },
    LazyH1 = { fg = c.on_primary, bg = c.primary, bold = true },
    LazyH2 = { link = "Title" },
    LazyComment = { link = "Comment" },
    LazyDimmed = { fg = c.fg_muted },
    LazyProp = { fg = c.syntax_escape },
    LazyValue = { fg = c.syntax_string },
    LazyUrl = { fg = c.primary, underline = true },
    LazyCommit = { fg = c.syntax_constant },
    LazyCommitType = { fg = c.secondary, italic = true },
    LazyLocal = { fg = c.syntax_escape },
    LazySpecial = { fg = c.primary },
    LazyReasonPlugin = { fg = c.primary },
    LazyReasonEvent = { fg = c.secondary },
    LazyReasonKeys = { fg = c.match_fg },
    LazyReasonSource = { fg = c.syntax_escape },
    LazyReasonFt = { fg = c.success },
    LazyReasonCmd = { fg = c.syntax_constant },
    LazyReasonRequire = { fg = c.primary },
    LazyReasonStart = { fg = c.fg_muted },
    LazyProgressDone = { fg = c.success, bold = true },
    LazyProgressTodo = { fg = c.fg_muted },
    LazyError = { link = "DiagnosticError" },
    LazyWarning = { link = "DiagnosticWarn" },
    LazyInfo = { link = "DiagnosticInfo" },
  })

  -- ── 30. alpha-nvim / dashboard-nvim ──────────────────────────────────────
  hi({
    AlphaHeader = { link = "SnacksDashboardHeader" },
    AlphaFooter = { link = "SnacksDashboardFooter" },
    AlphaButton = { fg = c.match_fg },
    AlphaButtonShortcut = { fg = c.syntax_escape },
    DashboardHeader = { link = "SnacksDashboardHeader" },
    DashboardFooter = { link = "SnacksDashboardFooter" },
    DashboardCenter = { fg = c.primary },
    DashboardShortCut = { fg = c.match_fg },
  })

  -- ── 31. aerial.nvim ───────────────────────────────────────────────────────
  hi({
    AerialNormal = { link = "NormalFloat" },
    AerialLine = { link = "CursorLine" },
    AerialGuide = { link = "IblIndent" },
    AerialTitle = { link = "Title" },
    AerialTextIcon = { link = "@field" },
    AerialFunctionIcon = { link = "Function" },
    AerialClassIcon = { link = "Type" },
    AerialMethodIcon = { link = "Function" },
    AerialModuleIcon = { link = "@namespace" },
  })

  -- ── 32. navic ─────────────────────────────────────────────────────────────
  hi({
    NavicIconsFile = { fg = c.fg_muted },
    NavicIconsModule = { link = "@namespace" },
    NavicIconsNamespace = { link = "@namespace" },
    NavicIconsPackage = { link = "@namespace" },
    NavicIconsClass = { link = "Type" },
    NavicIconsMethod = { link = "Function" },
    NavicIconsProperty = { link = "@property" },
    NavicIconsField = { link = "@field" },
    NavicIconsConstructor = { link = "Function" },
    NavicIconsEnum = { link = "Type" },
    NavicIconsInterface = { link = "Type" },
    NavicIconsFunction = { link = "Function" },
    NavicIconsVariable = { link = "Identifier" },
    NavicIconsConstant = { link = "Constant" },
    NavicIconsString = { link = "String" },
    NavicIconsNumber = { link = "Number" },
    NavicIconsBoolean = { link = "Boolean" },
    NavicIconsArray = { link = "Type" },
    NavicIconsObject = { link = "Type" },
    NavicIconsKey = { link = "@field" },
    NavicIconsNull = { fg = c.syntax_constant },
    NavicIconsEnumMember = { link = "@field" },
    NavicIconsStruct = { link = "Structure" },
    NavicIconsEvent = { fg = c.secondary },
    NavicIconsOperator = { link = "Operator" },
    NavicIconsTypeParameter = { link = "Type" },
    NavicText = { fg = c.fg_muted },
    NavicSeparator = { fg = c.fg_muted },
  })

  -- ── 33. render-markdown.nvim ──────────────────────────────────────────────
  hi({
    RenderMarkdownH1 = { fg = c.primary, bold = true },
    RenderMarkdownH2 = { fg = c.secondary, bold = true },
    RenderMarkdownH3 = { fg = c.syntax_escape, bold = true },
    RenderMarkdownH4 = { fg = c.success, bold = true },
    RenderMarkdownH5 = { fg = c.match_fg, bold = true },
    RenderMarkdownH6 = { fg = c.syntax_constant, bold = true },
    RenderMarkdownH1Bg = { bg = c.bg_surface },
    RenderMarkdownH2Bg = { link = "RenderMarkdownH1Bg" },
    RenderMarkdownH3Bg = { link = "RenderMarkdownH1Bg" },

    RenderMarkdownCode = { bg = c.bg_surface },
    RenderMarkdownCodeInline = { fg = c.syntax_string, bg = c.bg_surface },
    RenderMarkdownBullet = { fg = c.secondary },
    RenderMarkdownQuote = { fg = c.fg_muted, italic = true },
    RenderMarkdownDash = { fg = c.border },
    RenderMarkdownLink = { link = "@text.uri" },
    RenderMarkdownChecked = { fg = c.success },
    RenderMarkdownUnchecked = { fg = c.fg_muted },
    RenderMarkdownTableHead = { fg = c.primary, bold = true },
    RenderMarkdownTableRow = { fg = c.fg },
    RenderMarkdownTableFill = { fg = c.border },
    RenderMarkdownError = { link = "DiagnosticError" },
    RenderMarkdownWarn = { link = "DiagnosticWarn" },
    RenderMarkdownInfo = { link = "DiagnosticInfo" },
    RenderMarkdownHint = { link = "DiagnosticHint" },
    RenderMarkdownSuccess = { fg = c.success },
  })

  -- ── 34. headlines.nvim ────────────────────────────────────────────────────
  hi({
    Headline1 = { bg = d.hi_blue, bold = true },
    Headline2 = { bg = d.hi_magenta, bold = true },
    Headline3 = { bg = d.hi_green, bold = true },
    CodeBlock = { bg = c.bg_surface },
    Dash = { link = "RenderMarkdownDash" },
    Quote = { link = "RenderMarkdownQuote" },
  })

  -- ── 35. Language: Rust ────────────────────────────────────────────────────
  hi({
    rustKeyword = { link = "Keyword" },
    rustModPath = { link = "@namespace" },
    rustModPathSep = { fg = c.syntax_punctuation },
    rustLifetime = { fg = c.secondary, italic = true },
    rustLabel = { fg = c.secondary },
    rustMacro = { fg = c.syntax_escape, bold = true },
    rustSelf = { fg = c.syntax_variable, italic = true },
    rustSigil = { fg = c.syntax_escape },
    rustOperator = { link = "Operator" },
    rustArrow = { link = "Operator" },
    rustFatArrow = { link = "Operator" },
    rustQuestionMark = { fg = c.error },
    rustStorage = { link = "StorageClass" },
    rustStructure = { link = "Structure" },
    rustEnum = { link = "Type" },
    rustTrait = { link = "Type" },
    rustDerive = { fg = c.syntax_type },
    rustDeriveTrait = { fg = c.syntax_type, italic = true },
    rustAttribute = { link = "@attribute" },
    rustCommentLine = { link = "Comment" },
    rustCommentLineDoc = { fg = c.syntax_comment, italic = true },
    rustString = { link = "String" },
    rustStringDelimiter = { link = "String" },
    rustNumber = { link = "Number" },
    rustBoolean = { link = "Boolean" },
    rustFloat = { link = "Float" },
    rustEscape = { link = "@string.escape" },

    ["@lsp.type.lifetime"] = { fg = c.secondary, italic = true },
    ["@lsp.type.selfKeyword"] = { fg = c.syntax_variable, italic = true },
    ["@lsp.type.formatSpecifier"] = { fg = c.syntax_escape },
    ["@lsp.mod.mutable"] = { underline = true },
    ["@lsp.mod.consuming"] = { italic = true },
    ["@lsp.typemod.variable.mutable"] = { underline = true },
  })

  -- ── 36. Language: Lua ─────────────────────────────────────────────────────
  hi({
    luaStatement = { link = "Keyword" },
    luaFunction = { link = "Keyword" },
    luaTable = { fg = c.fg },
    luaBraces = { fg = c.syntax_punctuation },
    luaIn = { link = "Keyword" },
    luaLocal = { link = "Keyword" },
    luaNil = { fg = c.syntax_constant },
    luaBoolean = { link = "Boolean" },
    luaNumber = { link = "Number" },
    luaString = { link = "String" },
    luaStringLong = { link = "String" },
    luaComment = { link = "Comment" },
    luaCommentLong = { link = "Comment" },
    luaCommentDelimiter = { link = "Comment" },
    luaOperator = { link = "Operator" },
    luaError = { link = "Error" },
    luaParenError = { link = "Error" },
    luaSpecial = { link = "Special" },

    ["@lsp.type.property.lua"] = { link = "@property" },
    ["@lsp.type.variable.lua"] = { link = "@variable" },
  })

  -- ── 37. Language: Python ──────────────────────────────────────────────────
  hi({
    pythonStatement = { link = "Keyword" },
    pythonConditional = { link = "Conditional" },
    pythonRepeat = { link = "Repeat" },
    pythonOperator = { link = "Operator" },
    pythonException = { link = "Exception" },
    pythonInclude = { link = "Include" },
    pythonAsync = { link = "Keyword" },
    pythonDecorator = { fg = c.syntax_type },
    pythonDecoratorName = { fg = c.syntax_type, italic = true },
    pythonDot = { fg = c.syntax_punctuation },
    pythonBuiltin = { fg = c.syntax_escape },
    pythonBuiltinType = { link = "Type" },
    pythonBuiltinFunc = { fg = c.syntax_escape },
    pythonBuiltinObj = { fg = c.syntax_constant },
    pythonString = { link = "String" },
    pythonRawString = { link = "String" },
    pythonFString = { link = "String" },
    pythonFStringBraces = { fg = c.syntax_escape },
    pythonBytes = { link = "String" },
    pythonNumber = { link = "Number" },
    pythonFloat = { link = "Float" },
    pythonBoolean = { link = "Boolean" },
    pythonNone = { fg = c.syntax_constant },
    pythonComment = { link = "Comment" },
    pythonSelf = { fg = c.syntax_variable, italic = true },
    pythonCls = { fg = c.syntax_variable, italic = true },
    pythonClass = { link = "Type" },
    pythonFunction = { link = "Function" },

    ["@lsp.type.class.python"] = { link = "Type" },
    ["@lsp.type.function.python"] = { link = "Function" },
    ["@lsp.type.parameter.python"] = { link = "@parameter" },
    ["@lsp.type.variable.python"] = { link = "@variable" },
    ["@lsp.type.decorator.python"] = { fg = c.syntax_type },
  })

  -- ── 38. Language: C / C++ ─────────────────────────────────────────────────
  hi({
    cStatement = { link = "Keyword" },
    cConditional = { link = "Conditional" },
    cRepeat = { link = "Repeat" },
    cLabel = { link = "Label" },
    cOperator = { link = "Operator" },
    cType = { link = "Type" },
    cStorageClass = { link = "StorageClass" },
    cStructure = { link = "Structure" },
    cString = { link = "String" },
    cCppString = { link = "String" },
    cNumber = { link = "Number" },
    cFloat = { link = "Float" },
    cBoolean = { link = "Boolean" },
    cCharacter = { link = "Character" },
    cSpecial = { link = "Special" },
    cPreProc = { link = "PreProc" },
    cInclude = { link = "Include" },
    cDefine = { link = "Define" },
    cMacro = { link = "Macro" },
    cPreCondit = { link = "PreCondit" },
    cComment = { link = "Comment" },
    cCommentL = { link = "Comment" },

    cppStatement = { link = "Keyword" },
    cppAccess = { fg = c.secondary },
    cppModifier = { link = "StorageClass" },
    cppType = { link = "Type" },
    cppStructure = { link = "Structure" },
    cppOperator = { link = "Operator" },
    cppCast = { link = "Keyword" },
    cppExceptions = { link = "Exception" },
    cppStorageClass = { link = "StorageClass" },
    cppBoolean = { link = "Boolean" },
    cppNumber = { link = "Number" },
    cppString = { link = "String" },
    cppRawString = { link = "String" },

    ["@lsp.type.class.cpp"] = { link = "Type" },
    ["@lsp.type.enum.cpp"] = { link = "Type" },
    ["@lsp.type.enumMember.cpp"] = { link = "@field" },
    ["@lsp.type.macro.cpp"] = { link = "Macro" },
    ["@lsp.type.namespace.cpp"] = { link = "@namespace" },
    ["@lsp.type.parameter.cpp"] = { link = "@parameter" },
    ["@lsp.type.property.cpp"] = { link = "@property" },
    ["@lsp.type.type.cpp"] = { link = "Type" },
    ["@lsp.type.variable.cpp"] = { link = "@variable" },
    ["@lsp.type.class.c"] = { link = "Type" },
    ["@lsp.type.macro.c"] = { link = "Macro" },
    ["@lsp.type.parameter.c"] = { link = "@parameter" },
    ["@lsp.type.variable.c"] = { link = "@variable" },
  })

  -- ── 39. Language: JavaScript / TypeScript ─────────────────────────────────
  hi({
    jsStatement = { link = "Keyword" },
    jsConditional = { link = "Conditional" },
    jsRepeat = { link = "Repeat" },
    jsReturn = { fg = c.error },
    jsException = { link = "Exception" },
    jsOperator = { link = "Operator" },
    jsStorageClass = { link = "StorageClass" },
    jsThis = { fg = c.syntax_variable, italic = true },
    jsSuper = { fg = c.syntax_variable, italic = true },
    jsUndefined = { fg = c.syntax_constant },
    jsNull = { fg = c.syntax_constant },
    jsNan = { fg = c.syntax_constant },
    jsGlobalObjects = { fg = c.syntax_escape },
    jsFunction = { link = "Keyword" },
    jsArrowFunction = { link = "Operator" },
    jsString = { link = "String" },
    jsTemplateString = { link = "String" },
    jsTemplateBraces = { fg = c.syntax_escape },
    jsNumber = { link = "Number" },
    jsFloat = { link = "Float" },
    jsBoolean = { link = "Boolean" },
    jsRegexpString = { fg = c.syntax_escape },
    jsObjectKey = { link = "@field" },
    jsObjectColon = { fg = c.syntax_punctuation },
    jsSpread = { link = "Operator" },
    jsClassDefinition = { link = "Type" },
    jsClassKeyword = { link = "Keyword" },
    jsExtendsKeyword = { link = "Keyword" },
    jsImport = { link = "Include" },
    jsExport = { link = "Include" },
    jsModuleAs = { link = "Keyword" },
    jsFrom = { link = "Keyword" },
    jsDecorator = { fg = c.syntax_type },
    jsDecoratorFunction = { fg = c.syntax_type, italic = true },

    typescriptStatement = { link = "Keyword" },
    typescriptReserved = { link = "Keyword" },
    typescriptStorageClass = { link = "StorageClass" },
    typescriptEndColons = { fg = c.syntax_punctuation },
    typescriptBraces = { fg = c.syntax_punctuation },
    typescriptParens = { fg = c.syntax_punctuation },
    typescriptDotNotation = { fg = c.syntax_punctuation },
    typescriptTypeAnnotation = { fg = c.syntax_punctuation },
    typescriptAccessibilityModifier = { fg = c.secondary },
    typescriptReadonlyModifier = { link = "StorageClass" },
    typescriptDeclareModifier = { link = "StorageClass" },
    typescriptOptionalMark = { fg = c.error },
    typescriptNull = { fg = c.syntax_constant },
    typescriptUndefined = { fg = c.syntax_constant },
    typescriptThis = { fg = c.syntax_variable, italic = true },
    typescriptArrowFunc = { link = "Operator" },
    typescriptFuncKeyword = { link = "Keyword" },
    typescriptAsyncFuncKeyword = { link = "Keyword" },
    typescriptDecorator = { fg = c.syntax_type },
    typescriptImport = { link = "Include" },
    typescriptExport = { link = "Include" },
    typescriptTypeImport = { link = "Include" },
    typescriptInterpolation = { fg = c.syntax_escape },
    typescriptInterpolationDelimiter = { fg = c.syntax_escape },
    typescriptString = { link = "String" },
    typescriptTemplate = { link = "String" },
    typescriptNumber = { link = "Number" },
    typescriptBoolean = { link = "Boolean" },
    typescriptObjectType = { link = "@field" },
    typescriptPredefinedType = { link = "Type" },
    typescriptTypeReference = { link = "Type" },
    typescriptEnumKeyword = { link = "Keyword" },
    typescriptEnum = { link = "Type" },
    typescriptInterfaceKeyword = { link = "Keyword" },
    typescriptInterface = { link = "Type" },

    ["@lsp.type.class.typescript"] = { link = "Type" },
    ["@lsp.type.enum.typescript"] = { link = "Type" },
    ["@lsp.type.enumMember.typescript"] = { link = "@field" },
    ["@lsp.type.function.typescript"] = { link = "Function" },
    ["@lsp.type.interface.typescript"] = { link = "Type" },
    ["@lsp.type.namespace.typescript"] = { link = "@namespace" },
    ["@lsp.type.parameter.typescript"] = { link = "@parameter" },
    ["@lsp.type.property.typescript"] = { link = "@property" },
    ["@lsp.type.type.typescript"] = { link = "Type" },
    ["@lsp.type.typeParameter.typescript"] = { link = "Type" },
    ["@lsp.type.variable.typescript"] = { link = "@variable" },
    ["@lsp.type.class.javascript"] = { link = "Type" },
    ["@lsp.type.function.javascript"] = { link = "Function" },
    ["@lsp.type.parameter.javascript"] = { link = "@parameter" },
    ["@lsp.type.property.javascript"] = { link = "@property" },
    ["@lsp.type.variable.javascript"] = { link = "@variable" },
  })

  -- ── 40. Language: JSON / JSONC ────────────────────────────────────────────
  hi({
    jsonBraces = { fg = c.syntax_punctuation },
    jsonKeyword = { link = "@field" },
    jsonQuote = { fg = c.syntax_punctuation },
    jsonString = { link = "String" },
    jsonNumber = { link = "Number" },
    jsonBoolean = { link = "Boolean" },
    jsonNull = { fg = c.syntax_constant },
    jsonCommentError = { link = "Error" },
    ["@label.json"] = { link = "@field" },
  })

  -- ── 41. Language: HTML / CSS ──────────────────────────────────────────────
  hi({
    htmlTag = { fg = c.syntax_punctuation },
    htmlEndTag = { fg = c.syntax_punctuation },
    htmlTagName = { fg = c.syntax_variable },
    htmlArg = { fg = c.syntax_type },
    htmlTitle = { link = "Title" },
    htmlH1 = { link = "Title" },
    htmlH2 = { fg = c.secondary, bold = true },
    htmlH3 = { fg = c.syntax_escape, bold = true },
    htmlLink = { fg = c.primary, underline = true },
    htmlBold = { bold = true },
    htmlItalic = { italic = true },
    htmlString = { link = "String" },
    htmlSpecialChar = { link = "Special" },
    htmlComment = { link = "Comment" },
    htmlCommentPart = { link = "Comment" },

    cssTagName = { link = "htmlTagName" },
    cssClassName = { fg = c.syntax_type },
    cssClassNameDot = { fg = c.syntax_type },
    cssPseudoClassId = { fg = c.syntax_escape },
    cssPseudoClassFn = { fg = c.syntax_escape },
    cssId = { fg = c.syntax_constant },
    cssAttrComma = { fg = c.syntax_punctuation },
    cssAtKeyword = { link = "Keyword" },
    cssBraces = { fg = c.syntax_punctuation },
    cssDefinition = { link = "@property" },
    cssProp = { link = "@property" },
    cssVendor = { fg = c.syntax_punctuation },
    cssImportant = { fg = c.error, bold = true },
    cssValueLength = { link = "Number" },
    cssValueNumber = { link = "Number" },
    cssValueAngle = { link = "Number" },
    cssValueTime = { link = "Number" },
    cssValueFrequency = { link = "Number" },
    cssColor = { fg = c.syntax_constant },
    cssFunction = { link = "Function" },
    cssString = { link = "String" },
    cssComment = { link = "Comment" },
    cssUnitDecorators = { fg = c.syntax_escape },
    cssCustomProp = { fg = c.syntax_escape },
  })

  -- ── 42. Language: Go ──────────────────────────────────────────────────────
  hi({
    goStatement = { link = "Keyword" },
    goConditional = { link = "Conditional" },
    goRepeat = { link = "Repeat" },
    goLabel = { link = "Label" },
    goException = { link = "Exception" },
    goDeclType = { link = "Keyword" },
    goBuiltins = { fg = c.syntax_escape },
    goConstants = { fg = c.syntax_constant },
    goFunctionCall = { link = "Function" },
    goStruct = { link = "Structure" },
    goStructDef = { link = "Type" },
    goInterface = { link = "Type" },
    goTypeName = { link = "Type" },
    goString = { link = "String" },
    goRawString = { link = "String" },
    goNumber = { link = "Number" },
    goBoolean = { link = "Boolean" },
    goSignedInts = { link = "Type" },
    goUnsignedInts = { link = "Type" },
    goFloats = { link = "Float" },
    goComplexes = { link = "Type" },
    goReceiverType = { link = "@parameter" },
    goPointerOperator = { link = "Operator" },
    goVarArgs = { link = "Operator" },
    goImport = { link = "Include" },
    goPackage = { link = "Keyword" },
    goComment = { link = "Comment" },

    ["@lsp.type.namespace.go"] = { link = "@namespace" },
    ["@lsp.type.type.go"] = { link = "Type" },
    ["@lsp.type.interface.go"] = { link = "Type" },
    ["@lsp.type.struct.go"] = { link = "Type" },
    ["@lsp.type.parameter.go"] = { link = "@parameter" },
    ["@lsp.type.variable.go"] = { link = "@variable" },
    ["@lsp.type.function.go"] = { link = "Function" },
    ["@lsp.type.method.go"] = { link = "Function" },
  })

  -- ── 43. Language: Shell / Bash ────────────────────────────────────────────
  hi({
    shStatement = { link = "Keyword" },
    shConditional = { link = "Conditional" },
    shRepeat = { link = "Repeat" },
    shFunction = { link = "Function" },
    shFunctionKey = { link = "Keyword" },
    shOperator = { link = "Operator" },
    shArithOperator = { link = "Operator" },
    shTestOpr = { link = "Operator" },
    shVariable = { fg = c.syntax_escape },
    shDeref = { link = "shVariable" },
    shDerefSimple = { link = "shVariable" },
    shDerefVar = { link = "shVariable" },
    shDerefSpecial = { fg = c.syntax_escape, italic = true },
    shSpecial = { link = "Special" },
    shSpecialVar = { link = "Special" },
    shSingleQuote = { link = "String" },
    shDoubleQuote = { link = "String" },
    shHereDoc = { link = "String" },
    shHereString = { link = "String" },
    shNumber = { link = "Number" },
    shRange = { link = "Operator" },
    shParen = { fg = c.syntax_punctuation },
    shPipe = { link = "Operator" },
    shSubSh = { fg = c.syntax_escape },
    shCommandSub = { fg = c.syntax_escape },
    shCmdSubRegion = { fg = c.syntax_escape },
    shComment = { link = "Comment" },
    shBang = { fg = c.syntax_comment, bold = true },
    bashStatement = { link = "shStatement" },
    bashSpecialVariables = { link = "shSpecialVar" },
  })

  -- ── 44. Language: YAML ────────────────────────────────────────────────────
  hi({
    yamlKey = { link = "@field" },
    yamlAnchor = { fg = c.syntax_escape },
    yamlAlias = { fg = c.syntax_escape, italic = true },
    yamlBlockMappingKey = { link = "@field" },
    yamlFlowMappingKey = { link = "@field" },
    yamlString = { link = "String" },
    yamlPlainScalar = { link = "String" },
    yamlInteger = { link = "Number" },
    yamlFloat = { link = "Float" },
    yamlBool = { link = "Boolean" },
    yamlNull = { fg = c.syntax_constant },
    yamlTag = { fg = c.secondary },
    yamlComment = { link = "Comment" },
    yamlDocumentStart = { fg = c.fg_muted },
    yamlDocumentEnd = { fg = c.fg_muted },
    yamlBlockCollectionItemStart = { fg = c.secondary },
  })

  -- ── 45. Language: TOML ────────────────────────────────────────────────────
  hi({
    tomlKey = { link = "@field" },
    tomlTable = { fg = c.primary, bold = true },
    tomlTableArray = { fg = c.primary, bold = true },
    tomlString = { link = "String" },
    tomlMultilineString = { link = "String" },
    tomlInteger = { link = "Number" },
    tomlFloat = { link = "Float" },
    tomlBoolean = { link = "Boolean" },
    tomlDate = { fg = c.syntax_constant },
    tomlTime = { fg = c.syntax_constant },
    tomlComment = { link = "Comment" },
    tomlKeyDq = { link = "tomlKey" },
    tomlKeySq = { link = "tomlKey" },
  })

  -- ── 46. Language: SQL ─────────────────────────────────────────────────────
  hi({
    sqlStatement = { link = "Keyword" },
    sqlKeyword = { link = "Keyword" },
    sqlOperator = { link = "Operator" },
    sqlType = { link = "Type" },
    sqlSpecial = { link = "Special" },
    sqlString = { link = "String" },
    sqlNumber = { link = "Number" },
    sqlComment = { link = "Comment" },
    sqlIdentifier = { link = "Identifier" },
    sqlFunction = { link = "Function" },
  })

  -- ── 47. Language: Markdown ────────────────────────────────────────────────
  hi({
    markdownH1 = { fg = c.primary, bold = true },
    markdownH2 = { fg = c.secondary, bold = true },
    markdownH3 = { fg = c.syntax_escape, bold = true },
    markdownH4 = { fg = c.success, bold = true },
    markdownH5 = { fg = c.match_fg, bold = true },
    markdownH6 = { fg = c.syntax_constant, bold = true },
    markdownH1Delimiter = { link = "markdownH1" },
    markdownH2Delimiter = { link = "markdownH2" },
    markdownH3Delimiter = { link = "markdownH3" },
    markdownH4Delimiter = { link = "markdownH4" },
    markdownH5Delimiter = { link = "markdownH5" },
    markdownH6Delimiter = { link = "markdownH6" },
    markdownBold = { bold = true },
    markdownItalic = { italic = true },
    markdownBoldItalic = { bold = true, italic = true },
    markdownStrike = { strikethrough = true },
    markdownCode = { fg = c.syntax_string },
    markdownCodeBlock = { fg = c.syntax_string },
    markdownCodeDelimiter = { fg = c.fg_muted },
    markdownBlockquote = { fg = c.fg_muted, italic = true },
    markdownListMarker = { fg = c.secondary },
    markdownOrderedListMarker = { link = "markdownListMarker" },
    markdownRule = { fg = c.border },
    markdownLinkText = { fg = c.primary },
    markdownLinkDelimiter = { fg = c.syntax_punctuation },
    markdownUrl = { fg = c.url, underline = true },
    markdownUrlTitle = { link = "String" },
    markdownIdDeclaration = { link = "markdownLinkText" },
  })

  -- ── 48. Language: Vim / VimL ──────────────────────────────────────────────
  hi({
    vimCommand = { link = "Keyword" },
    vimCommentTitle = { fg = c.syntax_comment, bold = true },
    vimMapMod = { fg = c.syntax_escape },
    vimMapModKey = { fg = c.syntax_escape },
    vimNotation = { link = "Special" },
    vimOption = { fg = c.syntax_type },
    vimSetEqual = { link = "Operator" },
    vimSetSep = { fg = c.syntax_punctuation },
    vimSep = { fg = c.syntax_punctuation },
    vimHiGroup = { link = "Type" },
    vimHiLink = { link = "Keyword" },
    vimHiGuifg = { link = "@field" },
    vimHiGuibg = { link = "@field" },
    vimHiCterm = { link = "@field" },
    vimHiCtermFg = { link = "@field" },
    vimHiCtermBg = { link = "@field" },
    vimHiAttrib = { link = "Special" },
    vimAutoCmd = { link = "Keyword" },
    vimAutoCmdGroup = { link = "Type" },
    vimUserFunc = { link = "Function" },
    vimFunction = { link = "Function" },
    vimFuncName = { link = "Function" },
    vimFuncVar = { link = "@parameter" },
    vimVar = { link = "@variable" },
    vimLet = { link = "Keyword" },
  })

  -- ── 49. nvim-surround ─────────────────────────────────────────────────────
  hi({
    NvimSurroundHighlight = { fg = c.bg, bg = c.match_fg, bold = true },
    NvimSurroundHighlightTextObject = { link = "Visual" },
  })

  -- ── 50. vim-matchup ───────────────────────────────────────────────────────
  hi({
    MatchupVirtualText = { fg = c.fg_muted, italic = true },
    MatchWord = { link = "MatchParen" },
    MatchWordCur = { link = "MatchParen" },
    MatchParenCur = { link = "MatchParen" },
  })

  -- ── 51. nvim-ufo (folding) ────────────────────────────────────────────────
  hi({
    UfoFoldedFg = { fg = c.fg },
    UfoFoldedBg = { bg = c.bg_surface },
    UfoCursorFoldedLine = { link = "CursorLine" },
    UfoPreviewSbar = { link = "PmenuSbar" },
    UfoPreviewThumb = { link = "PmenuThumb" },
    UfoPreviewWinBar = { link = "WinBar" },
    UfoFoldedEllipsis = { fg = c.fg_muted },
  })

  -- ── 52. nvim-scrollbar ────────────────────────────────────────────────────
  hi({
    ScrollbarHandle = { bg = c.bg_highlight },
    ScrollbarCursor = { fg = c.fg, bg = c.bg_highlight },
    ScrollbarCursorHandle = { link = "ScrollbarCursor" },
    ScrollbarSearch = { fg = c.match_fg, bg = c.bg_surface },
    ScrollbarSearchHandle = { fg = c.match_fg, bg = c.bg_highlight },
    ScrollbarError = { link = "DiagnosticError" },
    ScrollbarErrorHandle = { link = "DiagnosticError" },
    ScrollbarWarn = { link = "DiagnosticWarn" },
    ScrollbarWarnHandle = { link = "DiagnosticWarn" },
    ScrollbarInfo = { link = "DiagnosticInfo" },
    ScrollbarInfoHandle = { link = "DiagnosticInfo" },
    ScrollbarHint = { link = "DiagnosticHint" },
    ScrollbarHintHandle = { link = "DiagnosticHint" },
    ScrollbarMisc = { fg = c.secondary, bg = c.bg_surface },
    ScrollbarMiscHandle = { fg = c.secondary, bg = c.bg_highlight },
    ScrollbarGitAdd = { link = "GitSignsAdd" },
    ScrollbarGitAddHandle = { link = "GitSignsAdd" },
    ScrollbarGitChange = { link = "GitSignsChange" },
    ScrollbarGitChangeHandle = { link = "GitSignsChange" },
    ScrollbarGitDelete = { link = "GitSignsDelete" },
    ScrollbarGitDeleteHandle = { link = "GitSignsDelete" },
  })

  -- ── 53. nvim-hlslens ──────────────────────────────────────────────────────
  hi({
    HlSearchNear = { link = "IncSearch" },
    HlSearchLens = { fg = c.fg_muted, bg = c.bg_surface, italic = true },
    HlSearchLensNear = { fg = c.match_fg, bg = c.bg_surface, bold = true },
    HlSearchFloat = { link = "Search" },
  })

  -- ── 54. copilot / AI completions ─────────────────────────────────────────
  hi({
    CopilotSuggestion = { fg = c.fg_muted, italic = true },
    CopilotAnnotation = { fg = c.fg_muted, italic = true },
    CodeiumSuggestion = { link = "CopilotSuggestion" },
    SupermavenSuggestion = { link = "CopilotSuggestion" },
  })

  -- ── 55. yanky.nvim ────────────────────────────────────────────────────────
  hi({
    YankyPut = { link = "IncSearch" },
    YankyYanked = { link = "IncSearch" },
  })

  -- ── 56. substitute.nvim ───────────────────────────────────────────────────
  hi({
    SubstituteRange = { link = "Search" },
    SubstituteExchange = { link = "IncSearch" },
  })

  -- ── 57. marks.nvim ────────────────────────────────────────────────────────
  hi({
    MarkSignHL = { fg = c.match_fg },
    MarkSignNumHL = { fg = c.match_fg },
    MarkVirtTextHL = { fg = c.fg_muted, italic = true },
  })

  -- ── 58. todo-comments.nvim ────────────────────────────────────────────────
  hi({
    TodoBgTODO = { fg = c.on_primary, bg = c.primary, bold = true },
    TodoFgTODO = { fg = c.primary },
    TodoSignTODO = { fg = c.primary },
    TodoBgNOTE = { fg = c.bg, bg = c.syntax_escape, bold = true },
    TodoFgNOTE = { fg = c.syntax_escape },
    TodoSignNOTE = { fg = c.syntax_escape },
    TodoBgFIX = { fg = c.bg, bg = c.error, bold = true },
    TodoFgFIX = { fg = c.error },
    TodoSignFIX = { fg = c.error },
    TodoBgWARN = { fg = c.bg, bg = c.match_fg, bold = true },
    TodoFgWARN = { fg = c.match_fg },
    TodoSignWARN = { fg = c.match_fg },
    TodoBgHACK = { fg = c.bg, bg = c.syntax_constant, bold = true },
    TodoFgHACK = { fg = c.syntax_constant },
    TodoSignHACK = { fg = c.syntax_constant },
    TodoBgPERF = { fg = c.bg, bg = c.secondary, bold = true },
    TodoFgPERF = { fg = c.secondary },
    TodoSignPERF = { fg = c.secondary },
    TodoBgTEST = { fg = c.bg, bg = c.success, bold = true },
    TodoFgTEST = { fg = c.success },
    TodoSignTEST = { fg = c.success },
  })

  -- ── 59. diffview.nvim ─────────────────────────────────────────────────────
  hi({
    DiffviewNormal = { link = "NormalFloat" },
    DiffviewCursorLine = { link = "CursorLine" },
    DiffviewVertSplit = { link = "VertSplit" },
    DiffviewSignColumn = { link = "SignColumn" },
    DiffviewStatusLine = { link = "StatusLine" },
    DiffviewStatusLineNC = { link = "StatusLineNC" },
    DiffviewEndOfBuffer = { link = "EndOfBuffer" },

    DiffviewFilePanelRootPath = { fg = c.primary, bold = true },
    DiffviewFilePanelTitle = { link = "Title" },
    DiffviewFilePanelCounter = { fg = c.secondary, bold = true },
    DiffviewFilePanelFileName = { fg = c.fg },
    DiffviewFilePanelInsertions = { fg = c.success },
    DiffviewFilePanelDeletions = { fg = c.error },
    DiffviewFilePanelConflicts = { fg = c.warning, bold = true },
    DiffviewFolderSign = { link = "Directory" },
    DiffviewFolderName = { link = "Directory" },
    DiffviewReference = { fg = c.syntax_escape },

    DiffviewStatusAdded = { link = "GitSignsAdd" },
    DiffviewStatusUntracked = { link = "GitSignsAdd" },
    DiffviewStatusCopied = { link = "GitSignsAdd" },
    DiffviewStatusModified = { link = "GitSignsChange" },
    DiffviewStatusRenamed = { link = "GitSignsChange" },
    DiffviewStatusDeleted = { link = "GitSignsDelete" },
    DiffviewStatusBroken = { link = "DiagnosticError" },
    DiffviewStatusIgnored = { fg = c.fg_muted },

    DiffviewConflictAncestor = { fg = c.fg, bg = c.diff_change },
    DiffviewConflictingChange = { fg = c.fg, bg = c.diff_text },
  })

  -- ── 60. neogit ────────────────────────────────────────────────────────────
  hi({
    NeogitNormal = { link = "NormalFloat" },
    NeogitCursorLine = { link = "CursorLine" },
    NeogitBranch = { fg = c.secondary },
    NeogitRemote = { fg = c.syntax_escape },
    NeogitBranchHead = { fg = c.secondary, bold = true },

    NeogitHunkHeader = { fg = c.primary, bg = d.hi_blue },
    NeogitHunkHeaderHighlight = { fg = c.primary, bg = d.hi_blue, bold = true },

    NeogitDiffAdd = { link = "DiffAdd" },
    NeogitDiffDelete = { link = "DiffDelete" },
    NeogitDiffContext = { fg = c.fg_muted },
    NeogitDiffContextHighlight = { fg = c.fg, bg = c.bg_highlight },
    NeogitDiffAddHighlight = { fg = c.success, bg = c.diff_add },
    NeogitDiffDeleteHighlight = { fg = c.error, bg = c.diff_delete },

    NeogitStagedChanges = { fg = c.success, bold = true },
    NeogitUnstagedChanges = { fg = c.warning, bold = true },
    NeogitUntrackedFiles = { fg = c.syntax_constant, bold = true },
    NeogitStashes = { fg = c.syntax_escape, bold = true },
    NeogitSectionHeader = { link = "Title" },

    NeogitGraphRed = { fg = c.error },
    NeogitGraphWhite = { fg = c.fg },
    NeogitGraphYellow = { fg = c.match_fg },
    NeogitGraphOrange = { fg = c.syntax_constant },
    NeogitGraphGreen = { fg = c.success },
    NeogitGraphBlue = { fg = c.primary },
    NeogitGraphPurple = { fg = c.secondary },
    NeogitGraphGray = { fg = c.fg_muted },
    NeogitGraphCyan = { fg = c.syntax_escape },

    NeogitPopupActionKey = { fg = c.match_fg },
    NeogitPopupSwitchKey = { fg = c.syntax_escape },
    NeogitPopupOptionKey = { fg = c.syntax_escape },
    NeogitPopupConfigKey = { fg = c.secondary },
    NeogitObjectId = { fg = c.syntax_constant, italic = true },
    NeogitFilePath = { link = "Directory" },
  })

  -- ── 61. octo.nvim ────────────────────────────────────────────────────────
  hi({
    OctoViewer = { fg = c.on_primary, bg = c.primary },
    OctoGreenFloat = { fg = c.success, bg = c.bg_surface },
    OctoRedFloat = { fg = c.error, bg = c.bg_surface },
    OctoPurpleFloat = { fg = c.secondary, bg = c.bg_surface },
    OctoBlueFloat = { fg = c.primary, bg = c.bg_surface },
    OctoYellowFloat = { fg = c.match_fg, bg = c.bg_surface },
    OctoGrey = { fg = c.fg_muted },
    OctoRed = { fg = c.error },
    OctoGreen = { fg = c.success },
    OctoBlue = { fg = c.primary },
    OctoPurple = { fg = c.secondary },
    OctoYellow = { fg = c.match_fg },
    OctoDetailsLabel = { fg = c.syntax_escape, bold = true },
    OctoDetailsValue = { fg = c.fg },
    OctoMissingDetails = { fg = c.fg_muted, italic = true },
    OctoEditable = { bg = c.selection },
    OctoIssueTitle = { link = "Title" },

    OctoPRChangedFile = { link = "GitSignsChange" },
    OctoPRAddedFile = { link = "GitSignsAdd" },
    OctoPRDeletedFile = { link = "GitSignsDelete" },

    OctoStateOpen = { fg = c.success },
    OctoStateClosed = { fg = c.error },
    OctoStateMerged = { fg = c.secondary },
    OctoStateDraft = { fg = c.fg_muted },
    OctoStatePending = { fg = c.warning },
    OctoStateApproved = { fg = c.success, bold = true },
    OctoStateChangesRequested = { fg = c.error, bold = true },
    OctoStateCommented = { fg = c.primary },
    OctoStateDismissed = { fg = c.fg_muted },
  })

  -- ── 62. overseer.nvim ────────────────────────────────────────────────────
  hi({
    OverseerPENDING = { fg = c.fg_muted },
    OverseerRUNNING = { fg = c.warning },
    OverseerSUCCESS = { fg = c.success },
    OverseerCANCELED = { fg = c.fg_muted },
    OverseerFAILURE = { fg = c.error },
    OverseerTask = { fg = c.fg, bold = true },
    OverseerTaskBorder = { link = "FloatBorder" },
    OverseerOutput = { fg = c.fg },
    OverseerComponent = { fg = c.syntax_escape },
    OverseerField = { link = "@field" },
  })

  -- ── 63. harpoon ───────────────────────────────────────────────────────────
  hi({
    HarpoonBorder = { link = "FloatBorder" },
    HarpoonWindow = { link = "NormalFloat" },
    HarpoonCurrentFile = { fg = c.primary, bold = true },
    HarpoonNumberActive = { fg = c.match_fg, bold = true },
    HarpoonNumber = { fg = c.fg_muted },
  })

  -- ── 64. nvim-spectre ──────────────────────────────────────────────────────
  hi({
    SpectreSearch = { link = "Search" },
    SpectreReplace = { fg = c.bg, bg = c.success },
    SpectreFile = { link = "Directory" },
    SpectreDir = { link = "Directory" },
    SpectreHeader = { link = "Title" },
    SpectreBorder = { link = "FloatBorder" },
    SpectreBody = { link = "Normal" },
    SpectreChangeSign = { link = "GitSignsChange" },
  })

  -- ── 65. zen-mode.nvim / twilight.nvim ────────────────────────────────────
  hi({
    ZenBg = { bg = c.bg },
    TwilightInactive = { fg = c.fg_muted },
  })

  -- ── 66. oil.nvim ──────────────────────────────────────────────────────────
  hi({
    OilDir = { link = "Directory" },
    OilFile = { fg = c.fg },
    OilLink = { fg = c.url, italic = true },
    OilSocket = { fg = c.secondary },
    OilPipe = { fg = c.syntax_constant },
    OilCopy = { fg = c.match_fg },
    OilMove = { fg = c.success },
    OilCreate = { fg = c.success, bold = true },
    OilDelete = { fg = c.error },
    OilRestore = { fg = c.syntax_escape },
    OilPurge = { fg = c.error, bold = true },
    OilTrash = { fg = c.error, italic = true },
    OilTrashSourcePath = { fg = c.fg_muted, italic = true },
    OilPermissionRead = { fg = c.match_fg },
    OilPermissionWrite = { fg = c.error },
    OilPermissionExecute = { fg = c.success },
    OilTypeDir = { link = "Directory" },
    OilTypeFile = { fg = c.fg_muted },
    OilTypeLink = { fg = c.url },
    OilTypeSocket = { fg = c.secondary },
    OilTypePipe = { fg = c.syntax_constant },
    OilChange = { link = "GitSignsChange" },
    OilAdd = { link = "GitSignsAdd" },
    OilDelete2 = { link = "GitSignsDelete" },
  })

  -- ── 67. symbol-usage.nvim ────────────────────────────────────────────────
  hi({
    SymbolUsageRef = { fg = c.fg_muted, italic = true },
    SymbolUsageDef = { fg = c.fg_muted, italic = true },
    SymbolUsageImpl = { fg = c.fg_muted, italic = true },
    SymbolUsageRefBg = { fg = c.fg_muted, bg = d.hi_blue, italic = true },
    SymbolUsageDefBg = { fg = c.fg_muted, bg = d.hi_magenta, italic = true },
    SymbolUsageImplBg = { fg = c.fg_muted, bg = d.hi_green, italic = true },
  })

  -- ── 68. inc-rename.nvim ───────────────────────────────────────────────────
  hi({
    IncRename = { fg = c.match_fg, bold = true },
    IncRenameRange = { link = "Visual" },
  })

  -- ── 69. treesitter-context ────────────────────────────────────────────────
  hi({
    TreesitterContext = { bg = c.bg_surface },
    TreesitterContextLineNumber = { fg = c.fg_muted, bg = c.bg_surface },
    TreesitterContextSeparator = { fg = c.border },
    TreesitterContextBottom = { underline = true, sp = c.border },
  })

  -- ── 70. nvim-lint / none-ls ───────────────────────────────────────────────
  hi({
    NullLsInfoBorder = { link = "FloatBorder" },
    LintError = { link = "DiagnosticError" },
    LintWarn = { link = "DiagnosticWarn" },
    LintInfo = { link = "DiagnosticInfo" },
    LintHint = { link = "DiagnosticHint" },
  })

  -- ── 71. vim-startuptime ───────────────────────────────────────────────────
  hi({
    StartupTimeHeader = { link = "Title" },
    StartupTimeSourcing = { fg = c.primary },
    StartupTimePlugin = { fg = c.syntax_escape },
    StartupTimeTimes = { fg = c.match_fg },
    StartupTimeMsTotal = { fg = c.syntax_constant, bold = true },
  })
end

return M
