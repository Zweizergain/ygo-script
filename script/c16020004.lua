--法皇结界
function c16020004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16020004,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c16020004.damtg1)
	e2:SetOperation(c16020004.damop1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--ka~~kyo~~in~~
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(16020004,1))
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c16020004.descon)
	c:RegisterEffect(e4)
end
function c16020004.damtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(eg:GetFirst():GetSummonPlayer())
	Duel.SetTargetParam(200)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,eg:GetFirst():GetSummonPlayer(),200)
end
function c16020004.damop1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		if not Duel.IsPlayerAffectedByEffect(p,16020003) then
			Duel.Damage(p,d,REASON_EFFECT)
		end
	end
end
function c16020004.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x80e)
end
function c16020004.descon(e)
	return not Duel.IsExistingMatchingCard(c16020004.desfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end