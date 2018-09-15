--猛毒性 PENDRORBASE
function c24562458.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c24562458.e1tg)
	e1:SetOperation(c24562458.e1op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c24562458.e2val)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c24562458.e3flag)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(24562458,0))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,2456245801)
	e4:SetCondition(c24562458.e4con)
	e4:SetTarget(c24562458.e4tg)
	e4:SetOperation(c24562458.e4op)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(24562458,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,2456245802)
	e5:SetTarget(c24562458.e5tg)
	e5:SetOperation(c24562458.e5op)
	c:RegisterEffect(e5)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_EQUIP_LIMIT)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetValue(c24562458.e9limit)
	c:RegisterEffect(e9)
end
function c24562458.e5op(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 then return end
	if tc:IsCanBeFusionMaterial() and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c24562458.e5spfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetCode())
		local sc=sg:GetFirst()
		if sc then
			sc:SetMaterial(Group.FromCards(tc))
			Duel.SendtoGrave(tc,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
end
function c24562458.bbfil(c,e,tp,bb)
	return c:GetEquipGroup():IsContains(bb)
end
function c24562458.e5tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
	local bb=e:GetHandler()
	local bb1=Duel.GetMatchingGroupCount(c24562458.bbfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e,tp,bb)
	if bb1==0 then return false end
	  local tc=e:GetHandler():GetEquipTarget()
	  local tcd=tc:GetCode()
	  return tc:IsCanBeFusionMaterial() and Duel.GetLocationCountFromEx(tp,tp,tc)>0 and Duel.IsExistingMatchingCard(c24562458.e5spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,tcd) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c24562458.e5spfil(c,e,tp,tcd)
	return aux.IsMaterialListCode(c,tcd) 
	 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function c24562458.e4op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c24562458.e4filter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c24562458.e4filter(c)
	return c:IsSetCard(0x1390) and c:GetType()==TYPE_SPELL+TYPE_QUICKPLAY and c:IsAbleToHand()
end
function c24562458.e4tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24562458.e4filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c24562458.e4con(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	local bb=e:GetHandler()
	local bb1=Duel.GetMatchingGroupCount(c24562458.bbfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e,tp,bb)
	if bb1==0 then return false end
	return e:GetHandler():GetEquipTarget():GetFlagEffect(24562458)>0 and Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c24562458.e3flag(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	local bb=e:GetHandler()
	local bb1=Duel.GetMatchingGroupCount(c24562458.bbfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e,tp,bb)
	if bb1==0 then return false end
	e:GetHandler():GetEquipTarget():RegisterFlagEffect(24562458,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c24562458.e9limit(e,c)
	return c:IsSetCard(0x1390)
end
function c24562458.e2val(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)*700
end
function c24562458.e1fl(c)
	return c:IsFaceup() and c:IsSetCard(0x1390)
end
function c24562458.e1tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c24562458.e1fl(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c24562458.e1fl,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c24562458.e1fl,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c24562458.e1op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end