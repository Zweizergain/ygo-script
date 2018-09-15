--终末歌谣-Lamentable Vermilion
function c65000022.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--summon 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,65000022)
	e2:SetCondition(c65000022.spcon)
	e2:SetTarget(c65000022.sptg)
	e2:SetOperation(c65000022.spop)
	c:RegisterEffect(e2)
	--break 
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,65000023)
	e3:SetCondition(c65000022.brcon)
	e3:SetTarget(c65000022.brtg)
	e3:SetOperation(c65000022.brop)
	c:RegisterEffect(e3)
	--remove 
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c65000022.recon)
	e4:SetTarget(c65000022.retg)
	e4:SetOperation(c65000022.reop)
	c:RegisterEffect(e4)
end

function c65000022.spfil(c)
	return c:IsSetCard(0x41) 
end

function c65000022.spcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.IsExistingMatchingCard(c65000022.spfil,tp,LOCATION_MZONE,0,1,nil)
end

function c65000022.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ft,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ft,0,0)
end

function c65000022.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,65000023,0,0x4011,0,0,1,RACE_FIEND,ATTRIBUTE_DARK) then return end
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if ft<=0 or (Duel.IsPlayerAffectedByEffect(tp,59822133) and ft>1) then return end
	for i=1,ft do
		local token=Duel.CreateToken(tp,65000023)
		Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
	end
end

function c65000022.brcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end

function c65000022.brfil(c)
	return c:IsFaceup() and c:IsType(TYPE_TOKEN)
end
function c65000022.brtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65000022.brfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c65000022.brfil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end

function c65000022.brop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c65000022.brfil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end

function c65000022.reconfil(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousSetCard(0x41) and c:IsType(TYPE_MONSTER) and c:IsReason(REASON_COST+REASON_BATTLE+REASON_EFFECT)
end

function c65000022.recon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65000022.reconfil,1,nil,tp)
end

function c65000022.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(1-tp,30459350+93445075) and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_MZONE)
end

function c65000022.reop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(1-tp,30459350+93445075) then return end
	local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_MZONE,0,nil,TYPE_MONSTER)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		local tc=sg:GetFirst()
		if Duel.Remove(tc,POS_FACEUP,REASON_RULE+REASON_TEMPORARY)~=0 then
			tc:RegisterFlagEffect(65000022,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabelObject(tc)
			e1:SetCountLimit(1)
			e1:SetCondition(c65000022.retcon)
			e1:SetOperation(c65000022.retop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end

function c65000022.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(65000022)~=0
end
function c65000022.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
