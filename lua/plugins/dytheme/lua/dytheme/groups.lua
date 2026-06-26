local M = {}

function M.apply(c)
  local blend = require("dytheme.util").blend

  -- Derived colors
  -- Ratio guide: 0.0 = pure bg, 1.0 = pure accent.
  local d = {
    -- diff / hunk backgrounds
    diff_add = blend(c.bg, c.green, 0.15),
    diff_change = blend(c.bg, c.yellow, 0.15),
    diff_delete = blend(c.bg, c.red, 0.15),
    diff_text = blend(c.bg, c.orange, 0.20),

    -- headline row backgrounds (slightly lighter base)
    hi_blue = blend(c.bg_alt, c.blue, 0.18),
    hi_magenta = blend(c.bg_alt, c.magenta, 0.18),
    hi_green = blend(c.bg_alt, c.green, 0.18),
  }

  local function hi(groups)
    for name, opts in pairs(groups) do
      vim.api.nvim_set_hl(0, name, opts)
    end
  end

  -- ── 1. Base editor ───────────────────────────────────────────────────────
  hi({
    Normal = { fg = c.fg, bg = c.bg },
    NormalNC = { fg = c.fg_dim, bg = c.bg },
    NormalFloat = { fg = c.fg, bg = c.bg },
    FloatBorder = { fg = c.border, bg = c.bg },
    FloatTitle = { fg = c.blue, bg = c.bg, bold = true },
    FloatFooter = { fg = c.comment, bg = c.bg },

    CursorLine = { bg = c.sel },
    CursorColumn = { bg = c.sel },
    CursorLineNr = { fg = c.yellow, bold = true },
    LineNr = { fg = c.comment },
    LineNrAbove = { link = "LineNr" },
    LineNrBelow = { link = "LineNr" },
    SignColumn = { bg = c.bg },
    ColorColumn = { bg = c.bg_alt },

    VertSplit = { fg = c.border },
    WinSeparator = { link = "VertSplit" },

    Folded = { fg = c.fg_dim, bg = c.bg_alt },
    FoldColumn = { fg = c.comment, bg = c.bg },

    Visual = { bg = c.sel },
    VisualNOS = { link = "Visual" },
    Search = { fg = c.bg, bg = c.yellow },
    IncSearch = { fg = c.bg, bg = c.orange },
    CurSearch = { link = "IncSearch" },
    Substitute = { fg = c.bg, bg = c.red },

    Pmenu = { fg = c.fg, bg = c.bg_alt },
    PmenuSel = { fg = c.bg, bg = c.blue },
    PmenuSbar = { bg = c.bg_alt },
    PmenuThumb = { bg = c.border },
    PmenuKind = { link = "Pmenu" },
    PmenuKindSel = { link = "PmenuSel" },
    PmenuExtra = { fg = c.fg_dim, bg = c.bg_alt },
    PmenuExtraSel = { link = "PmenuSel" },

    StatusLine = { fg = c.fg, bg = c.bg_alt },
    StatusLineNC = { fg = c.fg_dim, bg = c.bg_alt },
    TabLine = { fg = c.fg_dim, bg = c.bg_alt },
    TabLineSel = { fg = c.fg, bg = c.bg, bold = true },
    TabLineFill = { bg = c.bg_alt },
    WinBar = { fg = c.fg_dim, bg = c.bg },
    WinBarNC = { fg = c.comment, bg = c.bg },

    MatchParen = { fg = c.orange, bold = true, underline = true },
    Conceal = { fg = c.comment },
    SpecialKey = { fg = c.comment },
    NonText = { fg = c.comment },
    Whitespace = { fg = c.border },
    EndOfBuffer = { fg = c.bg },

    SpellBad = { undercurl = true, sp = c.red },
    SpellCap = { undercurl = true, sp = c.yellow },
    SpellRare = { undercurl = true, sp = c.cyan },
    SpellLocal = { undercurl = true, sp = c.green },

    Question = { fg = c.blue },
    MoreMsg = { fg = c.green },
    ModeMsg = { fg = c.fg, bold = true },
    WarningMsg = { fg = c.yellow },
    ErrorMsg = { fg = c.red },

    Directory = { fg = c.blue },
    Title = { fg = c.blue, bold = true },
    QuickFixLine = { bg = c.sel, bold = true },
    qfLineNr = { link = "LineNr" },
    qfFileName = { link = "Directory" },
  })

  -- ── 2. Syntax (classic groups — Treesitter links to these) ───────────────
  hi({
    Comment = { fg = c.comment, italic = true },

    Constant = { fg = c.orange },
    String = { fg = c.green },
    Character = { link = "String" },
    Number = { fg = c.orange },
    Float = { link = "Number" },
    Boolean = { fg = c.orange },

    Identifier = { fg = c.fg },
    Function = { fg = c.blue },

    Statement = { fg = c.magenta },
    Conditional = { link = "Statement" },
    Repeat = { link = "Statement" },
    Label = { link = "Statement" },
    Keyword = { fg = c.magenta, bold = true },
    Exception = { fg = c.red },

    Operator = { fg = c.cyan },
    PreProc = { fg = c.red },
    Include = { link = "PreProc" },
    Define = { link = "PreProc" },
    Macro = { link = "PreProc" },
    PreCondit = { link = "PreProc" },

    Type = { fg = c.yellow },
    StorageClass = { link = "Type" },
    Structure = { link = "Type" },
    Typedef = { link = "Type" },

    Special = { fg = c.cyan },
    SpecialChar = { link = "Special" },
    Tag = { link = "Special" },
    Delimiter = { fg = c.fg_dim },
    SpecialComment = { fg = c.comment, italic = true },
    Debug = { fg = c.orange },

    Underlined = { fg = c.blue, underline = true },
    Ignore = { fg = c.comment },
    Error = { fg = c.red },
    Todo = { fg = c.yellow, bold = true, reverse = true },
  })

  -- ── 3. Treesitter ─────────────────────────────────────────────────────────
  hi({
    ["@comment"] = { link = "Comment" },
    ["@comment.documentation"] = { fg = c.comment, italic = true },

    ["@string"] = { link = "String" },
    ["@string.escape"] = { fg = c.cyan },
    ["@string.special"] = { link = "SpecialChar" },
    ["@string.regex"] = { fg = c.cyan },

    ["@number"] = { link = "Number" },
    ["@float"] = { link = "Float" },
    ["@boolean"] = { link = "Boolean" },

    ["@keyword"] = { link = "Keyword" },
    ["@keyword.return"] = { fg = c.red },
    ["@keyword.operator"] = { link = "Operator" },
    ["@keyword.import"] = { link = "Include" },
    ["@keyword.coroutine"] = { fg = c.magenta, italic = true },
    ["@keyword.exception"] = { link = "Exception" },

    ["@function"] = { link = "Function" },
    ["@function.builtin"] = { fg = c.cyan },
    ["@function.call"] = { link = "Function" },
    ["@function.macro"] = { link = "Macro" },
    ["@function.method"] = { link = "Function" },
    ["@function.method.call"] = { link = "Function" },

    ["@constructor"] = { fg = c.blue },
    ["@parameter"] = { fg = c.orange },
    ["@variable"] = { link = "Identifier" },
    ["@variable.builtin"] = { fg = c.red },
    ["@variable.member"] = { fg = c.cyan },
    ["@variable.parameter"] = { link = "@parameter" },

    ["@type"] = { link = "Type" },
    ["@type.builtin"] = { fg = c.yellow, italic = true },
    ["@type.definition"] = { link = "Typedef" },
    ["@type.qualifier"] = { link = "Type" },

    ["@field"] = { fg = c.cyan },
    ["@property"] = { link = "@field" },
    ["@attribute"] = { fg = c.yellow },
    ["@namespace"] = { fg = c.blue, italic = true },
    ["@module"] = { link = "@namespace" },

    ["@operator"] = { link = "Operator" },
    ["@punctuation.bracket"] = { fg = c.fg_dim },
    ["@punctuation.delimiter"] = { fg = c.fg_dim },
    ["@punctuation.special"] = { fg = c.cyan },

    ["@tag"] = { fg = c.red },
    ["@tag.attribute"] = { fg = c.yellow },
    ["@tag.delimiter"] = { fg = c.border },

    ["@text"] = { link = "Normal" },
    ["@text.title"] = { link = "Title" },
    ["@text.strong"] = { bold = true },
    ["@text.emphasis"] = { italic = true },
    ["@text.underline"] = { underline = true },
    ["@text.strike"] = { strikethrough = true },
    ["@text.literal"] = { fg = c.green },
    ["@text.uri"] = { fg = c.cyan, underline = true },
    ["@text.todo"] = { link = "Todo" },
    ["@text.warning"] = { link = "WarningMsg" },
    ["@text.danger"] = { link = "ErrorMsg" },
    ["@text.reference"] = { fg = c.blue },
    ["@text.diff.add"] = { link = "DiffAdd" },
    ["@text.diff.delete"] = { link = "DiffDelete" },

    -- markdown via treesitter
    ["@markup.heading"] = { link = "Title" },
    ["@markup.strong"] = { bold = true },
    ["@markup.italic"] = { italic = true },
    ["@markup.strikethrough"] = { strikethrough = true },
    ["@markup.underline"] = { underline = true },
    ["@markup.raw"] = { fg = c.green },
    ["@markup.link"] = { fg = c.blue },
    ["@markup.link.url"] = { fg = c.cyan, underline = true },
    ["@markup.link.label"] = { fg = c.blue },
    ["@markup.list"] = { fg = c.magenta },
    ["@markup.list.checked"] = { fg = c.green },
    ["@markup.list.unchecked"] = { fg = c.fg_dim },
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
    -- modifiers
    ["@lsp.mod.deprecated"] = { strikethrough = true },
    ["@lsp.mod.readonly"] = { italic = true },
    ["@lsp.mod.static"] = { italic = true },

    LspReferenceText = { bg = c.sel },
    LspReferenceRead = { bg = c.sel },
    LspReferenceWrite = { bg = c.sel, bold = true },
    LspReferenceTarget = { bg = c.sel, reverse = true },
    LspSignatureActiveParameter = { fg = c.orange, bold = true },
    LspInfoBorder = { link = "FloatBorder" },
    LspCodeLens = { fg = c.comment, italic = true },
    LspCodeLensSeparator = { fg = c.border },
    LspInlayHint = { fg = c.comment },
  })

  -- ── 5. Diagnostics ────────────────────────────────────────────────────────
  hi({
    DiagnosticError = { fg = c.red },
    DiagnosticWarn = { fg = c.yellow },
    DiagnosticInfo = { fg = c.blue },
    DiagnosticHint = { fg = c.cyan },
    DiagnosticOk = { fg = c.green },
    DiagnosticUnnecessary = { fg = c.fg_dim, italic = true },
    DiagnosticDeprecated = { fg = c.fg_dim, strikethrough = true },

    DiagnosticUnderlineError = { undercurl = true, sp = c.red },
    DiagnosticUnderlineWarn = { undercurl = true, sp = c.yellow },
    DiagnosticUnderlineInfo = { undercurl = true, sp = c.blue },
    DiagnosticUnderlineHint = { undercurl = true, sp = c.cyan },

    DiagnosticVirtualTextError = { fg = c.red, bg = c.bg_alt, italic = true },
    DiagnosticVirtualTextWarn = { fg = c.yellow, bg = c.bg_alt, italic = true },
    DiagnosticVirtualTextInfo = { fg = c.blue, bg = c.bg_alt, italic = true },
    DiagnosticVirtualTextHint = { fg = c.cyan, bg = c.bg_alt, italic = true },

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
    DiffAdd = { fg = c.green, bg = d.diff_add },
    DiffChange = { fg = c.yellow, bg = d.diff_change },
    DiffDelete = { fg = c.red, bg = d.diff_delete },
    DiffText = { fg = c.orange, bg = d.diff_text, bold = true },
    Added = { link = "DiffAdd" },
    Changed = { link = "DiffChange" },
    Removed = { link = "DiffDelete" },
  })

  -- ── 7. gitsigns.nvim ──────────────────────────────────────────────────────
  hi({
    GitSignsAdd = { fg = c.green },
    GitSignsChange = { fg = c.yellow },
    GitSignsDelete = { fg = c.red },
    GitSignsAddNr = { link = "GitSignsAdd" },
    GitSignsChangeNr = { link = "GitSignsChange" },
    GitSignsDeleteNr = { link = "GitSignsDelete" },
    GitSignsAddLn = { link = "DiffAdd" },
    GitSignsChangeLn = { link = "DiffChange" },
    GitSignsDeleteLn = { link = "DiffDelete" },
    GitSignsCurrentLineBlame = { fg = c.comment, italic = true },
    GitSignsAddInline = { fg = c.bg, bg = c.green },
    GitSignsDeleteInline = { fg = c.bg, bg = c.red },
    GitSignsChangeInline = { fg = c.bg, bg = c.yellow },
  })

  -- ── 8. Telescope ──────────────────────────────────────────────────────────
  hi({
    TelescopeNormal = { fg = c.fg, bg = c.bg_alt },
    TelescopeBorder = { fg = c.border, bg = c.bg_alt },
    TelescopePromptNormal = { fg = c.fg, bg = c.sel },
    TelescopePromptBorder = { fg = c.blue, bg = c.sel },
    TelescopePromptTitle = { fg = c.bg, bg = c.blue, bold = true },
    TelescopePreviewTitle = { fg = c.bg, bg = c.green, bold = true },
    TelescopeResultsTitle = { fg = c.border, bg = c.bg_alt },
    TelescopeSelection = { bg = c.sel },
    TelescopeSelectionCaret = { fg = c.blue, bg = c.sel },
    TelescopeMultiSelection = { fg = c.cyan, bg = c.sel },
    TelescopeMatching = { fg = c.yellow, bold = true },
    TelescopePromptPrefix = { fg = c.blue },
    TelescopePromptCounter = { fg = c.fg_dim },
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
    FzfLuaSel = { fg = c.bg, bg = c.blue },
    FzfLuaSelMulti = { fg = c.bg, bg = c.cyan },
    FzfLuaHeader = { fg = c.green, bold = true },
    FzfLuaHeaderBind = { fg = c.yellow },
  })

  -- ── 10. nvim-cmp ──────────────────────────────────────────────────────────
  hi({
    CmpItemAbbr = { fg = c.fg },
    CmpItemAbbrMatch = { fg = c.blue, bold = true },
    CmpItemAbbrMatchFuzzy = { fg = c.cyan, bold = true },
    CmpItemAbbrDeprecated = { fg = c.fg_dim, strikethrough = true },
    CmpItemMenu = { fg = c.fg_dim, italic = true },
    CmpGhostText = { fg = c.comment, italic = true },

    -- kind icons inherit from syntax groups
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
    CmpItemKindSnippet = { fg = c.green },
    CmpItemKindColor = { fg = c.orange },
    CmpItemKindFile = { link = "Directory" },
    CmpItemKindReference = { link = "@text.reference" },
    CmpItemKindFolder = { link = "Directory" },
    CmpItemKindEnumMember = { link = "@field" },
    CmpItemKindConstant = { link = "Constant" },
    CmpItemKindStruct = { link = "Structure" },
    CmpItemKindEvent = { fg = c.magenta },
    CmpItemKindOperator = { link = "Operator" },
    CmpItemKindTypeParameter = { link = "Type" },
    CmpItemKindCopilot = { fg = c.comment },
  })

  -- ── 11. blink.cmp ─────────────────────────────────────────────────────────
  -- LazyVim is migrating to blink.cmp; cover both
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
    WhichKey = { fg = c.cyan },
    WhichKeyGroup = { fg = c.blue },
    WhichKeyDesc = { fg = c.fg },
    WhichKeySeparator = { fg = c.comment },
    WhichKeyFloat = { link = "NormalFloat" },
    WhichKeyBorder = { link = "FloatBorder" },
    WhichKeyTitle = { link = "FloatTitle" },
    WhichKeyValue = { fg = c.fg_dim },
    WhichKeyIcon = { fg = c.yellow },
  })

  -- ── 13. neo-tree ──────────────────────────────────────────────────────────
  hi({
    NeoTreeNormal = { fg = c.fg, bg = c.bg_alt },
    NeoTreeNormalNC = { fg = c.fg_dim, bg = c.bg_alt },
    NeoTreeEndOfBuffer = { fg = c.bg_alt, bg = c.bg_alt },
    NeoTreeCursorLine = { link = "CursorLine" },
    NeoTreeVertSplit = { link = "VertSplit" },
    NeoTreeWinSeparator = { link = "WinSeparator" },
    NeoTreeStatusLine = { link = "StatusLine" },
    NeoTreeStatusLineNC = { link = "StatusLineNC" },

    NeoTreeRootName = { fg = c.blue, bold = true },
    NeoTreeDirectoryName = { link = "Directory" },
    NeoTreeDirectoryIcon = { link = "Directory" },
    NeoTreeFileName = { fg = c.fg },
    NeoTreeFileNameOpened = { fg = c.blue },
    NeoTreeFileIcon = { fg = c.fg_dim },
    NeoTreeSymbolicLinkTarget = { fg = c.cyan, italic = true },

    NeoTreeGitAdded = { fg = c.green },
    NeoTreeGitConflict = { fg = c.red, bold = true },
    NeoTreeGitDeleted = { fg = c.red },
    NeoTreeGitIgnored = { fg = c.comment },
    NeoTreeGitModified = { fg = c.yellow },
    NeoTreeGitUnstaged = { link = "NeoTreeGitModified" },
    NeoTreeGitUntracked = { fg = c.orange },
    NeoTreeGitStaged = { link = "NeoTreeGitAdded" },

    NeoTreeIndentMarker = { fg = c.border },
    NeoTreeExpander = { fg = c.border },
    NeoTreeTitleBar = { fg = c.bg, bg = c.blue },
    NeoTreeFloatBorder = { link = "FloatBorder" },
    NeoTreeFloatTitle = { link = "FloatTitle" },

    NeoTreeDimText = { fg = c.fg_dim },
    NeoTreeFilterTerm = { fg = c.yellow, bold = true },
    NeoTreeModified = { fg = c.yellow },
    NeoTreeTabActive = { link = "TabLineSel" },
    NeoTreeTabInactive = { link = "TabLine" },
    NeoTreeTabSeparatorActive = { fg = c.blue, bg = c.bg },
    NeoTreeTabSeparatorInactive = { fg = c.border, bg = c.bg_alt },
  })

  -- ── 14. nvim-tree ─────────────────────────────────────────────────────────
  hi({
    NvimTreeNormal = { link = "NeoTreeNormal" },
    NvimTreeNormalNC = { link = "NeoTreeNormalNC" },
    NvimTreeFolderName = { link = "Directory" },
    NvimTreeRootFolder = { fg = c.blue, bold = true },
    NvimTreeFolderIcon = { link = "Directory" },
    NvimTreeFileIcon = { fg = c.fg_dim },
    NvimTreeFileName = { fg = c.fg },
    NvimTreeOpenedFile = { fg = c.blue },
    NvimTreeExecFile = { fg = c.green, bold = true },
    NvimTreeSpecialFile = { fg = c.yellow },
    NvimTreeSymlink = { fg = c.cyan, italic = true },
    NvimTreeGitDirty = { link = "NeoTreeGitModified" },
    NvimTreeGitStaged = { link = "NeoTreeGitAdded" },
    NvimTreeGitNew = { link = "NeoTreeGitUntracked" },
    NvimTreeGitDeleted = { link = "NeoTreeGitDeleted" },
    NvimTreeIndentMarker = { link = "NeoTreeIndentMarker" },
    NvimTreeCursorLine = { link = "CursorLine" },
    NvimTreeVertSplit = { link = "VertSplit" },
    NvimTreeWindowPicker = { fg = c.bg, bg = c.blue, bold = true },
  })

  -- ── 15. indent-blankline / ibl ────────────────────────────────────────────
  hi({
    IblIndent = { fg = c.border },
    IblScope = { fg = c.comment },
    IblWhitespace = { fg = c.border },
    -- v2 names (indent_blankline.nvim)
    IndentBlanklineChar = { link = "IblIndent" },
    IndentBlanklineContextChar = { link = "IblScope" },
    IndentBlanklineSpaceChar = { link = "IblWhitespace" },
  })

  -- ── 16. lualine ───────────────────────────────────────────────────────────
  -- lualine draws its own highlights from its theme config, but these
  -- base groups let you hook in before the theme is set:
  hi({
    StatusLineTerm = { link = "StatusLine" },
    StatusLineTermNC = { link = "StatusLineNC" },
  })

  -- ── 17. bufferline.nvim ───────────────────────────────────────────────────
  hi({
    BufferLineBackground = { fg = c.fg_dim, bg = c.bg_alt },
    BufferLineFill = { bg = c.bg_alt },
    BufferLineBufferSelected = { fg = c.fg, bg = c.bg, bold = true },
    BufferLineBufferVisible = { fg = c.fg_dim, bg = c.bg_alt },
    BufferLineCloseButton = { fg = c.fg_dim, bg = c.bg_alt },
    BufferLineCloseButtonSelected = { fg = c.red, bg = c.bg },
    BufferLineCloseButtonVisible = { link = "BufferLineCloseButton" },
    BufferLineSeparator = { fg = c.border, bg = c.bg_alt },
    BufferLineSeparatorSelected = { fg = c.border, bg = c.bg },
    BufferLineModified = { fg = c.yellow, bg = c.bg_alt },
    BufferLineModifiedSelected = { fg = c.yellow, bg = c.bg },
    BufferLinePick = { fg = c.red, bg = c.bg_alt, bold = true },
    BufferLinePickSelected = { fg = c.red, bg = c.bg, bold = true },
    BufferLineTab = { link = "TabLine" },
    BufferLineTabSelected = { link = "TabLineSel" },
    BufferLineTabClose = { link = "BufferLineCloseButton" },
    BufferLineIndicatorSelected = { fg = c.blue, bg = c.bg },
    BufferLineError = { link = "DiagnosticError" },
    BufferLineErrorSelected = { link = "DiagnosticError" },
    BufferLineWarning = { link = "DiagnosticWarn" },
    BufferLineWarningSelected = { link = "DiagnosticWarn" },
    BufferLineInfo = { link = "DiagnosticInfo" },
    BufferLineInfoSelected = { link = "DiagnosticInfo" },
    BufferLineHint = { link = "DiagnosticHint" },
    BufferLineHintSelected = { link = "DiagnosticHint" },
  })

  -- ── 18. Snacks.nvim (LazyVim's core utility) ──────────────────────────────
  hi({
    -- dashboard
    SnacksDashboardHeader = { fg = c.blue, bold = true },
    SnacksDashboardFooter = { fg = c.comment, italic = true },
    SnacksDashboardKey = { fg = c.yellow },
    SnacksDashboardDesc = { fg = c.fg },
    SnacksDashboardIcon = { fg = c.cyan },
    SnacksDashboardTitle = { link = "Title" },
    SnacksDashboardDir = { fg = c.fg_dim },
    SnacksDashboardFile = { link = "Directory" },
    SnacksDashboardSpecial = { fg = c.magenta },
    -- notifier
    SnacksNotifierInfo = { link = "DiagnosticInfo" },
    SnacksNotifierWarn = { link = "DiagnosticWarn" },
    SnacksNotifierError = { link = "DiagnosticError" },
    SnacksNotifierDebug = { fg = c.fg_dim },
    SnacksNotifierTrace = { fg = c.comment },
    SnacksNotifierBorderInfo = { fg = c.blue },
    SnacksNotifierBorderWarn = { fg = c.yellow },
    SnacksNotifierBorderError = { fg = c.red },
    -- picker (snacks picker)
    SnacksPickerMatch = { link = "Search" },
    SnacksPickerListCursorLine = { link = "CursorLine" },
    SnacksPickerSelected = { fg = c.cyan },
    SnacksPickerBorder = { link = "FloatBorder" },
    SnacksPickerTitle = { link = "FloatTitle" },
    -- words / illuminate
    SnacksWordsReference = { link = "LspReferenceText" },
    SnacksWordsWrite = { link = "LspReferenceWrite" },
    -- indent
    SnacksIndent = { link = "IblIndent" },
    SnacksIndentScope = { link = "IblScope" },
    -- scroll
    SnacksScrollBar = { fg = c.border },
    SnacksScrollCurrent = { fg = c.blue },
  })

  -- ── 19. noice.nvim ────────────────────────────────────────────────────────
  hi({
    NoiceCompletionItemKindDefault = { link = "CmpItemAbbr" },
    NoiceCmdline = { fg = c.fg, bg = c.bg_alt },
    NoiceCmdlineIcon = { fg = c.blue },
    NoiceCmdlineIconSearch = { fg = c.yellow },
    NoiceCmdlinePopup = { link = "NormalFloat" },
    NoiceCmdlinePopupBorder = { link = "FloatBorder" },
    NoiceCmdlinePopupTitle = { link = "FloatTitle" },
    NoiceConfirm = { link = "NormalFloat" },
    NoiceConfirmBorder = { link = "FloatBorder" },
    NoicePopup = { link = "NormalFloat" },
    NoicePopupBorder = { link = "FloatBorder" },
    NoiceSplitBorder = { link = "FloatBorder" },
    NoiceFormatProgressTodo = { fg = c.fg_dim },
    NoiceFormatProgressDone = { fg = c.green, bold = true },
    NoiceLspProgressTitle = { fg = c.fg },
    NoiceLspProgressClient = { fg = c.blue },
    NoiceLspProgressSpinner = { fg = c.cyan },
    NoiceMini = { link = "NormalFloat" },
    NoiceScrollbar = { link = "PmenuSbar" },
    NoiceScrollbarThumb = { link = "PmenuThumb" },
  })

  -- ── 20. nvim-notify ───────────────────────────────────────────────────────
  hi({
    NotifyBackground = { bg = c.bg },
    NotifyERRORBorder = { fg = c.red },
    NotifyWARNBorder = { fg = c.yellow },
    NotifyINFOBorder = { fg = c.blue },
    NotifyDEBUGBorder = { fg = c.comment },
    NotifyTRACEBorder = { fg = c.magenta },
    NotifyERRORIcon = { link = "DiagnosticError" },
    NotifyWARNIcon = { link = "DiagnosticWarn" },
    NotifyINFOIcon = { link = "DiagnosticInfo" },
    NotifyDEBUGIcon = { fg = c.comment },
    NotifyTRACEIcon = { fg = c.magenta },
    NotifyERRORTitle = { link = "DiagnosticError" },
    NotifyWARNTitle = { link = "DiagnosticWarn" },
    NotifyINFOTitle = { link = "DiagnosticInfo" },
    NotifyDEBUGTitle = { fg = c.comment },
    NotifyTRACETitle = { fg = c.magenta },
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
    TroubleCount = { fg = c.magenta, bold = true },
    TroubleError = { link = "DiagnosticError" },
    TroubleWarning = { link = "DiagnosticWarn" },
    TroubleInformation = { link = "DiagnosticInfo" },
    TroubleHint = { link = "DiagnosticHint" },
    TroubleText = { fg = c.fg },
    TroubleDirectory = { link = "Directory" },
    TroubleFile = { fg = c.fg },
    TroubleLocation = { fg = c.fg_dim },
    TroubleSignError = { link = "DiagnosticError" },
    TroubleSignWarning = { link = "DiagnosticWarn" },
    TroubleSignInformation = { link = "DiagnosticInfo" },
    TroubleSignHint = { link = "DiagnosticHint" },
    TroubleIndent = { link = "IblIndent" },
    TroublePos = { fg = c.comment },
    TroubleCode = { fg = c.comment },
    TroubleSource = { fg = c.fg_dim, italic = true },
    TroublePreview = { link = "CursorLine" },
  })

  -- ── 22. flash.nvim ────────────────────────────────────────────────────────
  hi({
    FlashBackdrop = { fg = c.fg_dim },
    FlashMatch = { fg = c.bg, bg = c.yellow },
    FlashCurrent = { fg = c.bg, bg = c.orange },
    FlashLabel = { fg = c.bg, bg = c.red, bold = true },
    FlashPrompt = { link = "NoiceCmdline" },
    FlashPromptIcon = { fg = c.red },
    FlashCursor = { link = "Cursor" },
  })

  -- ── 23. leap.nvim ─────────────────────────────────────────────────────────
  hi({
    LeapMatch = { link = "FlashMatch" },
    LeapLabelPrimary = { link = "FlashLabel" },
    LeapLabelSecondary = { fg = c.bg, bg = c.magenta, bold = true },
    LeapBackdrop = { link = "FlashBackdrop" },
  })

  -- ── 24. mini.nvim ─────────────────────────────────────────────────────────
  hi({
    -- mini.statusline
    MiniStatuslineModeNormal = { fg = c.bg, bg = c.blue, bold = true },
    MiniStatuslineModeInsert = { fg = c.bg, bg = c.green, bold = true },
    MiniStatuslineModeVisual = { fg = c.bg, bg = c.magenta, bold = true },
    MiniStatuslineModeReplace = { fg = c.bg, bg = c.red, bold = true },
    MiniStatuslineModeCommand = { fg = c.bg, bg = c.yellow, bold = true },
    MiniStatuslineModeOther = { fg = c.bg, bg = c.cyan, bold = true },
    MiniStatuslineFilename = { link = "StatusLine" },
    MiniStatuslineFileinfo = { link = "StatusLine" },
    MiniStatuslineDevinfo = { link = "StatusLine" },
    MiniStatuslineInactive = { link = "StatusLineNC" },
    -- mini.tabline
    MiniTablineCurrent = { link = "TabLineSel" },
    MiniTablineVisible = { link = "TabLine" },
    MiniTablineHidden = { link = "TabLine" },
    MiniTablineFill = { link = "TabLineFill" },
    MiniTablineModifiedCurrent = { fg = c.yellow, bg = c.bg, bold = true },
    MiniTablineModifiedVisible = { fg = c.yellow, bg = c.bg_alt },
    MiniTablineModifiedHidden = { link = "MiniTablineModifiedVisible" },
    -- mini.completion
    MiniCompletionActiveParameter = { link = "LspSignatureActiveParameter" },
    -- mini.cursorword
    MiniCursorword = { link = "LspReferenceText" },
    MiniCursorwordCurrent = { link = "LspReferenceText" },
    -- mini.indentscope
    MiniIndentscopeSymbol = { link = "IblScope" },
    MiniIndentscopePrefix = { link = "IblIndent" },
    -- mini.jump
    MiniJump = { link = "FlashLabel" },
    MiniJump2dSpot = { link = "FlashLabel" },
    MiniJump2dSpotAhead = { link = "FlashMatch" },
    MiniJump2dSpotUnique = { fg = c.bg, bg = c.cyan, bold = true },
    -- mini.map
    MiniMapNormal = { link = "NormalFloat" },
    MiniMapSymbolLine = { link = "CursorLine" },
    MiniMapSymbolView = { fg = c.blue },
    -- mini.pick
    MiniPickBorder = { link = "FloatBorder" },
    MiniPickBorderBusy = { fg = c.yellow },
    MiniPickBorderText = { link = "FloatTitle" },
    MiniPickNormal = { link = "NormalFloat" },
    MiniPickMatchCurrent = { link = "CursorLine" },
    MiniPickMatchMarked = { fg = c.cyan },
    MiniPickMatchRanges = { link = "TelescopeMatching" },
    MiniPickPrompt = { fg = c.blue },
    -- mini.diff
    MiniDiffSignAdd = { link = "GitSignsAdd" },
    MiniDiffSignChange = { link = "GitSignsChange" },
    MiniDiffSignDelete = { link = "GitSignsDelete" },
    MiniDiffOverAdd = { link = "DiffAdd" },
    MiniDiffOverChange = { link = "DiffChange" },
    MiniDiffOverDelete = { link = "DiffDelete" },
    -- mini.notify
    MiniNotifyBorder = { link = "FloatBorder" },
    MiniNotifyNormal = { link = "NormalFloat" },
    MiniNotifyTitle = { link = "FloatTitle" },
    -- mini.clue
    MiniClueBorder = { link = "FloatBorder" },
    MiniClueNormal = { link = "NormalFloat" },
    MiniClueTitle = { link = "FloatTitle" },
    MiniClueDescGroup = { link = "WhichKeyGroup" },
    MiniClueDescSingle = { link = "WhichKeyDesc" },
    MiniClueNextKey = { link = "WhichKey" },
    MiniClueSeparator = { link = "WhichKeySeparator" },
    -- mini.files
    MiniFilesBorder = { link = "FloatBorder" },
    MiniFilesNormal = { link = "NormalFloat" },
    MiniFilesTitle = { link = "FloatTitle" },
    MiniFilesTitleFocused = { fg = c.bg, bg = c.blue, bold = true },
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
    DapBreakpoint = { fg = c.red },
    DapBreakpointCondition = { fg = c.yellow },
    DapBreakpointRejected = { fg = c.comment },
    DapLogPoint = { fg = c.cyan },
    DapStopped = { fg = c.green },
    DapStoppedLine = { bg = d.diff_add },

    DapUIScope = { link = "Title" },
    DapUIType = { link = "Type" },
    DapUIModifiedValue = { fg = c.yellow, bold = true },
    DapUIDecoration = { fg = c.blue },
    DapUIThread = { link = "Function" },
    DapUIStoppedThread = { fg = c.green, bold = true },
    DapUISource = { fg = c.cyan },
    DapUILineNumber = { link = "LineNr" },
    DapUIFloatBorder = { link = "FloatBorder" },
    DapUIWatchesValue = { fg = c.green },
    DapUIWatchesError = { link = "DiagnosticError" },
    DapUIWatchesEmpty = { fg = c.comment },
    DapUIBreakpointsPath = { link = "Directory" },
    DapUIBreakpointsInfo = { link = "DiagnosticInfo" },
    DapUIBreakpointsCurrentLine = { fg = c.green, bold = true },
    DapUIBreakpointsDisabledLine = { fg = c.comment },
    DapUICurrentFrameName = { link = "DapUIStoppedThread" },
    DapUIEndofBuffer = { link = "EndOfBuffer" },
    DapUIFrameName = { fg = c.fg },
    DapUIBar = { fg = c.border },
    DapUIPlayPause = { fg = c.green },
    DapUIRestart = { link = "DapUIPlayPause" },
    DapUIStop = { fg = c.red },
    DapUIUnavailable = { fg = c.comment },
    DapUIStepOver = { fg = c.blue },
    DapUIStepInto = { link = "DapUIStepOver" },
    DapUIStepBack = { link = "DapUIStepOver" },
    DapUIStepOut = { link = "DapUIStepOver" },
  })

  -- ── 27. neotest ───────────────────────────────────────────────────────────
  hi({
    NeotestPassed = { fg = c.green },
    NeotestFailed = { fg = c.red },
    NeotestRunning = { fg = c.yellow },
    NeotestSkipped = { fg = c.comment },
    NeotestUnknown = { fg = c.fg_dim },
    NeotestFile = { link = "Directory" },
    NeotestDir = { link = "Directory" },
    NeotestNamespace = { link = "@namespace" },
    NeotestAdapter = { link = "Title" },
    NeotestIndent = { link = "IblIndent" },
    NeotestExpandMarker = { link = "IblIndent" },
    NeotestFocused = { link = "CursorLine" },
    NeotestWatching = { fg = c.cyan },
    NeotestWinSelect = { fg = c.blue, bold = true },
    NeotestMarked = { fg = c.orange, bold = true },
    NeotestTest = { fg = c.fg },
  })

  -- ── 28. mason.nvim ────────────────────────────────────────────────────────
  hi({
    MasonNormal = { link = "NormalFloat" },
    MasonHeader = { fg = c.bg, bg = c.blue, bold = true },
    MasonHeaderSecondary = { fg = c.bg, bg = c.green, bold = true },
    MasonHighlight = { fg = c.blue },
    MasonHighlightBlock = { fg = c.bg, bg = c.blue },
    MasonHighlightBlockBold = { fg = c.bg, bg = c.blue, bold = true },
    MasonHighlightSecondary = { fg = c.cyan },
    MasonHighlightBlockSecondary = { fg = c.bg, bg = c.cyan },
    MasonHighlightBlockBoldSecondary = { fg = c.bg, bg = c.cyan, bold = true },
    MasonLink = { fg = c.blue, underline = true },
    MasonMuted = { fg = c.fg_dim },
    MasonMutedBlock = { fg = c.bg, bg = c.fg_dim },
    MasonError = { link = "DiagnosticError" },
    MasonWarning = { link = "DiagnosticWarn" },
    MasonHeading = { link = "Title" },
  })

  -- ── 29. lazy.nvim (plugin manager UI) ────────────────────────────────────
  hi({
    LazyNormal = { link = "NormalFloat" },
    LazyBorder = { link = "FloatBorder" },
    LazyButton = { fg = c.fg, bg = c.sel },
    LazyButtonActive = { fg = c.bg, bg = c.blue, bold = true },
    LazyH1 = { fg = c.bg, bg = c.blue, bold = true },
    LazyH2 = { link = "Title" },
    LazyComment = { link = "Comment" },
    LazyDimmed = { fg = c.fg_dim },
    LazyProp = { fg = c.cyan },
    LazyValue = { fg = c.green },
    LazyUrl = { fg = c.blue, underline = true },
    LazyCommit = { fg = c.orange },
    LazyCommitType = { fg = c.magenta, italic = true },
    LazyLocal = { fg = c.cyan },
    LazySpecial = { fg = c.blue },
    LazyReasonPlugin = { fg = c.blue },
    LazyReasonEvent = { fg = c.magenta },
    LazyReasonKeys = { fg = c.yellow },
    LazyReasonSource = { fg = c.cyan },
    LazyReasonFt = { fg = c.green },
    LazyReasonCmd = { fg = c.orange },
    LazyReasonRequire = { fg = c.blue },
    LazyReasonStart = { fg = c.fg_dim },
    LazyProgressDone = { fg = c.green, bold = true },
    LazyProgressTodo = { fg = c.fg_dim },
    LazyError = { link = "DiagnosticError" },
    LazyWarning = { link = "DiagnosticWarn" },
    LazyInfo = { link = "DiagnosticInfo" },
  })

  -- ── 30. alpha-nvim / dashboard-nvim ──────────────────────────────────────
  hi({
    AlphaHeader = { link = "SnacksDashboardHeader" },
    AlphaFooter = { link = "SnacksDashboardFooter" },
    AlphaButton = { fg = c.yellow },
    AlphaButtonShortcut = { fg = c.cyan },
    -- dashboard-nvim
    DashboardHeader = { link = "SnacksDashboardHeader" },
    DashboardFooter = { link = "SnacksDashboardFooter" },
    DashboardCenter = { fg = c.blue },
    DashboardShortCut = { fg = c.yellow },
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
    NavicIconsFile = { fg = c.fg_dim },
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
    NavicIconsNull = { fg = c.orange },
    NavicIconsEnumMember = { link = "@field" },
    NavicIconsStruct = { link = "Structure" },
    NavicIconsEvent = { fg = c.magenta },
    NavicIconsOperator = { link = "Operator" },
    NavicIconsTypeParameter = { link = "Type" },
    NavicText = { fg = c.fg_dim },
    NavicSeparator = { fg = c.comment },
  })

  -- ── 33. render-markdown.nvim ──────────────────────────────────────────────
  hi({
    RenderMarkdownH1 = { fg = c.blue, bold = true },
    RenderMarkdownH2 = { fg = c.magenta, bold = true },
    RenderMarkdownH3 = { fg = c.cyan, bold = true },
    RenderMarkdownH4 = { fg = c.green, bold = true },
    RenderMarkdownH5 = { fg = c.yellow, bold = true },
    RenderMarkdownH6 = { fg = c.orange, bold = true },
    RenderMarkdownH1Bg = { bg = c.bg_alt },
    RenderMarkdownH2Bg = { link = "RenderMarkdownH1Bg" },
    RenderMarkdownH3Bg = { link = "RenderMarkdownH1Bg" },
    RenderMarkdownCode = { bg = c.bg_alt },
    RenderMarkdownCodeInline = { fg = c.green, bg = c.bg_alt },
    RenderMarkdownBullet = { fg = c.magenta },
    RenderMarkdownQuote = { fg = c.comment, italic = true },
    RenderMarkdownDash = { fg = c.border },
    RenderMarkdownLink = { link = "@text.uri" },
    RenderMarkdownChecked = { fg = c.green },
    RenderMarkdownUnchecked = { fg = c.fg_dim },
    RenderMarkdownTableHead = { fg = c.blue, bold = true },
    RenderMarkdownTableRow = { fg = c.fg },
    RenderMarkdownTableFill = { fg = c.border },
    RenderMarkdownError = { link = "DiagnosticError" },
    RenderMarkdownWarn = { link = "DiagnosticWarn" },
    RenderMarkdownInfo = { link = "DiagnosticInfo" },
    RenderMarkdownHint = { link = "DiagnosticHint" },
    RenderMarkdownSuccess = { fg = c.green },
  })

  -- ── 34. headlines.nvim ────────────────────────────────────────────────────
  hi({
    Headline1 = { bg = d.hi_blue, bold = true },
    Headline2 = { bg = d.hi_magenta, bold = true },
    Headline3 = { bg = d.hi_green, bold = true },
    CodeBlock = { bg = c.bg_alt },
    Dash = { link = "RenderMarkdownDash" },
    Quote = { link = "RenderMarkdownQuote" },
  })

  -- ── 35. Language: Rust ────────────────────────────────────────────────────
  hi({
    rustKeyword = { link = "Keyword" },
    rustModPath = { link = "@namespace" },
    rustModPathSep = { fg = c.fg_dim },
    rustLifetime = { fg = c.magenta, italic = true },
    rustLabel = { fg = c.magenta },
    rustMacro = { fg = c.cyan, bold = true },
    rustSelf = { fg = c.red, italic = true },
    rustSigil = { fg = c.cyan },
    rustOperator = { link = "Operator" },
    rustArrow = { link = "Operator" },
    rustFatArrow = { link = "Operator" },
    rustQuestionMark = { fg = c.red },
    rustStorage = { link = "StorageClass" },
    rustStructure = { link = "Structure" },
    rustEnum = { link = "Type" },
    rustTrait = { link = "Type" },
    rustDerive = { fg = c.yellow },
    rustDeriveTrait = { fg = c.yellow, italic = true },
    rustAttribute = { link = "@attribute" },
    rustCommentLine = { link = "Comment" },
    rustCommentLineDoc = { fg = c.comment, italic = true },
    rustString = { link = "String" },
    rustStringDelimiter = { link = "String" },
    rustNumber = { link = "Number" },
    rustBoolean = { link = "Boolean" },
    rustFloat = { link = "Float" },
    rustEscape = { link = "@string.escape" },
    -- rust-analyzer semantic tokens
    ["@lsp.type.lifetime"] = { fg = c.magenta, italic = true },
    ["@lsp.type.selfKeyword"] = { fg = c.red, italic = true },
    ["@lsp.type.formatSpecifier"] = { fg = c.cyan },
    ["@lsp.mod.mutable"] = { underline = true },
    ["@lsp.mod.consuming"] = { italic = true },
    ["@lsp.typemod.variable.mutable"] = { underline = true },
  })

  -- ── 36. Language: Lua ─────────────────────────────────────────────────────
  hi({
    luaStatement = { link = "Keyword" },
    luaFunction = { link = "Keyword" },
    luaTable = { fg = c.fg },
    luaBraces = { fg = c.fg_dim },
    luaIn = { link = "Keyword" },
    luaLocal = { link = "Keyword" },
    luaNil = { fg = c.orange },
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
    -- lazydev / neodev annotations
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
    pythonDecorator = { fg = c.yellow },
    pythonDecoratorName = { fg = c.yellow, italic = true },
    pythonDot = { fg = c.fg_dim },
    pythonBuiltin = { fg = c.cyan },
    pythonBuiltinType = { link = "Type" },
    pythonBuiltinFunc = { fg = c.cyan },
    pythonBuiltinObj = { fg = c.orange },
    pythonString = { link = "String" },
    pythonRawString = { link = "String" },
    pythonFString = { link = "String" },
    pythonFStringBraces = { fg = c.cyan },
    pythonBytes = { link = "String" },
    pythonNumber = { link = "Number" },
    pythonFloat = { link = "Float" },
    pythonBoolean = { link = "Boolean" },
    pythonNone = { fg = c.orange },
    pythonComment = { link = "Comment" },
    pythonSelf = { fg = c.red, italic = true },
    pythonCls = { fg = c.red, italic = true },
    pythonClass = { link = "Type" },
    pythonFunction = { link = "Function" },
    -- pyright / pylsp semantic tokens
    ["@lsp.type.class.python"] = { link = "Type" },
    ["@lsp.type.function.python"] = { link = "Function" },
    ["@lsp.type.parameter.python"] = { link = "@parameter" },
    ["@lsp.type.variable.python"] = { link = "@variable" },
    ["@lsp.type.decorator.python"] = { fg = c.yellow },
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
    cppAccess = { fg = c.magenta },
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
    -- clangd semantic tokens
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
    jsReturn = { fg = c.red },
    jsException = { link = "Exception" },
    jsOperator = { link = "Operator" },
    jsStorageClass = { link = "StorageClass" },
    jsThis = { fg = c.red, italic = true },
    jsSuper = { fg = c.red, italic = true },
    jsUndefined = { fg = c.orange },
    jsNull = { fg = c.orange },
    jsNan = { fg = c.orange },
    jsGlobalObjects = { fg = c.cyan },
    jsFunction = { link = "Keyword" },
    jsArrowFunction = { link = "Operator" },
    jsString = { link = "String" },
    jsTemplateString = { link = "String" },
    jsTemplateBraces = { fg = c.cyan },
    jsNumber = { link = "Number" },
    jsFloat = { link = "Float" },
    jsBoolean = { link = "Boolean" },
    jsRegexpString = { fg = c.cyan },
    jsObjectKey = { link = "@field" },
    jsObjectColon = { fg = c.fg_dim },
    jsSpread = { link = "Operator" },
    jsClassDefinition = { link = "Type" },
    jsClassKeyword = { link = "Keyword" },
    jsExtendsKeyword = { link = "Keyword" },
    jsImport = { link = "Include" },
    jsExport = { link = "Include" },
    jsModuleAs = { link = "Keyword" },
    jsFrom = { link = "Keyword" },
    jsDecorator = { fg = c.yellow },
    jsDecoratorFunction = { fg = c.yellow, italic = true },
    typescriptStatement = { link = "Keyword" },
    typescriptReserved = { link = "Keyword" },
    typescriptStorageClass = { link = "StorageClass" },
    typescriptEndColons = { fg = c.fg_dim },
    typescriptBraces = { fg = c.fg_dim },
    typescriptParens = { fg = c.fg_dim },
    typescriptDotNotation = { fg = c.fg_dim },
    typescriptTypeAnnotation = { fg = c.fg_dim },
    typescriptAccessibilityModifier = { fg = c.magenta },
    typescriptReadonlyModifier = { link = "StorageClass" },
    typescriptDeclareModifier = { link = "StorageClass" },
    typescriptOptionalMark = { fg = c.red },
    typescriptNull = { fg = c.orange },
    typescriptUndefined = { fg = c.orange },
    typescriptThis = { fg = c.red, italic = true },
    typescriptArrowFunc = { link = "Operator" },
    typescriptFuncKeyword = { link = "Keyword" },
    typescriptAsyncFuncKeyword = { link = "Keyword" },
    typescriptDecorator = { fg = c.yellow },
    typescriptImport = { link = "Include" },
    typescriptExport = { link = "Include" },
    typescriptTypeImport = { link = "Include" },
    typescriptInterpolation = { fg = c.cyan },
    typescriptInterpolationDelimiter = { fg = c.cyan },
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
    -- tsserver / vtsls semantic tokens
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
    jsonBraces = { fg = c.fg_dim },
    jsonKeyword = { link = "@field" },
    jsonQuote = { fg = c.fg_dim },
    jsonString = { link = "String" },
    jsonNumber = { link = "Number" },
    jsonBoolean = { link = "Boolean" },
    jsonNull = { fg = c.orange },
    jsonCommentError = { link = "Error" },
    ["@label.json"] = { link = "@field" },
  })

  -- ── 41. Language: HTML / CSS ──────────────────────────────────────────────
  hi({
    htmlTag = { fg = c.fg_dim },
    htmlEndTag = { fg = c.fg_dim },
    htmlTagName = { fg = c.red },
    htmlArg = { fg = c.yellow },
    htmlTitle = { link = "Title" },
    htmlH1 = { link = "Title" },
    htmlH2 = { fg = c.magenta, bold = true },
    htmlH3 = { fg = c.cyan, bold = true },
    htmlLink = { fg = c.blue, underline = true },
    htmlBold = { bold = true },
    htmlItalic = { italic = true },
    htmlString = { link = "String" },
    htmlSpecialChar = { link = "Special" },
    htmlComment = { link = "Comment" },
    htmlCommentPart = { link = "Comment" },
    cssTagName = { link = "htmlTagName" },
    cssClassName = { fg = c.yellow },
    cssClassNameDot = { fg = c.yellow },
    cssPseudoClassId = { fg = c.cyan },
    cssPseudoClassFn = { fg = c.cyan },
    cssId = { fg = c.orange },
    cssAttrComma = { fg = c.fg_dim },
    cssAtKeyword = { link = "Keyword" },
    cssBraces = { fg = c.fg_dim },
    cssDefinition = { link = "@property" },
    cssProp = { link = "@property" },
    cssVendor = { fg = c.fg_dim },
    cssImportant = { fg = c.red, bold = true },
    cssValueLength = { link = "Number" },
    cssValueNumber = { link = "Number" },
    cssValueAngle = { link = "Number" },
    cssValueTime = { link = "Number" },
    cssValueFrequency = { link = "Number" },
    cssColor = { fg = c.orange },
    cssFunction = { link = "Function" },
    cssString = { link = "String" },
    cssComment = { link = "Comment" },
    cssUnitDecorators = { fg = c.cyan },
    cssCustomProp = { fg = c.cyan },
  })

  -- ── 42. Language: Go ──────────────────────────────────────────────────────
  hi({
    goStatement = { link = "Keyword" },
    goConditional = { link = "Conditional" },
    goRepeat = { link = "Repeat" },
    goLabel = { link = "Label" },
    goException = { link = "Exception" },
    goDeclType = { link = "Keyword" },
    goBuiltins = { fg = c.cyan },
    goConstants = { fg = c.orange },
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
    -- gopls semantic tokens
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
    shVariable = { fg = c.cyan },
    shDeref = { link = "shVariable" },
    shDerefSimple = { link = "shVariable" },
    shDerefVar = { link = "shVariable" },
    shDerefSpecial = { fg = c.cyan, italic = true },
    shSpecial = { link = "Special" },
    shSpecialVar = { link = "Special" },
    shSingleQuote = { link = "String" },
    shDoubleQuote = { link = "String" },
    shHereDoc = { link = "String" },
    shHereString = { link = "String" },
    shNumber = { link = "Number" },
    shRange = { link = "Operator" },
    shParen = { fg = c.fg_dim },
    shPipe = { link = "Operator" },
    shSubSh = { fg = c.cyan },
    shCommandSub = { fg = c.cyan },
    shCmdSubRegion = { fg = c.cyan },
    shComment = { link = "Comment" },
    shBang = { fg = c.comment, bold = true },
    bashStatement = { link = "shStatement" },
    bashSpecialVariables = { link = "shSpecialVar" },
  })

  -- ── 44. Language: YAML ────────────────────────────────────────────────────
  hi({
    yamlKey = { link = "@field" },
    yamlAnchor = { fg = c.cyan },
    yamlAlias = { fg = c.cyan, italic = true },
    yamlBlockMappingKey = { link = "@field" },
    yamlFlowMappingKey = { link = "@field" },
    yamlString = { link = "String" },
    yamlPlainScalar = { link = "String" },
    yamlInteger = { link = "Number" },
    yamlFloat = { link = "Float" },
    yamlBool = { link = "Boolean" },
    yamlNull = { fg = c.orange },
    yamlTag = { fg = c.magenta },
    yamlComment = { link = "Comment" },
    yamlDocumentStart = { fg = c.comment },
    yamlDocumentEnd = { fg = c.comment },
    yamlBlockCollectionItemStart = { fg = c.magenta },
  })

  -- ── 45. Language: TOML ────────────────────────────────────────────────────
  hi({
    tomlKey = { link = "@field" },
    tomlTable = { fg = c.blue, bold = true },
    tomlTableArray = { fg = c.blue, bold = true },
    tomlString = { link = "String" },
    tomlMultilineString = { link = "String" },
    tomlInteger = { link = "Number" },
    tomlFloat = { link = "Float" },
    tomlBoolean = { link = "Boolean" },
    tomlDate = { fg = c.orange },
    tomlTime = { fg = c.orange },
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
    markdownH1 = { fg = c.blue, bold = true },
    markdownH2 = { fg = c.magenta, bold = true },
    markdownH3 = { fg = c.cyan, bold = true },
    markdownH4 = { fg = c.green, bold = true },
    markdownH5 = { fg = c.yellow, bold = true },
    markdownH6 = { fg = c.orange, bold = true },
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
    markdownCode = { fg = c.green },
    markdownCodeBlock = { fg = c.green },
    markdownCodeDelimiter = { fg = c.comment },
    markdownBlockquote = { fg = c.comment, italic = true },
    markdownListMarker = { fg = c.magenta },
    markdownOrderedListMarker = { link = "markdownListMarker" },
    markdownRule = { fg = c.border },
    markdownLinkText = { fg = c.blue },
    markdownLinkDelimiter = { fg = c.fg_dim },
    markdownUrl = { fg = c.cyan, underline = true },
    markdownUrlTitle = { link = "String" },
    markdownIdDeclaration = { link = "markdownLinkText" },
  })

  -- ── 48. Language: Vim / VimL ──────────────────────────────────────────────
  hi({
    vimCommand = { link = "Keyword" },
    vimCommentTitle = { fg = c.comment, bold = true },
    vimMapMod = { fg = c.cyan },
    vimMapModKey = { fg = c.cyan },
    vimNotation = { link = "Special" },
    vimOption = { fg = c.yellow },
    vimSetEqual = { link = "Operator" },
    vimSetSep = { fg = c.fg_dim },
    vimSep = { fg = c.fg_dim },
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
    NvimSurroundHighlight = { fg = c.bg, bg = c.yellow, bold = true },
    NvimSurroundHighlightTextObject = { link = "Visual" },
  })

  -- ── 50. vim-matchup ───────────────────────────────────────────────────────
  hi({
    MatchupVirtualText = { fg = c.comment, italic = true },
    MatchWord = { link = "MatchParen" },
    MatchWordCur = { link = "MatchParen" },
    MatchParenCur = { link = "MatchParen" },
  })

  -- ── 51. nvim-ufo (folding) ────────────────────────────────────────────────
  hi({
    UfoFoldedFg = { fg = c.fg },
    UfoFoldedBg = { bg = c.bg_alt },
    UfoCursorFoldedLine = { link = "CursorLine" },
    UfoPreviewSbar = { link = "PmenuSbar" },
    UfoPreviewThumb = { link = "PmenuThumb" },
    UfoPreviewWinBar = { link = "WinBar" },
    UfoFoldedEllipsis = { fg = c.comment },
  })

  -- ── 52. nvim-scrollbar ────────────────────────────────────────────────────
  hi({
    ScrollbarHandle = { bg = c.sel },
    ScrollbarCursor = { fg = c.fg, bg = c.sel },
    ScrollbarCursorHandle = { link = "ScrollbarCursor" },
    ScrollbarSearch = { fg = c.yellow, bg = c.bg_alt },
    ScrollbarSearchHandle = { fg = c.yellow, bg = c.sel },
    ScrollbarError = { link = "DiagnosticError" },
    ScrollbarErrorHandle = { link = "DiagnosticError" },
    ScrollbarWarn = { link = "DiagnosticWarn" },
    ScrollbarWarnHandle = { link = "DiagnosticWarn" },
    ScrollbarInfo = { link = "DiagnosticInfo" },
    ScrollbarInfoHandle = { link = "DiagnosticInfo" },
    ScrollbarHint = { link = "DiagnosticHint" },
    ScrollbarHintHandle = { link = "DiagnosticHint" },
    ScrollbarMisc = { fg = c.magenta, bg = c.bg_alt },
    ScrollbarMiscHandle = { fg = c.magenta, bg = c.sel },
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
    HlSearchLens = { fg = c.comment, bg = c.bg_alt, italic = true },
    HlSearchLensNear = { fg = c.yellow, bg = c.bg_alt, bold = true },
    HlSearchFloat = { link = "Search" },
  })

  -- ── 54. copilot.lua / copilot-cmp ────────────────────────────────────────
  hi({
    CopilotSuggestion = { fg = c.comment, italic = true },
    CopilotAnnotation = { fg = c.comment, italic = true },
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
    MarkSignHL = { fg = c.yellow },
    MarkSignNumHL = { fg = c.yellow },
    MarkVirtTextHL = { fg = c.comment, italic = true },
  })

  -- ── 58. todo-comments.nvim ────────────────────────────────────────────────
  hi({
    TodoBgTODO = { fg = c.bg, bg = c.blue, bold = true },
    TodoFgTODO = { fg = c.blue },
    TodoSignTODO = { fg = c.blue },
    TodoBgNOTE = { fg = c.bg, bg = c.cyan, bold = true },
    TodoFgNOTE = { fg = c.cyan },
    TodoSignNOTE = { fg = c.cyan },
    TodoBgFIX = { fg = c.bg, bg = c.red, bold = true },
    TodoFgFIX = { fg = c.red },
    TodoSignFIX = { fg = c.red },
    TodoBgWARN = { fg = c.bg, bg = c.yellow, bold = true },
    TodoFgWARN = { fg = c.yellow },
    TodoSignWARN = { fg = c.yellow },
    TodoBgHACK = { fg = c.bg, bg = c.orange, bold = true },
    TodoFgHACK = { fg = c.orange },
    TodoSignHACK = { fg = c.orange },
    TodoBgPERF = { fg = c.bg, bg = c.magenta, bold = true },
    TodoFgPERF = { fg = c.magenta },
    TodoSignPERF = { fg = c.magenta },
    TodoBgTEST = { fg = c.bg, bg = c.green, bold = true },
    TodoFgTEST = { fg = c.green },
    TodoSignTEST = { fg = c.green },
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
    DiffviewFilePanelRootPath = { fg = c.blue, bold = true },
    DiffviewFilePanelTitle = { link = "Title" },
    DiffviewFilePanelCounter = { fg = c.magenta, bold = true },
    DiffviewFilePanelFileName = { fg = c.fg },
    DiffviewFilePanelInsertions = { fg = c.green },
    DiffviewFilePanelDeletions = { fg = c.red },
    DiffviewFilePanelConflicts = { fg = c.yellow, bold = true },
    DiffviewFolderSign = { link = "Directory" },
    DiffviewFolderName = { link = "Directory" },
    DiffviewReference = { fg = c.cyan },
    DiffviewStatusAdded = { link = "GitSignsAdd" },
    DiffviewStatusUntracked = { link = "GitSignsAdd" },
    DiffviewStatusCopied = { link = "GitSignsAdd" },
    DiffviewStatusModified = { link = "GitSignsChange" },
    DiffviewStatusRenamed = { link = "GitSignsChange" },
    DiffviewStatusDeleted = { link = "GitSignsDelete" },
    DiffviewStatusBroken = { link = "DiagnosticError" },
    DiffviewStatusIgnored = { fg = c.comment },
    DiffviewConflictAncestor = { fg = c.fg, bg = d.diff_change },
    DiffviewConflictingChange = { fg = c.fg, bg = d.diff_text },
  })

  -- ── 60. neogit ────────────────────────────────────────────────────────────
  hi({
    NeogitNormal = { link = "NormalFloat" },
    NeogitCursorLine = { link = "CursorLine" },
    NeogitBranch = { fg = c.magenta },
    NeogitRemote = { fg = c.cyan },
    NeogitBranchHead = { fg = c.magenta, bold = true },
    NeogitHunkHeader = { fg = c.blue, bg = d.hl_blue },
    NeogitHunkHeaderHighlight = { fg = c.blue, bg = d.hl_blue, bold = true },
    NeogitDiffAdd = { link = "DiffAdd" },
    NeogitDiffDelete = { link = "DiffDelete" },
    NeogitDiffContext = { fg = c.fg_dim },
    NeogitDiffContextHighlight = { fg = c.fg, bg = c.sel },
    NeogitDiffAddHighlight = { fg = c.green, bg = d.diff_add },
    NeogitDiffDeleteHighlight = { fg = c.red, bg = d.diff_delete },
    NeogitStagedChanges = { fg = c.green, bold = true },
    NeogitUnstagedChanges = { fg = c.yellow, bold = true },
    NeogitUntrackedFiles = { fg = c.orange, bold = true },
    NeogitStashes = { fg = c.cyan, bold = true },
    NeogitSectionHeader = { link = "Title" },
    NeogitGraphRed = { fg = c.red },
    NeogitGraphWhite = { fg = c.fg },
    NeogitGraphYellow = { fg = c.yellow },
    NeogitGraphOrange = { fg = c.orange },
    NeogitGraphGreen = { fg = c.green },
    NeogitGraphBlue = { fg = c.blue },
    NeogitGraphPurple = { fg = c.magenta },
    NeogitGraphGray = { fg = c.comment },
    NeogitGraphCyan = { fg = c.cyan },
    NeogitPopupActionKey = { fg = c.yellow },
    NeogitPopupSwitchKey = { fg = c.cyan },
    NeogitPopupOptionKey = { fg = c.cyan },
    NeogitPopupConfigKey = { fg = c.magenta },
    NeogitObjectId = { fg = c.orange, italic = true },
    NeogitFilePath = { link = "Directory" },
  })

  -- ── 61. octo.nvim ────────────────────────────────────────────────────────
  hi({
    OctoViewer = { fg = c.bg, bg = c.blue },
    OctoGreenFloat = { fg = c.green, bg = c.bg_alt },
    OctoRedFloat = { fg = c.red, bg = c.bg_alt },
    OctoPurpleFloat = { fg = c.magenta, bg = c.bg_alt },
    OctoBlueFloat = { fg = c.blue, bg = c.bg_alt },
    OctoYellowFloat = { fg = c.yellow, bg = c.bg_alt },
    OctoGrey = { fg = c.comment },
    OctoRed = { fg = c.red },
    OctoGreen = { fg = c.green },
    OctoBlue = { fg = c.blue },
    OctoPurple = { fg = c.magenta },
    OctoYellow = { fg = c.yellow },
    OctoDetailsLabel = { fg = c.cyan, bold = true },
    OctoDetailsValue = { fg = c.fg },
    OctoMissingDetails = { fg = c.comment, italic = true },
    OctoEditable = { bg = c.sel },
    OctoIssueTitle = { link = "Title" },
    OctoPRChangedFile = { link = "GitSignsChange" },
    OctoPRAddedFile = { link = "GitSignsAdd" },
    OctoPRDeletedFile = { link = "GitSignsDelete" },
    OctoStateOpen = { fg = c.green },
    OctoStateClosed = { fg = c.red },
    OctoStateMerged = { fg = c.magenta },
    OctoStateDraft = { fg = c.comment },
    OctoStatePending = { fg = c.yellow },
    OctoStateApproved = { fg = c.green, bold = true },
    OctoStateChangesRequested = { fg = c.red, bold = true },
    OctoStateCommented = { fg = c.blue },
    OctoStateDismissed = { fg = c.comment },
  })

  -- ── 62. overseer.nvim ────────────────────────────────────────────────────
  hi({
    OverseerPENDING = { fg = c.fg_dim },
    OverseerRUNNING = { fg = c.yellow },
    OverseerSUCCESS = { fg = c.green },
    OverseerCANCELED = { fg = c.comment },
    OverseerFAILURE = { fg = c.red },
    OverseerTask = { fg = c.fg, bold = true },
    OverseerTaskBorder = { link = "FloatBorder" },
    OverseerOutput = { fg = c.fg },
    OverseerComponent = { fg = c.cyan },
    OverseerField = { link = "@field" },
  })

  -- ── 63. harpoon ───────────────────────────────────────────────────────────
  hi({
    HarpoonBorder = { link = "FloatBorder" },
    HarpoonWindow = { link = "NormalFloat" },
    HarpoonCurrentFile = { fg = c.blue, bold = true },
    HarpoonNumberActive = { fg = c.yellow, bold = true },
    HarpoonNumber = { fg = c.comment },
  })

  -- ── 64. nvim-spectre ──────────────────────────────────────────────────────
  hi({
    SpectreSearch = { link = "Search" },
    SpectreReplace = { fg = c.bg, bg = c.green },
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
    TwilightInactive = { fg = c.comment },
  })

  -- ── 66. oil.nvim ──────────────────────────────────────────────────────────
  hi({
    OilDir = { link = "Directory" },
    OilFile = { fg = c.fg },
    OilLink = { fg = c.cyan, italic = true },
    OilSocket = { fg = c.magenta },
    OilPipe = { fg = c.orange },
    OilCopy = { fg = c.yellow },
    OilMove = { fg = c.green },
    OilCreate = { fg = c.green, bold = true },
    OilDelete = { fg = c.red },
    OilRestore = { fg = c.cyan },
    OilPurge = { fg = c.red, bold = true },
    OilTrash = { fg = c.red, italic = true },
    OilTrashSourcePath = { fg = c.comment, italic = true },
    OilPermissionRead = { fg = c.yellow },
    OilPermissionWrite = { fg = c.red },
    OilPermissionExecute = { fg = c.green },
    OilTypeDir = { link = "Directory" },
    OilTypeFile = { fg = c.fg_dim },
    OilTypeLink = { fg = c.cyan },
    OilTypeSocket = { fg = c.magenta },
    OilTypePipe = { fg = c.orange },
    OilChange = { link = "GitSignsChange" },
    OilAdd = { link = "GitSignsAdd" },
    OilDelete2 = { link = "GitSignsDelete" },
  })

  -- ── 67. symbol-usage.nvim ────────────────────────────────────────────────
  hi({
    SymbolUsageRef = { fg = c.comment, italic = true },
    SymbolUsageDef = { fg = c.comment, italic = true },
    SymbolUsageImpl = { fg = c.comment, italic = true },
    SymbolUsageRefBg = { fg = c.comment, bg = d.hl_blue, italic = true },
    SymbolUsageDefBg = { fg = c.comment, bg = d.hl_magenta, italic = true },
    SymbolUsageImplBg = { fg = c.comment, bg = d.hl_green, italic = true },
  })

  -- ── 68. inc-rename.nvim ───────────────────────────────────────────────────
  hi({
    IncRename = { fg = c.yellow, bold = true },
    IncRenameRange = { link = "Visual" },
  })

  -- ── 69. treesitter-context ────────────────────────────────────────────────
  hi({
    TreesitterContext = { bg = c.bg_alt },
    TreesitterContextLineNumber = { fg = c.comment, bg = c.bg_alt },
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
    StartupTimeSourcing = { fg = c.blue },
    StartupTimePlugin = { fg = c.cyan },
    StartupTimeTimes = { fg = c.yellow },
    StartupTimeMsTotal = { fg = c.orange, bold = true },
  })
end

return M
