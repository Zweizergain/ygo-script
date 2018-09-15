--口袋精灵 顽皮雷弹
local m=72802039
local set=0xfe2
local cm=_G["c"..m]
function cm.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
if chk==0 then return true end
	local p=PLAYER_ALL
	if not e:GetHandler():IsReason(REASON_EFFECT+REASON_BATTLE) then
		p=1-tp
	end
	Duel.SetTargetPlayer(p)
	Duel.SetTargetParam(3000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,p,3000)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if p==PLAYER_ALL then
		Duel.Damage(0,d,REASON_EFFECT,true)
		Duel.Damage(1,d,REASON_EFFECT,true)
		Duel.RDComplete()
	else
		Duel.Damage(p,d,REASON_EFFECT)
	end
end