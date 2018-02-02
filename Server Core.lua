-- Adds the Manipulation to the player's character on join: only on first join
game.Players.PlayerAdded:connect(function(player)
	script.Intro_Camera_Manip:Clone().Parent = player.CharacterAdded:wait()
end)
