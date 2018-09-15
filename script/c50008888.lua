--梦之咲·学院
local m=50008888
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --token
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(50008888,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,50008888)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCondition(c50008888.sccon)
    e2:SetTarget(c50008888.sctg)
    e2:SetOperation(c50008888.scop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    --indes
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e4:SetRange(LOCATION_FZONE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetTarget(c50008888.tgtg)
    e4:SetValue(c50008888.indval)
    c:RegisterEffect(e4)
    --cannot be target
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e5:SetRange(LOCATION_FZONE)
    e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetTarget(c50008888.tgtg)
    e5:SetValue(aux.tgoval)
    c:RegisterEffect(e5)
end
function c50008888.tgtg(e,c)
    return c:IsType(TYPE_TOKEN)
end
function c50008888.indval(e,re,rp)
    return rp~=e:GetHandlerPlayer()
end

function c50008888.scfilter(c,tp)
    return c:IsFaceup() and not c:IsType(TYPE_TOKEN)
end

function c50008888.sccon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c50008888.scfilter,1,nil,tp)
end

function c50008888.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
    --if chk==0 then return true end
    --Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
    if chk==0 then return e:GetHandler():IsRelateToEffect(e) 
        and Duel.IsPlayerCanSpecialSummonMonster(tps,500088888,0,0x4011,2000,1000,2,RACE_SPELLCASTER,ATTRIBUTE_DARK,POS_FACEUP_ATTACK,tps) 
    end
    Duel.SetTargetCard(eg)
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c50008888.scop(e,tp,eg,ep,ev,re,r,rp)
    --Duel.NegateSummon(eg)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=eg:Filter(Card.IsRelateToEffect,nil,e)
    if g:GetCount()>0 then
        if  Duel.Destroy(g,REASON_EFFECT)~=0 then
             local dg=Duel.GetOperatedGroup()
             local tc=dg:GetFirst()
             local tps=tc:GetControler()
            if Duel.GetLocationCount(tps,LOCATION_MZONE)>0
                and Duel.IsPlayerCanSpecialSummonMonster(tps,500088888,0,0x4011,2000,1000,2,RACE_SPELLCASTER,ATTRIBUTE_DARK,POS_FACEUP_ATTACK,tps) then
                local token=Duel.CreateToken(tp,500088888)
                Duel.SpecialSummonStep(token,0,tp,tps,false,false,POS_FACEUP_ATTACK)
            end
            Duel.SpecialSummonComplete()
        end
    end
end
