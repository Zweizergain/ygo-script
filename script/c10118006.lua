--季雨 逗趣白紫
function c10118006.initial_effect(c)
	--fusion
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),2,false)  
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetLabel(SUMMON_TYPE_FUSION)
	e1:SetCondition(c10118006.con)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c10118006.efilter)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	e3:SetLabel(SUMMON_TYPE_SYNCHRO)  
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c10118006.efilter2)
	e4:SetLabel(SUMMON_TYPE_SYNCHRO)  
	c:RegisterEffect(e4)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10118006,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e3:SetCountLimit(1,10118006)
	e3:SetCost(c10118006.spcost)
	e3:SetTarget(c10118006.sptg)
	e3:SetOperation(c10118006.spop)
	c:RegisterEffect(e3)
end
function c10118006.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	e:SetLabel(100)
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c10118006.spfilter(c,e,tp)
	return c:IsSetCard(0x5331) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10118006.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local unable=nil
	if e:GetLabel()==100 then unable=e:GetHandler() end
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10118006.spfilter(chkc,e,tp) end
	if chk==0 then 
	   e:SetLabel(0)
	   return Duel.IsExistingTarget(c10118006.spfilter,tp,LOCATION_GRAVE,0,1,unable,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10118006.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,LOCATION_GRAVE)
end
function c10118006.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	   Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10118006.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(e:GetLabel())
end
function c10118006.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c10118006.efilter2(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
