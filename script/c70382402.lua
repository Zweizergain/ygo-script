--雅乐之艳音花
local m=70382402
local set=0xef7
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,3,cm.ovfilter,aux.Stringid(m,0),3,cm.xyzop)
	c:EnableReviveLimit()
	--Draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.spcon)
	e2:SetCost(cm.spcost)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--cannot act
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetTargetRange(1,0)
	e3:SetValue(cm.aclimit)
	c:RegisterEffect(e3)
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xef7) and c:IsType(TYPE_XYZ)  and not c:IsCode(m)
end
function cm.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
	--Draw
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.Draw(tp,1,REASON_EFFECT)
end
	--atkup
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOriginalCode(0xef7)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,1)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil)==1
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=2 end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	tc:RegisterEffect(e1)
		Duel.BreakEffect()
		if Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_MZONE,1,nil,TYPE_MONSTER) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			local gn=Group.CreateGroup()
			local g2=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_MZONE,nil,TYPE_MONSTER)  
			while g2:GetCount()>0 do
				local tc2=g2:GetFirst()
				if tc2:IsCanBeBattleTarget(tc) then
					gn:AddCard(tc2)
					g2:RemoveCard(tc2)
				else
					g2:RemoveCard(tc2)
				end
			end
			if gn:GetCount()>0 then
				Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,2))
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
				local g1=gn:FilterSelect(tp,Card.IsType,1,1,nil,TYPE_MONSTER)
				if g1:GetCount()>0 then
					local tc1=g1:GetFirst()
					if tc1:IsLocation(LOCATION_MZONE) and tc:IsLocation(LOCATION_MZONE) then
						if not tc1:IsPosition(POS_FACEUP_ATTACK) then
							Duel.ChangePosition(tc1,POS_FACEUP_ATTACK)
						end
						if not tc:IsPosition(POS_FACEUP_ATTACK) then
							Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
						end
						if tc1:IsLocation(LOCATION_MZONE) and tc:IsLocation(LOCATION_MZONE) then 
							Duel.CalculateDamage(tc,tc1)
					end
				end
			end
		end
	end
end
	--cannot act
function cm.aclimit(e,re,tp)
	return not re:GetHandler():IsSetCard(0xef7) and not re:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP) and not re:GetHandler():IsImmuneToEffect(e)
end