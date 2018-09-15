--极乱数 继承
function c21520035.initial_effect(c)
--[[	--tribute limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRIBUTE_LIMIT)
	e1:SetValue(c21520035.tlimit)
	c:RegisterEffect(e1)--]]
	--cannot disable summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--CANNOT_DISABLE_SUMMON
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	c:RegisterEffect(e1)
	--summon with 3 tribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e2:SetCondition(c21520035.ttcon)
	e2:SetOperation(c21520035.ttop)
	e2:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_LIMIT_SET_PROC)
	e3:SetCondition(c21520035.setcon)
	c:RegisterEffect(e3)
	--atk def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c21520035.valoperation)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--negate summon
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DISABLE_SUMMON)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetType(EFFECT_TYPE_QUICK_F)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_SUMMON)
	e6:SetCondition(c21520035.con)
	e6:SetOperation(c21520035.op)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e7)
end
function c21520035.tlimit(e,c)
	return not c:IsSetCard(0x493)
end
function c21520035.ttcon(e,c)
	if c==nil then return true end
	local mg=Duel.GetFieldGroup(c:GetControler(),LOCATION_MZONE,LOCATION_MZONE)
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-3 and Duel.CheckTribute(c,3,3,mg)
end
function c21520035.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetFieldGroup(c:GetControler(),LOCATION_MZONE,LOCATION_MZONE)
	local g=Duel.SelectTribute(tp,c,3,3,mg,true)
	local tc=g:GetFirst()
	local sum=0
	while tc do
		--not randomly
		if not tc:IsSetCard(0x493) then
			if tc:IsType(TYPE_XYZ) then 
				sum=sum+tc:GetOriginalRank()
			else
				sum=sum+tc:GetOriginalLevel()
			end
		end
		tc=g:GetNext()
	end
	if sum>0 and not Duel.IsExistingMatchingCard(c21520035.chkfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
		Duel.BreakEffect()
		Duel.Damage(tp,sum*500,REASON_RULE)
	end
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c21520035.chkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x493) and c:IsType(TYPE_FIELD)
end
function c21520035.setcon(e,c,minc)
	if not c then return true end
	return false
end
function c21520035.valoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	local tc=g:GetFirst()
	local atk=0
	local def=0
	while tc do
		atk=atk+tc:GetAttack()
		def=def+tc:GetDefense()
		tc=g:GetNext()
	end
	if c:GetSummonType()==SUMMON_TYPE_SPECIAL then
		atk=math.ceil(atk/2)
		def=math.ceil(def/2)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(def)
	c:RegisterEffect(e2)
end
function c21520035.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
--[[
	local mg=eg:Clone()
	local sg=eg:Filter(Card.IsSetCard,nil,0x493)
	mg:Sub(sg)
	local tc=mg:GetFirst()
	local atk=0
	local def=0
	while tc do
		if tc:IsPosition(POS_ATTACK) then atk=atk+tc:GetAttack() end
		if tc:IsPosition(POS_DEFENSE) then def=def+tc:GetDefense() end
		tc=eg:GetNext()
	end
	return c:GetAttack()>=atk and c:GetDefense()>=def
--]]
	return c:GetAttack()>0 and c:GetDefense()>0 and Duel.GetCurrentChain()==0
end
function c21520035.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=eg:Clone()
--	local sg=eg:Filter(Card.IsSetCard,nil,0x493)
--	mg:Sub(sg)
	local tc=mg:GetFirst()
	local atk=0
	local def=0
--	local face=0
	local ag=Group.CreateGroup()
	local dg=Group.CreateGroup()
	while tc do
		if tc:IsPosition(POS_ATTACK) then 
			if tc:GetAttack()>0 then
				atk=atk+tc:GetAttack() 
				ag:AddCard(tc) 
			end
		end
		if tc:IsPosition(POS_DEFENSE) then 
			if tc:GetDefense()>0 then
				def=def+tc:GetDefense() 
				dg:AddCard(tc) 
			end
		end
--		face=face*16+tc:GetPreviousPosition()
		tc=mg:GetNext()
	end
	if c:GetAttack()>=atk and atk>0 and ag:GetCount()>0 then
		Duel.Hint(HINT_CARD,1-tp,21520035)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+0xdfc0000)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-atk)
		c:RegisterEffect(e1)
		Duel.NegateSummon(ag)
		local ac=ag:GetFirst()
		while ac do
			local loc=ac:GetPreviousLocation()
			c21520035.sendpreloc(ac,loc)
			ac=ag:GetNext()
		end
	end
	if c:GetDefense()>=def and def>0 and dg:GetCount()>0 then
		Duel.Hint(HINT_CARD,1-tp,21520035)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e2:SetReset(RESET_EVENT+0xdfc0000)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(-def)
		c:RegisterEffect(e2)
		Duel.NegateSummon(dg)
		local dc=dg:GetFirst()
		while dc do
			local loc=dc:GetPreviousLocation()
			c21520035.sendpreloc(dc,loc)
			dc=dg:GetNext()
		end
	end
end
function c21520035.sendpreloc(c,loc)
	local count=0
	local c1=0
	local c2=0
	local c3=0
	local c4=0
	local c5=0
	local c6=0
	if loc==LOCATION_DECK then c1=Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	elseif loc==LOCATION_HAND then c2=Duel.SendtoHand(c,nil,REASON_EFFECT)
	elseif loc==LOCATION_GRAVE then c3=Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	elseif loc==LOCATION_REMOVED then c4=Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	elseif loc==LOCATION_EXTRA then c5=Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	elseif loc==LOCATION_OVERLAY then c6=Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
	count=c1+c2+c3+c4+c5+c6
	return count
end
