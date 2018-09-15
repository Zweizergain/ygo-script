--T·F·D Scorn
function c50218212.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xcb2),2,true)
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(c50218212.splimit)
    c:RegisterEffect(e1)
    --special summon rule
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(c50218212.sprcon)
    e2:SetOperation(c50218212.sprop)
    c:RegisterEffect(e2)
    --pos
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(50218212,0))
    e3:SetCategory(CATEGORY_POSITION)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
    e3:SetCountLimit(1)
    e3:SetCondition(c50218212.poscon)
    e3:SetTarget(c50218212.postg)
    e3:SetOperation(c50218212.posop)
    c:RegisterEffect(e3)
    --immune
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetCondition(c50218212.immcon)
    e4:SetValue(c50218212.efilter)
    c:RegisterEffect(e4)
    --cannot remove
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_CANNOT_REMOVE)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(1,1)
    e5:SetCondition(c50218212.cond)
    c:RegisterEffect(e5)
end
function c50218212.splimit(e,se,sp,st)
    return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c50218212.spfilter(c)
    return c:IsFusionSetCard(0xcb2) and c:IsCanBeFusionMaterial() and c:IsAbleToGraveAsCost()
end
function c50218212.fselect(c,tp,mg,sg)
    sg:AddCard(c)
    local res=false
    if sg:GetCount()<2 then
        res=mg:IsExists(c50218212.fselect,1,sg,tp,mg,sg)
    else
        res=Duel.GetLocationCountFromEx(tp,tp,sg)>0
    end
    sg:RemoveCard(c)
    return res
end
function c50218212.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local mg=Duel.GetMatchingGroup(c50218212.spfilter,tp,LOCATION_MZONE,0,nil)
    local sg=Group.CreateGroup()
    return mg:IsExists(c50218212.fselect,1,nil,tp,mg,sg)
end
function c50218212.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c50218212.spfilter,tp,LOCATION_MZONE,0,nil)
    local sg=Group.CreateGroup()
    while sg:GetCount()<2 do
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g=mg:FilterSelect(tp,c50218212.fselect,1,1,sg,tp,mg,sg)
        sg:Merge(g)
    end
    local cg=sg:Filter(Card.IsFacedown,nil)
    if cg:GetCount()>0 then
        Duel.ConfirmCards(1-tp,cg)
    end
    Duel.SendtoGrave(sg,nil,2,REASON_COST)
end
function c50218212.poscon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c50218212.postg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c50218212.posop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
    end
end
function c50218212.immcon(e)
    return Duel.GetAttacker()==e:GetHandler()
end
function c50218212.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c50218212.cond(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsDisabled() and e:GetHandler():IsDefensePos()
end