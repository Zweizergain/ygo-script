	--灰篮变色龙
function c65080030.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c65080030.splimcon)
	e1:SetTarget(c65080030.splimit)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c65080030.destg)
	e2:SetOperation(c65080030.desop)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetCondition(c65080030.eqcon)
	e3:SetTarget(c65080030.eqtg)
	e3:SetOperation(c65080030.eqop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_DECK)
	e4:SetCondition(c65080030.eqcon2)
	e4:SetCountLimit(1,65080030)
	e4:SetTarget(c65080030.eqtg)
	e4:SetOperation(c65080030.eqop)
	c:RegisterEffect(e4)
end 
function c65080030.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c65080030.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0xd1) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

function c65080030.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd1)
end

function c65080030.filter1(c)
	return c:IsSetCard(0xd1) and c:IsType(TYPE_MONSTER)
end

function c65080030.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local b0=Duel.IsExistingTarget(c65080030.desfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
	if chk==0 then return b0
	   end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c65080030.desfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)  
end
function c65080030.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		if Duel.Destroy(g,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			local t1=Duel.IsExistingMatchingCard(c65080030.filter1,tp,LOCATION_GRAVE,0,1,nil)
			local t2=Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) 
			if t1 and t2 then
				op=Duel.SelectOption(tp,aux.Stringid(65080030,0),aux.Stringid(65080030,1),aux.Stringid(65080030,2))
			elseif t1 then
				op=Duel.SelectOption(tp,aux.Stringid(65080030,0),aux.Stringid(65080030,2))
			elseif t2 then
				op=Duel.SelectOption(tp,aux.Stringid(65080030,1),aux.Stringid(65080030,2))
			else op=Duel.SelectOption(tp,aux.Stringid(65080030,2)) end
			e:SetLabel(op)
			if e:GetLabel()==0 then
				local g1=Duel.SelectMatchingCard(tp,c65080030.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
				if g1:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
				Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
				end
			elseif e:GetLabel()==1 then
				 local g2=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
				 if g2:GetCount()>0 then
					Duel.HintSelection(g2)
					Duel.ChangePosition(g2,POS_FACEUP_DEFENSE)
				 end
			else return end
		end
	end
end


function c65080030.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and re:IsActiveType(TYPE_SPELL+TYPE_MONSTER)) )
		and c:IsReason(REASON_DESTROY) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE) and c:IsLocation(LOCATION_EXTRA)
end
function c65080030.eqcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and ((re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and rp~=tp) or (re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:GetHandler():IsSetCard(0xd1)))
		and c:IsReason(REASON_DESTROY) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_PZONE) and c:IsLocation(LOCATION_EXTRA) 
end

function c65080030.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c65080030.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c65080030.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
		Duel.Equip(tp,c,tc,true)
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c65080030.eqlimit)
		e1:SetLabelObject(tc)
		c:RegisterEffect(e1)
		--control
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_SET_CONTROL)
		e2:SetValue(tp)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
		--Destroy
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EVENT_LEAVE_FIELD_P)
		e3:SetOperation(c65080030.checkop)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e4:SetCode(EVENT_LEAVE_FIELD)
		e4:SetOperation(c65080030.desop2)
		e4:SetReset(RESET_EVENT+0x17e0000)
		e4:SetLabelObject(e3)
		c:RegisterEffect(e4)
	end
end
function c65080030.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c65080030.desop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetLabel()~=0 then return end
	local tc=e:GetHandler():GetEquipTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
