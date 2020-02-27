vis:command_register("fzf-rg", function(argv, force, win, selection, range)
  -- Prepare a shell command to:
  -- > Find occurrences of the arguments with ripgrep
  -- > Select one of the results with fzf
  -- > Parse the result with awk
  local rg = "rg -n --column --color=always " .. table.concat(argv, " ")
  local fzf = "fzf --ansi"
  local awk = "awk -F: '{print $1, $2, $3}'"
  local command = rg .. " | " .. fzf .. " | " .. awk

  -- Execute the shell command
  local result = io.popen(command)
  local output = result:read()
  result:close()

  -- Open the chosen file at the correct cursor position
  if type(output) == "string" then
    local file, line, column = string.match(output, "([^%s]+) (%d+) (%d+)")
    vis:feedkeys(":e " .. file .. "<Enter>")
    vis.win.selection:to(line, column)
  end

  -- Finish the function
  vis:feedkeys("<vis-redraw>")
  return true
end, "Go to a given occurrence within the current pwd")