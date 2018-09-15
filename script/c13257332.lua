--里超时空战斗机-Star Soldier
function c13257332.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(aux.LinkCondition(c13257332.matfilter,1,1))
	e1:SetOperation(c13257332.LinkOperation(c13257332.matfilter,1,1))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	--Power Capsule
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13257332,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c13257332.pccon)
	e2:SetTarget(c13257332.pctg)
	e2:SetOperation(c13257332.pcop)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13257301,5))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c13257332.spcon)
	e4:SetTarget(c13257332.sptg)
	e4:SetOperation(c13257332.spop)
	c:RegisterEffect(e4)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_SPSUMMON_SUCCESS)
	e11:SetOperation(c13257332.bgmop)
	c:RegisterEffect(e11)
	eflist={"power_capsule",e2}
	c13257332[c]=eflist
	
end
function c13257332.LinkOperation(f,minc,maxc)
	return  function(e,tp,eg,ep,ev,re,r,rp,c)
				local mg=Duel.GetMatchingGroup(aux.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,c)
				local sg=Group.CreateGroup()
				for i=0,maxc-1 do
					local cg=mg:Filter(aux.LCheckRecursive,sg,tp,sg,mg,c,i,minc,maxc)
					if cg:GetCount()==0 then break end
					local minct=1
					if aux.LCheckGoal(tp,sg,c,minc,i) then
						if not Duel.SelectYesNo(tp,210) then break end
						minct=0
					end
					local g=cg:Select(tp,minct,1,nil)
					if g:GetCount()==0 then break end
					sg:Merge(g)
				end
				c:SetMaterial(sg)
				local tc=sg:GetFirst()
				local eg=Group.CreateGroup()
				while tc do
					eg:Merge(tc:GetEquipGroup())
					tc=sg:GetNext()
				end
				eg:KeepAlive()
				Duel.SendtoGrave(sg,REASON_MATERIAL+REASON_LINK)
				local e12=Effect.CreateEffect(c)
				e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
				e12:SetCode(EVENT_SPSUMMON_SUCCESS)
				e12:SetLabelObject(eg)
				e12:SetCondition(c13257332.eqcon)
				e12:SetOperation(c13257332.eqop)
				e12:SetReset(RESET_EVENT+0xff0000)
				c:RegisterEffect(e12)
			end
end
function c13257332.matfilter(c)
	return c:IsSetCard(0x351) and not c:IsType(TYPE_LINK)
end
function c13257332.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c13257332.eqfilter(c,ec)
	return c:CheckEquipTarget(ec)
end
function c13257332.eqfilter1(c,ec)
	return c:IsSetCard(0x352) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function c13257332.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eg=e:GetLabelObject()
	local tc=eg:GetFirst()
	eg=eg:Filter(c13257332.eqfilter,nil,c)
	if eg:GetCount()==0 then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<eg:GetCount() then
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		eg=eg:Select(tp,ft,ft,nil)
	end
	tc=eg:GetFirst()
	while tc do
		Duel.Equip(tp,tc,c,true,true)
		tc=eg:GetNext()
	end
	Duel.EquipComplete()
end
function c13257332.pcfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c13257332.pccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c13257332.pcfilter,1,nil,1-tp)
end
function c13257332.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local t1=Duel.IsExistingMatchingCard(c13257332.eqfilter1,tp,LOCATION_EXTRA,0,1,nil,c) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local t2=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
	if chk==0 then return t1 or t2 end
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(13257332,1))
	if t1 and t2 then
		op=Duel.SelectOption(tp,aux.Stringid(13257332,2),aux.Stringid(13257332,3))
	elseif t1 then
		op=Duel.SelectOption(tp,aux.Stringid(13257332,2))
	elseif t2 then
		op=Duel.SelectOption(tp,aux.Stringid(13257332,3))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_EQUIP)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
	elseif op==1 then
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCode(EFFECT_IMMUNE_EFFECT)
		e4:SetValue(c13257332.efilter)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
		e:GetHandler():RegisterEffect(e4)
	end
end
function c13257332.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c13257332.acfilter(c)
	return c:IsFaceup() and (c:GetAttack()>0 or c:GetDefense()>0)
end
function c13257332.desfilter(c)
	return c:IsFaceup() and (c:GetAttack()==0 or (c:GetDefense()==0 and not c:IsType(TYPE_LINK)))
end
function c13257332.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c13257332.eqfilter1,tp,LOCATION_EXTRA,0,1,1,nil,c)
		local tc=g:GetFirst()
		if tc then
			Duel.Equip(tp,tc,c)
		end
	elseif e:GetLabel()==1 then
		local g=Duel.GetMatchingGroup(c13257332.acfilter,tp,0,LOCATION_MZONE,nil)
		if g:GetCount()>0 then
			local sc=g:GetFirst()
			while sc do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetValue(-1000)
				sc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				sc:RegisterEffect(e2)
				sc=g:GetNext()
			end
			g=Duel.GetMatchingGroup(c13257332.desfilter,tp,0,LOCATION_MZONE,nil)
			if g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
	end
end
function c13257332.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipCount()==3
end
function c13257332.spfilter(c,e,tp)
	return c:IsCode(13257333) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c13257332.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCountFromEx(tp,tp,c)
	if chk==0 then return ft>-1 and c:IsReleasable() and Duel.IsExistingMatchingCard(c13257332.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	local sg=c:GetEquipGroup()
	sg:KeepAlive()
	e:SetLabelObject(sg)
	Duel.Release(c,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
	Duel.SetChainLimit(aux.FALSE)
end
function c13257332.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c13257332.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)==0 then return end
		local smc=g:GetFirst()
		local sg=e:GetLabelObject()
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local eg1=sg:Select(tp,2,2,nil)
			local tc=eg1:GetFirst()
			while tc do
				Duel.Equip(tp,tc,smc,true,true)
				tc=eg1:GetNext()
			end
			Duel.EquipComplete()
		end
	end
end
function c13257332.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(13257332,7))
end
