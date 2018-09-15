	--全人类的天乐录
function c1230001.initial_effect(c)
	c:SetUniqueOnField(1,0,1230001)
	--发动
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--抽卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1230001,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c1230001.condition)
	e2:SetOperation(c1230001.operation)
	c:RegisterEffect(e2)
	--summon with s/t
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1230001,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xae6))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c1230001.otcon)
	e1:SetOperation(c1230001.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
end
function c1230001.filter1(c)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))  
end
function c1230001.filter2(e,c)
	return c:IsSetCard(0xae6) or c:IsSetCard(0x123) or c:IsSetCard(0x075)
end
function c1230001.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Group.GetFirst(eg)
	return (tc:IsSetCard(0xae6) or tc:IsSetCard(0x123)) and tc:IsFaceup() 
		and tc:GetSummonPlayer()==tp and Card.GetFlagEffect(e:GetHandler(),1230001)<2
end
function c1230001.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,1230001)
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,0,0)
	Card.RegisterFlagEffect(e:GetHandler(),1230001,RESET_PHASE+PHASE_END,0,1)
end

function c1230001.filter56(c)
	return c:GetOriginalCode()==1230900 or c:GetOriginalCode()==1231000 or c:GetOriginalCode()==1231100
end
function c1230001.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_SZONE,0,nil)
	return ((c:GetLevel()>6 and not c1230001.filter56(c)) and minc<=2 and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>=2 or Duel.CheckTribute(c,1) and mg:GetCount()>=1))
		or ((((c:GetLevel()>4 or c:GetOriginalCode()==1231600) and c:GetLevel()<=6) or c1230001.filter56(c) ) and minc<=1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>=1)
end
function c1230001.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_SZONE,0,nil)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>=2
	local b2=Duel.CheckTribute(c,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	if c:IsCode(1230800) or c:IsCode(1231600) or c:IsCode(1231800) then 
		local g=mg:Select(tp,1,99,nil)
		if c:GetLevel()>6 and g:GetCount()==1 then
			local g2=nil
			if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(1230001,2))) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				g2=mg:Select(tp,1,99,g:GetFirst())
			else
				g2=Duel.SelectTribute(tp,c,1,99)
			end
			g:Merge(g2)
		else
			if b2 and Duel.SelectYesNo(tp,aux.Stringid(1230001,3)) then 
				g2=Duel.SelectTribute(tp,c,1,99)
				g:Merge(g2)
			end 
		end
		c:SetMaterial(g)
		Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)		
	elseif not (c:GetLevel()<5) then 
		local g=mg:Select(tp,1,1,nil)
		if c:GetLevel()>6 and not c1230001.filter56(c) then
			local g2=nil
			if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(1230001,2))) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				g2=mg:Select(tp,1,1,g:GetFirst())
			else
				g2=Duel.SelectTribute(tp,c,1,1)
			end
			g:Merge(g2)
		end
		c:SetMaterial(g)
		Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
	end 
end