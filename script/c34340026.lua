--白魔术-龙裔姬
function c34340026.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c34340026.lfilter,2)
	c:EnableReviveLimit() 
	--des
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(34340026,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCountLimit(1)
	e2:SetTarget(c34340026.destg)
	e2:SetOperation(c34340026.desop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c34340026.val)
	c:RegisterEffect(e3)	 
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(34340026,0))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c34340026.drcon)
	e4:SetTarget(c34340026.drtg)
	e4:SetOperation(c34340026.drop)
	c:RegisterEffect(e4) 
end
c34340023.setname="WhiteMagician"
function c34340026.cfilter(c,tp)
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()~=tp
end
function c34340026.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c34340026.cfilter,1,nil,tp)
end
function c34340026.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c34340026.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c34340026.val(e,c)
	return Duel.GetMatchingGroupCount(c34340026.lfilter2,c:GetControler(),LOCATION_GRAVE,0,nil)*100
end
function c34340026.lfilter(c)
	return c.setname=="WhiteMagician"
end
function c34340026.lfilter2(c)
	return c.setname=="WhiteMagician" and c:IsType(TYPE_MONSTER)
end
function c34340026.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return lg:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,lg,lg:GetCount(),0,0)
end
function c34340026.desop(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	Duel.Destroy(lg,REASON_EFFECT)
end