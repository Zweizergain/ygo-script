--太刀 黑化三日月宗近
function c62899991.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,c62899991.matfilter,8,2,c62899991.ovfilter,aux.Stringid(62899991,4),5,c62899991.xyzop)
	c:EnableReviveLimit()
   --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(62899991,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c62899991.spcost)
	e1:SetTarget(c62899991.sptg)
	e1:SetOperation(c62899991.spop)
	c:RegisterEffect(e1)
   local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(62899991,0))
	e2:SetTarget(c62899991.grtg)
	e2:SetOperation(c62899991.grop)
	c:RegisterEffect(e2)
   --equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(62899991,3))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(c62899991.eqtg)
	e3:SetOperation(c62899991.eqop)
	c:RegisterEffect(e3) 
	 --equip effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(1000)
	c:RegisterEffect(e4)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(62899991,2))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c62899991.discon)
	e5:SetCost(c62899991.discost)
	e5:SetTarget(c62899991.distg)
	e5:SetOperation(c62899991.disop)
	c:RegisterEffect(e5)
end
function c62899991.matfilter(c)
	return c:IsSetCard(0x620) and not c:IsSetCard(0x2620) 
end
function c62899991.cfilter(c)
	return  c:IsDiscardable()
end
function c62899991.ovfilter(c)
	return c:IsFaceup() and c:IsCode(62899992)
end
function c62899991.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c62899991.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c62899991.cfilter,1,1,REASON_COST,nil)
end
function c62899991.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c62899991.filter(c,e,tp)
	return   c:IsSetCard(0x1620) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp)
end
function c62899991.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c62899991.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c62899991.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c62899991.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_CANNOT_DISABLE)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0xfe0000)
		g:GetFirst():RegisterEffect(e1,true) 
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		g:GetFirst():RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		g:GetFirst():RegisterEffect(e3,true)   
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c62899991.grfilter(c,e,tp)
	return   c:IsSetCard(0x620) and not  c:IsSetCard(0x2620)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,tp)
end
function c62899991.grtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c62899991.grfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c62899991.grop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c62899991.grfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_CANNOT_DISABLE)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0xfe0000)
		g:GetFirst():RegisterEffect(e1,true)  
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
function c62899991.eqfilter(c)
	return c:GetEquipCount()==0 and c:IsFaceup() 
end
function c62899991.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c62899991.eqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c62899991.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
  and Duel.GetLocationCount(tp,LOCATION_SZONE)>0	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c62899991.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c62899991.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsLocation(LOCATION_SZONE) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetValue(c62899991.eqlimit)
	e1:SetLabelObject(tc)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
end
function c62899991.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c62899991.tgfilter(c,tc)
	return c==tc:GetEquipTarget()
end
function c62899991.discon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c62899991.tgfilter,1,nil,e:GetHandler()) and Duel.IsChainDisablable(ev)
end
function c62899991.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c62899991.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c62899991.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end