local tmux = {
	cfg = {
		window_test = '2',
		window_aider = '9',
	}
}

-- TODO a good test runner would be to run the tests and then move the pane to split of current nvim window
-- with a keybinding to move back to the previous place
tmux.execute = function (arg, pre)
    local command = string.format("%s tmux %s", pre or "", arg)

    local handle = assert(io.popen(command), string.format("unable to execute: [%s]", command))
    local result = handle:read("*a")
    handle:close()

    return result
end

tmux.run_test = function ()
  tmux.execute(string.format("send-keys -l -t :%s 'try_test'", tmux.cfg.window_test))
  tmux.execute(string.format("send-keys -t :%s C-m", tmux.cfg.window_test))
  tmux.execute(string.format("select-window -t %s", tmux.cfg.window_test))
end

tmux.set_test_window = function (window)
	tmux.cfg.window_test = window
end

tmux.updatelib = function ()
  tmux.execute(string.format("send-keys -l -t :%s 'up_earnlib'", tmux.cfg.window_test))
  tmux.execute(string.format("send-keys -t :%s C-m", tmux.cfg.window_test))
end

tmux.run_aider_add_file = function ()
  tmux.execute(string.format("send-keys -l -t :%s '/add %s'", tmux.cfg.window_aider, vim.fn.expand("%:p")))
  tmux.execute(string.format("send-keys -t :%s C-m", tmux.cfg.window_aider))
  -- tmux.execute(string.format("select-window -t %s", tmux.cfg.window_aider))
end

tmux.run_aider = function ()
  tmux.execute(string.format("new-window -t :%s fish", tmux.cfg.window_aider))
  tmux.execute(string.format("send-keys -l -t :%s 'run_aider'", tmux.cfg.window_aider))
  tmux.execute(string.format("send-keys -t :%s C-m", tmux.cfg.window_aider))
  tmux.execute(string.format("send-keys -l -t :%s 'aider --subtree-only'", tmux.cfg.window_aider))
  tmux.execute(string.format("send-keys -t :%s C-m", tmux.cfg.window_aider))
end

vim.api.nvim_create_user_command("TmuxTest", tmux.run_test, { nargs = 0 })
vim.api.nvim_create_user_command("TmuxUpdatelib", tmux.updatelib, { nargs = 0 })

vim.api.nvim_create_user_command("TmuxAiderAddFile", tmux.run_aider_add_file, { nargs = 0 })
vim.api.nvim_create_user_command("TmuxRunAider", tmux.run_aider, { nargs = 0 })

return tmux
