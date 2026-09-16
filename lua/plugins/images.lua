local FILETYPES = { "markdown", "vimwiki", "quarto" }

return {
  {
    "3rd/image.nvim",
    build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
    opts = {
      backend = "kitty",
      processor = "magick_cli",
      integrations = {
        markdown = {
          only_render_image_at_cursor = true,
          filetypes = FILETYPES,
        },
      },
    },
    config = function(_, opts)
      local image = require("image")
      image.setup(opts)
      image.disable()

      local always_on = false
      local transient_on = false
      local transient_buf = nil
      local transient_row = nil
      local transient_col_start = nil
      local transient_col_end = nil

      local function enable()
        pcall(image.enable)
      end

      local function disable()
        pcall(image.disable)
      end

      local function is_enabled()
        local ok, enabled = pcall(image.is_enabled)
        return ok and enabled or false
      end

      local function is_image_filetype(buf)
        return vim.tbl_contains(FILETYPES, vim.bo[buf].filetype)
      end

      local function clear_transient()
        if always_on or not transient_on then
          return
        end
        transient_on = false
        transient_buf = nil
        transient_row = nil
        transient_col_start = nil
        transient_col_end = nil
        disable()
      end

      local function cursor_still_on_same_image(buf)
        if not transient_on or buf ~= transient_buf then
          return false
        end

        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        return row == transient_row and col >= transient_col_start and col < transient_col_end
      end

      local augroup = vim.api.nvim_create_augroup("ImageNvimMarkdownMappings", { clear = true })

      vim.api.nvim_create_autocmd("FileType", {
        group = augroup,
        pattern = FILETYPES,
        callback = function(event)
          vim.keymap.set("n", "<leader>mi", function()
            always_on = not always_on
            transient_on = false
            transient_buf = nil
            transient_row = nil
            transient_col_start = nil
            transient_col_end = nil

            if always_on then
              enable()
              vim.notify("image.nvim enabled")
            else
              disable()
              vim.notify("image.nvim disabled")
            end
          end, {
            buffer = event.buf,
            desc = "Toggle inline images",
          })
        end,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "BufLeave" }, {
        group = augroup,
        callback = function(args)
          if always_on or not transient_on then
            return
          end

          if not is_image_filetype(args.buf) then
            clear_transient()
            return
          end

          if args.event == "BufLeave" or not cursor_still_on_same_image(args.buf) then
            clear_transient()
          end
        end,
      })
    end,
  },
}
