local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local rep = require("luasnip.extras").rep

local DEFAULT_LICENSE = "MIT"

-- Pull a 3-part block comment (start/middle/end) out of the filetype's
-- 'comments' option, e.g. "s1:/*,mb:*,ex:*/,://" for C.
local function block_comment()
  local open, mid, close
  for _, part in ipairs(vim.split(vim.bo.comments, ",")) do
    local flags, str = part:match("^([^:]*):(.*)$")
    if flags and str and str ~= "" then
      if flags:match("^s") then
        open = str
      elseif flags:match("^m") then
        mid = str
      elseif flags:match("^e") then
        close = str
      end
    end
  end
  if open and close then
    return open, mid or "", close
  end
end

-- Cache git user info for the session so we don't shell out on every expand.
local git_name, git_email
local function get_git_identity()
  if git_name == nil then
    git_name = vim.fn.system("git config --get user.name"):gsub("%s+$", "")
    git_email = vim.fn.system("git config --get user.email"):gsub("%s+$", "")
    if vim.v.shell_error ~= 0 then
      git_name, git_email = "", ""
    end
  end
  return git_name, git_email
end

-- Builds the header body (without comment fences).
local function build(prefix, suffix, open_line, close_line, name_default, email_default)
  suffix = suffix or ""
  local today = os.date("%Y-%m-%d")

  local function line(text)
    return t({ "", prefix .. text })
  end

  local nodes = {}
  if open_line then
    table.insert(nodes, t(open_line))
  end

  table.insert(nodes, line("# Created"))

  table.insert(nodes, line("Author: "))
  table.insert(nodes, i(1, name_default or ""))
  table.insert(nodes, t(" <"))
  table.insert(nodes, i(2, email_default or ""))
  table.insert(nodes, t(">"))
  if suffix ~= "" then
    table.insert(nodes, t(suffix))
  end

  table.insert(nodes, line("Date: "))
  table.insert(nodes, t(today))
  if suffix ~= "" then
    table.insert(nodes, t(suffix))
  end

  table.insert(nodes, line("License: "))
  table.insert(nodes, i(3, DEFAULT_LICENSE))
  if suffix ~= "" then
    table.insert(nodes, t(suffix))
  end

  table.insert(nodes, t({ "", vim.trim(prefix) }))

  table.insert(nodes, line("# Contributors:"))
  if suffix ~= "" then
    table.insert(nodes, t(suffix))
  end
  table.insert(nodes, line("- "))
  table.insert(nodes, rep(1)) -- mirrors Author name
  table.insert(nodes, t(" <"))
  table.insert(nodes, rep(2)) -- mirrors Author email
  table.insert(nodes, t(">"))
  if suffix ~= "" then
    table.insert(nodes, t(suffix))
  end

  if close_line then
    table.insert(nodes, t({ "", close_line }))
  end
  return nodes
end

local function header_nodes(name_default, email_default)
  local open, mid, close = block_comment()
  if open then
    local prefix = mid ~= "" and (mid .. " ") or ""
    return sn(nil, build(prefix, "", open, close, name_default, email_default))
  end

  local cs = vim.bo.commentstring
  if not cs or cs == "" then
    cs = "# %s"
  end
  local pre, post = cs:match("^(.-)%%s(.*)$")
  pre = vim.trim(pre or "#")
  return sn(nil, build(pre .. " ", post or "", nil, nil, name_default, email_default))
end

return {
  -- Blank author/contributors
  s("msg::", {
    d(1, function()
      return header_nodes("", "")
    end, {}),
  }),

  -- Pre-filled from git config
  s("me::", {
    d(1, function()
      local name, email = get_git_identity()
      return header_nodes(name, email)
    end, {}),
  }),
}
