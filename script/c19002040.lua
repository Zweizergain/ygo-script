--土之月灵术 生
function c19002040.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c19002040.cost)
	e1:SetTarget(c19002040.target)
	e1:SetOperation(c19002040.activate)
	c:RegisterEffect(e1) 
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c19002040.handcon)
	c:RegisterEffect(e2)	  
end
function c19002040.hfilter(c)
	return c:IsFaceup() and c:IsCode(19002012,19002016)
end
function c19002040.handcon(e)
	return Duel.IsExistingMatchingCard(c19002040.hfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c19002040.cfilter(c,ft,tp)
	return c:IsAttribute(ATTRIBUTE_EARTH)
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function c19002040.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c19002040.cfilter,1,nil,ft,tp) end
	local g=Duel.SelectReleaseGroup(tp,c19002040.cfilter,1,1,nil,ft,tp)
	Duel.Release(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c19002040.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c19002040.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c19002040.filter(chkc,e,tp) end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.IsExistingTarget(c19002040.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		else
			return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.IsExistingTarget(c70156997.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		end
	end
	local ex=nil
	if e:GetLabel()==1 then
		ex=e:GetLabelObject()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c19002040.filter,tp,LOCATION_GRAVE,0,1,1,ex,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	e:SetLabel(0)
end
function c19002040.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
