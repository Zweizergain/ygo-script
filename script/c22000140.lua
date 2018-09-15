--从者Avenger 安哥拉纽曼
function c22000140.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,1,2,c22000140.ovfilter,aux.Stringid(22000140,0),3,c22000140.xyzop)
	c:EnableReviveLimit()
	--battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22000140,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c22000140.atkcon)
	e3:SetOperation(c22000140.atkop)
	c:RegisterEffect(e3)
end
function c22000140.cfilter(c)
	return c:IsSetCard(0xffd) and c:IsDiscardable()
end
function c22000140.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfff)
end
function c22000140.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22000140.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c22000140.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c22000140.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsFaceup()
end
function c22000140.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_RANK)
		e2:SetValue(2)
		e2:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e2)
	end
end
