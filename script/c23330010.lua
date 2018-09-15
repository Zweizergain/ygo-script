--残霞折射
function c23330010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c23330010.condition)
	e1:SetTarget(c23330010.target)
	e1:SetOperation(c23330010.operation)
	c:RegisterEffect(e1)
	if not c23330010.global_check then
		c23330010.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c23330010.checkop)
		Duel.RegisterEffect(ge1,0)
	end 
end
function c23330010.cfilter(c,tp)
	return c:IsSetCard(0x555) and c:IsReason(REASON_EFFECT) 
		and c:GetPreviousLocation()==LOCATION_MZONE and bit.band(c:GetPreviousPosition(),POS_FACEUP)~=0
end
function c23330010.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c23330010.cfilter,1,nil,tp)
end
function c23330010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFlagEffect(tp)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c23330010.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffect(tp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local fid=c:GetFieldID()
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
	   local g=Duel.GetMatchingGroup(c23330010.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	   local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	   if g:GetCount()>0 and ft>0 and Duel.SelectYesNo(tp,aux.Stringid(23330010,0)) then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		  local ct=math.min(ft,d)
		  local sg=g:Select(tp,1,ct)
		  for tc in aux.Next(sg) do
			  if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			  local e1=Effect.CreateEffect(c)
			  e1:SetType(EFFECT_TYPE_SINGLE)
			  e1:SetCode(EFFECT_DISABLE)
			  e1:SetReset(RESET_EVENT+0x1fe0000)
			  tc:RegisterEffect(e1)
			  local e2=Effect.CreateEffect(c)
			  e2:SetType(EFFECT_TYPE_SINGLE)
			  e2:SetCode(EFFECT_DISABLE_EFFECT)
			  e2:SetReset(RESET_EVENT+0x1fe0000)
			  tc:RegisterEffect(e2)
			  tc:RegisterFlagEffect(23330010,RESET_EVENT+0x1fe0000,0,1,fid)
			  end
		  end
		  Duel.SpecialSummonComplete()
		  sg:KeepAlive()
		  local e3=Effect.CreateEffect(c)
		  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		  e3:SetCode(EVENT_PHASE+PHASE_END)
		  e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		  e3:SetCountLimit(1)
		  e3:SetLabel(fid)
		  e3:SetLabelObject(sg)
		  e3:SetCondition(c23330010.descon)
		  e3:SetOperation(c23330010.desop)
		  Duel.RegisterEffect(e3,tp)
	   end
	end
end
function c23330010.spfliter(c,e,tp)
	return c:IsSetCard(0x555) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c23330010.desfilter(c,fid)
	return c:GetFlagEffectLabel(23330010)==fid
end
function c23330010.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c23330010.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c23330010.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c23330010.desfilter,nil,e:GetLabel())
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end
function c23330010.checkop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c23330010.cfilter,nil)
	for tc in aux.Next(eg) do
		if tc:IsSetCard(0x555) and tc:IsPreviousLocation(LOCATION_ONFIELD) and tc:GetReasonPlayer() and tc:GetReasonPlayer()~=tc:GetControler() then
		   Duel.RegisterFlagEffect(tc:GetControler(),23330010,RESET_PHASE+PHASE_END,0,1)
		end
	end
end

