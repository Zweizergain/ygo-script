--名刀 数珠丸恒次
function c62899997.initial_effect(c)
	  --synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(c62899997.xyzfilter),aux.NonTuner(c62899997.xyzfilter),1)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(62899997,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c62899997.eqtg)
	e1:SetOperation(c62899997.eqop)
	c:RegisterEffect(e1) 
   --pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	--ind
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetTarget(c62899997.target)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--equip effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(1200)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_SZONE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetTarget(c62899997.target2)
	e6:SetValue(1)
	c:RegisterEffect(e6)
end
function c62899997.xyzfilter(c)
	return c:IsSetCard(0x620) and not c:IsSetCard(0x1620) and not c:IsSetCard(0x2620)
end
function c62899997.eqfilter(c,tc)
	return c:GetEquipCount()==0 and c:IsFaceup() and c~=tc
end
function c62899997.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c62899997.eqfilter(chkc,e:GetHandler()) end
	if chk==0 then return Duel.IsExistingTarget(c62899997.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e:GetHandler()) 
	and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c62899997.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e:GetHandler())
end
function c62899997.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsLocation(LOCATION_SZONE) or c:IsFacedown() then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetValue(c62899997.eqlimit)
	e1:SetLabelObject(tc)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
end
function c62899997.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c62899997.target(e,c)
	return c==e:GetHandler() or  e:GetHandler():GetEquipGroup():IsContains(c)
end
function c62899997.target2(e,c)
	return c==e:GetHandler() or e:GetHandler():GetEquipTarget()==c
end