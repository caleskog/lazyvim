local M = {}

--- Wraps text into multiple lines with a given width and optional prefix.
--- Each line (except the first) starts with the prefix.
--- Lines are broken at word boundaries when possible.
---
--- @param text string The text to wrap
--- @param width number The maximum width of each line
--- @param prefix string? (optional) The prefix to prepend to each line
--- @param cond_prefix string? (optional) The prefix to prepend to each line after the first line
--- @return table A list of wrapped lines
function M.wrap_text(text, width, prefix, cond_prefix)
  prefix = prefix or ""
  cond_prefix = cond_prefix or prefix
  if not text or text == "" then
    return { prefix }
  end

  local lines = {}
  local remaining = text
  local current_line = prefix

  while #remaining > 0 do
    local space_left = width - #current_line

    -- Find the last space wwithin the available width
    local split_at = space_left
    if #remaining > space_left then
      -- Look for the last space before the width limit
      local last_space = remaining:sub(1, space_left):match(".*() %S*$") or space_left
      split_at = math.min(last_space, space_left)

      -- If no space found, split at width
      if split_at == 0 then
        split_at = space_left
      end
    else
      split_at = #remaining
    end

    -- Add the segment to current line
    current_line = current_line .. remaining:sub(1, split_at)
    table.insert(lines, current_line)

    -- Move to next segment
    remaining = remaining:sub(split_at + 1)
    current_line = cond_prefix
  end

  return lines
end

return M
