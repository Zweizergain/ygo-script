--星曜成像
function c21520140.initial_effect(c)
	--activity
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520140,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_CUSTOM+21520140)
	e1:SetCondition(c21520140.condition)
	e1:SetTarget(c21520140.target)
	e1:SetOperation(c21520140.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetOperation(c21520140.reset)
	c:RegisterEffect(e2)
	if not c21520140.global_check then
		c21520140.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c21520140.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c21520140.checkop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Group.CreateGroup()
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0x5491) and tc:IsType(TYPE_MONSTER) then
			tc:RegisterFlagEffect(21520140,RESET_PHASE+PHASE_END,0,1)
			mg:AddCard(tc)
		end
		tc=eg:GetNext()
	end
	if mg:GetCount()>0 then Duel.RaiseEvent(mg,EVENT_CUSTOM+21520140,e,0,0,0,0) end
--	c21520140[0]=mg+c21520140[0]
end
function c21520140.cfilter(c,flag)
	if flag~=nil then
		return c:IsSetCard(0x5491) and c:IsType(TYPE_MONSTER) and c:GetFlagEffect(flag)~=0
	else
		return c:IsSetCard(0x5491) and c:IsType(TYPE_MONSTER)
	end
end
function c21520140.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c21520140.cfilter,tp,0xff,0xff,1,nil,21520140)
--	return eg:IsExists(c21520140.cfilter,1,nil,21520140)
--	return c21520140[0]:IsExists(c21520140.cfilter,1,nil,21520140)
end
function c21520140.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummon(tp) end
end
function c21520140.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
--	local tg=c21520140[0]
--	local g=tg:FilterSelect(tp,c21520140.cfilter,1,1,nil,21520140)
--	local g=eg:FilterSelect(tp,c21520140.cfilter,1,1,nil,21520140)
	local sg=Duel.GetMatchingGroup(c21520140.cfilter,tp,0xff,0xff,nil,21520140)
	local g=sg:Select(tp,1,1,nil)
	local atk=(g:GetFirst():GetBaseAttack())/2
	local tc=g:GetFirst()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	if not tc:IsImmuneToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		Duel.Damage(1-tp,atk,REASON_EFFECT)
		tc:ResetFlagEffect(21520140)
	end
--	c21520140[0]=nil
end
function c21520140.reset(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c21520140.cfilter,tp,0xff,0xff,nil,21520140)
	local tc=sg:GetFirst()
	while tc do
		tc:ResetFlagEffect(21520140)
		tc=sg:GetNext()
	end
end
