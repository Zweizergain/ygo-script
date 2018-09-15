--天选圣女 圣御荷姆薇洁
function c10120004.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10120004)
	e1:SetCondition(c10120004.spcon)
	e1:SetOperation(c10120004.spop)
	c:RegisterEffect(e1)  
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10120004,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c10120004.drtg)
	e2:SetOperation(c10120004.drop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)   
	--cannotactive
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10120004,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetTarget(c10120004.datg)
	e4:SetOperation(c10120004.daop)
	c:RegisterEffect(e4)
		--dissummon
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON)
		ge1:SetOperation(c10120004.snop)
		ge1:SetLabelObject(e4)
		Duel.RegisterEffect(ge1,0) 
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SUMMON_SUCCESS) 
		ge2:SetOperation(c10120004.ssop)
		ge2:SetLabelObject(e4)
		Duel.RegisterEffect(ge2,0) 
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_SPSUMMON)
		ge3:SetLabelObject(e4)
		Duel.RegisterEffect(ge3,0) 
		local ge4=ge2:Clone()
		ge4:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge4:SetLabelObject(e4)
		Duel.RegisterEffect(ge4,0)  
end

function c10120004.datg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		if e:GetHandler():GetFlagEffect(10120004)==0 then return false end  
		   e:GetHandler():ResetFlagEffect(10120004)
		return true 
	end
end

function c10120004.daop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetValue(c10120004.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function c10120004.aclimit(e,re,tp)
	return not re:GetHandler():IsRace(RACE_FAIRY) and not re:GetHandler():IsImmuneToEffect(e) and re:IsActiveType(TYPE_MONSTER)
end

function c10120004.snop(e,tp,eg,ep,ev,re,r,rp)
   if eg:IsContains(e:GetOwner()) then
	e:GetOwner():RegisterFlagEffect(10120004,RESET_EVENT+RESET_OVERLAY+0x01020000,0,0)
   end
end

function c10120004.ssop(e,tp,eg,ep,ev,re,r,rp)
   if eg:IsContains(e:GetOwner()) then
	e:GetOwner():ResetFlagEffect(10120004)
   end
end

function c10120004.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function c10120004.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.Draw(tp,1,REASON_EFFECT)
	if ct==0 then return end
	local dc=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-tp,dc)
	if dc:IsSetCard(0x9331) and Duel.SelectYesNo(tp,aux.Stringid(10120004,2))  and Duel.SendtoGrave(dc,REASON_EFFECT)~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	Duel.ShuffleHand(tp)
end

function c10120004.spcfilter(c)
	return c:IsRace(RACE_FAIRY) and not c:IsPublic()
end

function c10120004.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10120004.spcfilter,tp,LOCATION_HAND,0,2,e:GetHandler())
end

function c10120004.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c10120004.spcfilter,tp,LOCATION_HAND,0,2,2,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end