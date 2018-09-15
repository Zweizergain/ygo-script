--泰拉魔物 金鱼
if not pcall(function() require("expansions/script/c43330023") end) then require("script/c43330023") end
local m=43330024
local cm=_G["c"..m]
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)  
end
cm.setcard="terraria"