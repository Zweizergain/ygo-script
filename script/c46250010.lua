--英龙骑-赤枪龙
function c46250010.initial_effect(c)
	c:SetSPSummonOnce(46250010)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c46250010.lfilter,1,1)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c46250010.sumcon)
	e1:SetTarget(c46250010.sumtg)
	e1:SetOperation(c46250010.sumop)
	c:RegisterEffect(e1)
end
function c46250010.lfilter(c)
	return c:IsSetCard(0x1fc0)
end
function c46250010.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c46250010.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetMaterial():GetFirst()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc:IsLocation(LOCATION_GRAVE) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,tc,1,0,0)
end
function c46250010.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	local c=e:GetHandler()
	local tc=c:GetMaterial():GetFirst()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsLocation(LOCATION_GRAVE) then
		if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c46250010.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c46250010.eqlimit(e,c)
	return e:GetOwner()==c
end
