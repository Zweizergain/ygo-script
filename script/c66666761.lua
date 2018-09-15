--白云龙鳞的少女
function c66666761.initial_effect(c)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66666761,0))
	e2:SetCountLimit(1,66666761+EFFECT_COUNT_CODE_OATH)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c66666761.sptg)
	e2:SetOperation(c66666761.spop)
	c:RegisterEffect(e2)
	--lv down
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_SYNCHRO_LEVEL)
	e12:SetValue(c66666761.lvval)
	c:RegisterEffect(e12)
	--draw1
	local e14=Effect.CreateEffect(c)
	e14:SetDescription(aux.Stringid(66666761,1))
	e14:SetCategory(CATEGORY_DRAW)
	e14:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e14:SetProperty(EFFECT_FLAG_DELAY)
	e14:SetCode(EVENT_DESTROYED)
	e14:SetCondition(c66666761.drcon1)
	e14:SetTarget(c66666761.target1)
	e14:SetOperation(c66666761.activate1)
	c:RegisterEffect(e14)
	--draw2
	local e24=Effect.CreateEffect(c)
	e24:SetDescription(aux.Stringid(66666761,2))
	e24:SetCategory(CATEGORY_DRAW)
	e24:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e24:SetProperty(EFFECT_FLAG_DELAY)
	e24:SetCode(EVENT_REMOVE)

	e24:SetTarget(c66666761.target2)
	e24:SetOperation(c66666761.activate2)
	c:RegisterEffect(e24)
end
function c66666761.lvval(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsCode(99999999) then return lv
	else
		if lv<=0 then return 16 end
		return lv-4
	end
end
function c66666761.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c66666761.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,66666761,nil,0x11,1600,2000,4,RACE_DRAGON,ATTRIBUTE_WATER) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		c:AddMonsterAttributeComplete()
	    local e1=Effect.CreateEffect(c)
	    e1:SetType(EFFECT_TYPE_SINGLE)
	    e1:SetCode(EFFECT_CHANGE_TYPE)
	    e1:SetValue(TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x1fe0000)
	    c:RegisterEffect(e1)
	    local e2=e1:Clone()
	    e2:SetCode(EFFECT_CHANGE_LEVEL)
	    e2:SetValue(4)
	    c:RegisterEffect(e2)
	    local e3=e1:Clone()
	    e3:SetCode(EFFECT_ADD_TYPE)
	    e3:SetValue(TYPE_TUNER)
	    c:RegisterEffect(e3)
	    local e4=e1:Clone()
	    e4:SetCode(EFFECT_CHANGE_RACE)
	    e4:SetValue(RACE_DRAGON)
	    c:RegisterEffect(e4)
	    local e5=e1:Clone()
	    e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	    e5:SetValue(ATTRIBUTE_WATER)
	    c:RegisterEffect(e5)
		local e6=e1:Clone()
	    e6:SetCode(EFFECT_SET_BASE_ATTACK)
	    e6:SetValue(1600)
	    c:RegisterEffect(e6)
		local e7=e1:Clone()
	    e7:SetCode(EFFECT_SET_BASE_DEFENSE)
	    e7:SetValue(1900)
	    c:RegisterEffect(e7)
		Duel.SpecialSummonComplete()
		local e11=Effect.CreateEffect(c)
		e11:SetType(EFFECT_TYPE_SINGLE)
	    e11:SetProperty(EFFECT_FLAG_OATH)
	    e11:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	    e11:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e11,true)
	    local e13=Effect.CreateEffect(c)
	    e13:SetType(EFFECT_TYPE_SINGLE)
	    e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        e13:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
       	e13:SetReset(RESET_EVENT+0x1fe0000)
		e13:SetValue(c66666761.exlimit)
	    c:RegisterEffect(e13,true)
	    local e14=e13:Clone()
	    e14:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	    c:RegisterEffect(e14,true)
	    local e15=e13:Clone()
	    e15:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	    c:RegisterEffect(e15,true)
		local e24=e13:Clone()
	    e24:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	    c:RegisterEffect(e24,true)
	end
end
function c66666761.exlimit(e,c)
	if not c then return false end
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
function c66666761.drcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetReasonPlayer()~=tp
	and c:IsReason(REASON_DESTROY) 
	and c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_DECK+LOCATION_HAND) 
	and c:GetPreviousControler()==tp 
end
function c66666761.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c66666761.activate1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c66666761.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetReasonPlayer()==1-tp and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c66666761.activate2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
