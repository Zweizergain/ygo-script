--狂梦『梦幻世界』
function c1153301.initial_effect(c)
--
	c:SetUniqueOnField(1,1,1153301)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c1153301.con2)
	e2:SetOperation(c1153301.op2)
	c:RegisterEffect(e2)
--
	if not c1153301.gchk then
		c1153301.gchk=true
		c1153301.previous_chain_info={}
		local e0=Effect.GlobalEffect()
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_CHAINING)
		e0:SetOperation(c1153301.ofilter0)
		Duel.RegisterEffect(e0,0)
	end
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetCountLimit(1)
	e4:SetOperation(c1153301.op4)
	c:RegisterEffect(e4)
--
end
--
function c1153301.ofilter0(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	local ceg=eg:Clone()
	ceg:KeepAlive()
	c1153301.previous_chain_info[cid]={ceg,ep,ev,re,r,rp}   
end
--
function c1153301.con2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsPlayerCanDiscardDeck(ep,1) and not re:GetActivateLocation()==LOCATION_MZONE 
end
--
function c1153301.tfilter(c,ev,re,rp)
	if not c:IsType(TYPE_SPELL+TYPE_TRAP) then return false end
	local te=c:GetActivateEffect()
	if not te then return false end
	local code=te:GetCode()
	if code~=EVENT_FREE_CHAIN then return false end
	local tg=te:GetTarget()
	if not tg then return true end
	if code~=EVENT_CHAINING then
		local ex,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(code,true)
		return tg(re,rp,ceg,cep,cev,cre,cr,crp,0)
	else
		local cid=Duel.GetChainInfo(ev-1,CHAININFO_CHAIN_ID)
		local ceg,cep,cev,cre,cr,crp=table.unpack(c1153301.previous_chain_info[cid])
		return tg(re,rp,ceg,cep,cev,cre,cr,crp,0)
	end
end
--
function c1153301.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,e:GetOwner():GetOriginalCode())
	Duel.DiscardDeck(1-ep,1,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local tc=g:GetFirst()
	if c1153301.tfilter(tc,ev,re,rp) then
		local te=tc:GetActivateEffect()
		Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
		Duel.ChangeTargetCard(ev,Group.CreateGroup())
		Duel.ChangeChainOperation(ev,c1153301.cop(te))
		if re:GetHandler():IsAbleToGrave() then
			Duel.SendtoGrave(re:GetHandler(),REASON_EFFECT)
		end
	else
		Duel.Damage(ep,600,REASON_EFFECT)
	end
end
--
function c1153301.cop(te)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
		if not te then return end
		local c=e:GetHandler()
		local tg=te:GetTarget()
		local code=te:GetCode()
		local ceg,cep,cev,cre,cr,crp
		if code==EVENT_CHAINING and Duel.GetCurrentChain()>1 then
			local chainc=Duel.GetCurrentChain()-1
			local cid=Duel.GetChainInfo(chainc,CHAININFO_CHAIN_ID)
			ceg,cep,cev,cre,cr,crp=table.unpack(c1153301.previous_chain_info[cid])
		elseif code~=EVENT_FREE_CHAIN and Duel.CheckEvent(code) then
			_,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(code,true)
		else
			ceg,cep,cev,cre,cr,crp=eg,ep,ev,re,r,rp
		end
		local pr=e:GetProperty()
		e:SetProperty(te:GetProperty())
		if not c1153301.call_function(tg,e,tp,ceg,cep,cev,cre,cr,crp,0) then
			e:SetProperty(pr)
			Duel.NegateEffect(0)
			return
		end
		c1153301.call_function(tg,e,tp,ceg,cep,cev,cre,cr,crp,1)
		c1153301.call_function(te:GetOperation(),e,tp,ceg,cep,cev,cre,cr,crp)
		e:SetProperty(pr)
	end
end
function c1153301.call_function(f,e,tp,eg,ep,ev,re,r,rp,chk)
	if not f then return true end
	local res=false
	if not pcall(function() res=f(e,tp,eg,ep,ev,re,r,rp,chk) end) then return false end
	return res
end
--
function c1153301.op4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return end
	if Duel.GetLP(tp)>=1200 then
		Duel.PayLPCost(tp,1200)
	else
		Duel.SetLP(tp,0)
	end
end