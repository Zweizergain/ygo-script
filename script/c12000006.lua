---遺言の札
function c12000006.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetCondition(c12000006.condition)
	e1:SetTarget(c12000006.target)
	e1:SetOperation(c12000006.operation)
	c:RegisterEffect(e1)
	if not c12000006.global_check then
		c12000006.global_check=true
		--
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(c12000006.check1)
		Duel.RegisterEffect(ge1,tp)
	end
end
function c12000006.check1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		if g:GetCount()>0 then
		local sc=g:GetFirst()
		while sc do
			local atk=sc:GetAttack()
			if sc:GetFlagEffectLabel(12000006)==nil then
				sc:RegisterFlagEffect(12000006,RESET_EVENT+0x1fe0000,0,1,atk)
				sc:RegisterFlagEffect(12000006+100000000,RESET_EVENT+0x1fe0000,0,1,0)
			else
				local flb1=sc:GetFlagEffectLabel(12000006)
				local flb2=sc:GetFlagEffectLabel(12000006+100000000)
				if flb1~=atk and flb2==0 and atk==0 then
					sc:SetFlagEffectLabel(12000006,atk)
					sc:SetFlagEffectLabel(12000006+100000000,1)
				end
			end
			--
			sc=g:GetNext()
		end
	end
end 
function c12000006.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local ct=0
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local sc=g:GetFirst()
	while sc do
		local atk=sc:GetAttack()
		local flb2=sc:GetFlagEffectLabel(12000006+100000000)
		if flb2>0 then ct=ct+1 end
		sc:SetFlagEffectLabel(12000006,atk)
		sc:SetFlagEffectLabel(12000006+100000000,0)
		--
		sc=g:GetNext()
	end
	return ct>0
end
function c12000006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if chk==0 then return hg:GetCount()<5
	and Duel.IsPlayerCanDraw(tp,5-hg:GetCount())
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(5-hg:GetCount())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,5-hg:GetCount())
end
function c12000006.operation(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if hg:GetCount()<5 then
		Duel.Draw(tp,5-hg:GetCount(),REASON_EFFECT)
	end
end
