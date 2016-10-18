# Loads things specific for a given computer
for i in (ls ~/.config/fish/inc_*.fish)
	. $i
end
