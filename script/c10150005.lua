--超·电·磁·武·神·斩！
function c10150005.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10150005.target)
	e1:SetOperation(c10150005.activate)
	c:RegisterEffect(e1)   
end

function c10150005.filter(c)
	return c:IsFaceup() and c:IsCode(75347539) and c:GetFlagEffect(10150005)==0
end

function c10150005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c10150005.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10150005.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c10150005.filter,tp,LOCATION_MZONE,0,1,1,nil)
end

function c10150005.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:GetFlagEffect(10150005)==0 then
			tc:RegisterFlagEffect(10150005,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
			--immue
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetDescription(aux.Stringid(10150005,0))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_SINGLE_RANGE)
			e1:SetOwnerPlayer(tp)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(c10150005.efilter)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			--atk
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e2:SetValue(c10150005.atkval)
			tc:RegisterEffect(e2)
			--pierce
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_PIERCE)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
			--extra attack
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_EXTRA_ATTACK)
			e4:SetValue(1)
			e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e4)
		end
	end
end

function c10150005.atkfilter(c)
	return c:IsCode(99785935) or c:IsCode(39256679) or c:IsCode(11549357)
end

function c10150005.atkval(e,c)
	return Duel.GetMatchingGroupCount(c10150005.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*500
end

function c10150005.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end