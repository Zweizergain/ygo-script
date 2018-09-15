--银河急战·引力诱捕器
function c10100020.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100020,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c10100020.eqtg)
	e1:SetOperation(c10100020.eqop)
	c:RegisterEffect(e1)
	--unequip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100020,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c10100020.con)
	e2:SetTarget(c10100020.sptg)
	e2:SetOperation(c10100020.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	c:RegisterEffect(e3)
	--changelv
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10100020,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c10100020.clcon)
	e4:SetTarget(c10100020.cltg)
	e4:SetOperation(c10100020.clop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,0x1e0)
	c:RegisterEffect(e5)	 
	--spsummon2 
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(10100020,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCountLimit(1,10100020)
	e6:SetCost(c10100020.spcost2)
	e6:SetTarget(c10100020.sptg2)
	e6:SetOperation(c10100020.spop2)
	c:RegisterEffect(e6)   
end
function c10100020.con(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	if not tc then return false end
	if bit.band(e:GetType(),0x100)==0x100 then return tc:IsHasEffect(10100015)
	else return not tc:IsHasEffect(10100015)
	end
end
function c10100020.tg(e,tc)
	local ct=e:GetType()
	local quick=tc:IsHasEffect(10100015)
	local g1,g2,c=tc:GetLinkedGroup(),tc:GetEquipGroup(),e:GetHandler()
	local equip=(g2 and g2:IsContains(c))
	local linkg=(tc:IsHasEffect(10100029) and g1 and g1:IsContains(c))
	if not equip and not linkg then return false end
	if bit.band(ct,0x40)==0x40 then return not quick 
	elseif bit.band(ct,0x100)==0x100 then return quick
	else return true
	end
end
function c10100020.cfilter(tc,e)
	return c10100020.tg(e,tc)
end
function c10100020.clcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10100020.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e)
end
function c10100020.cltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetEquipTarget()
	if chk==0 then return e:GetHandler():GetFlagEffect(10100020)<=1 and tc and tc:GetLevel()>0 end
	local t={}
	local i=1
	local p=1
	local lv=tc:GetLevel()
	for i=1,5 do
		if lv~=i then t[p]=i p=p+1 end
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,567)
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
end
function c10100020.clop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetHandler():GetEquipTarget()
	if tc and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c10100020.spfilter(c,e,tp)
	return c:IsSetCard(0x339) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100020.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10100020.spfilter,tp,0x13,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function c10100020.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10100020.spfilter),tp,0x13,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10100020.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c10100020.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(10100020)<=1 and  Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c10100020.eqfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	e:GetHandler():RegisterFlagEffect(10100020,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c10100020.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x339)
end
function c10100020.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or (c:IsOnField() and c:IsFacedown()) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c10100020.eqfilter,tp,LOCATION_MZONE,0,1,1,c)
	if g:GetCount()<=0 then return end
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	if not Duel.Equip(tp,c,tc,true) then return end
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetReset(RESET_EVENT+0x1fe0000)
	e4:SetValue(c10100020.eqlimit)
	e4:SetLabelObject(tc)
	c:RegisterEffect(e4)
end
function c10100020.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c10100020.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(10100020)<=1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	e:GetHandler():RegisterFlagEffect(10100020,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c10100020.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end
end
