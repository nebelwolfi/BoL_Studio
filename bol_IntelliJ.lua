-- Constants
function KEY_DOWN() end
function KEY_UP() end

function PING_NORMAL() end
function PING_FALLBACK() end

function TEAM_NONE() end
function TEAM_BLUE() end
function TEAM_RED() end
function TEAM_NEUTRAL() end
function TEAM_ENEMY() end

function WINDOW_X() end
function WINDOW_Y() end
function WINDOW_W() end
function WINDOW_H() end

function _Q() end
function _W() end
function _E() end
function _R() end
function SPELL_1() end
function SPELL_2() end
function SPELL_3() end
function SPELL_4() end
function ITEM_1() end
function ITEM_2() end
function ITEM_3() end
function ITEM_4() end
function ITEM_5() end
function ITEM_6() end
function RECALL() end
function SUMMONER_1() end
function SUMMONER_2() end

function READY() end
function NOTLEARNED() end
function SUPRESSED() end
function COOLDOWN() end
function NOMANA() end
function UNKNOWN() end

function FLOATTEXT_INVULNERABLE() end
function FLOATTEXT_SPECIAL() end
function FLOATTEXT_HEAL() end
function FLOATTEXT_MANAHEAL() end
function FLOATTEXT_MANADMG() end
function FLOATTEXT_DODGE() end
function FLOATTEXT_CRITICAL() end
function FLOATTEXT_EXPERIENCE() end
function FLOATTEXT_GOLD() end
function FLOATTEXT_LEVEL() end
function FLOATTEXT_DISABLE() end
function FLOATTEXT_QUESTRECV() end
function FLOATTEXT_QUESTDONE() end
function FLOATTEXT_SCORE() end
function FLOATTEXT_PHYSDMG() end
function FLOATTEXT_MAGICDMG() end
function FLOATTEXT_TRUEDMG() end
function FLOATTEXT_ENEMYPHYSDMG() end
function FLOATTEXT_ENEMYMAGICDMG() end
function FLOATTEXT_ENEMYTRUEDMG() end
function FLOATTEXT_ENEMYCRITICAL() end
function FLOATTEXT_COUNTDOWN() end
function FLOATTEXT_LEGACY() end
function FLOATTEXT_LEGACYCRITICAL() end
function FLOATTEXT_DEBUG() end

-- Spell
local spell = {}
function spell.name() end
function spell.level() end
function spell.mana() end
function spell.cd() end
function spell.currentCd() end
function spell.range() end
function spell.channelDuration() end

-- Pos
local pos = {}
function pos.x () end
function pos.y () end

-- Pos3d
local pos3D = {}
function pos.x () end
function pos.y () end
function pos.z () end

-- CUnit
local unit = { }
function unit.name() end
function unit.charName() end
function unit.level() end
function unit.visible() end
function unit.type() end
function unit.x() end
function unit.y() end
function unit.z() end
function unit.isAI() end
function unit.isMe() end
function unit.buffCount() end
function unit.totalDamage() end
function unit.dead() end
function unit.team() end
function unit.networkID() end
function unit.health() end
function unit.maxHealth() end
function unit.mana() end
function unit.maxMana() end
function unit.controlled() end
function unit.cdr() end
function unit.critChance() end
function unit.critDmg() end
function unit.hpPool() end
function unit.mpRegen() end
function unit.attackSpeed() end
function unit.expBonus() end
function unit.hardness() end
function unit.lifeSteal() end
function unit.spellVamp() end
function unit.physReduction () end
function unit.magicReduction() end
function unit.hpRegen() end
function unit.armorPen() end
function unit.magicPen() end
function unit.armorPenPercent() end
function unit.magicPenPerecent() end
function unit.addDamage() end
function unit.ap() end
function unit.damage() end
function unit.armor() end
function unit.magicArmor() end
function unit.ms() end
function unit.range() end
function unit.gold() end

function unit:HoldPosition() end
function unit:MoveTo(x, z) end
function unit:Attack(target) end
function unit:GetDistance(target) end
function unit:CalcDamage(target,fDmg) end
function unit:CalcMagicDamage(target,fDmg) end
function unit:getBuff(iIndex) end --returns buff name
function unit:getInventorySlot(iSlot) end --from ITEM_1 to ITEM_6

-- Sprites
local sprite = {}
function sprite.Draw(x, y, alpha) end -- Draws sprite
function sprite.Release() end -- Release Sprite

-- LoLPacket
local LoLPacket = {}
function LoLPacket.dwArg1() end                         -- Return network Arg1
function LoLPacket.dwArg2() end                         -- Return network Arg2
function LoLPacket.header() end                         -- Return network headers
function LoLPacket.pos() end                            -- Return the current pos in the dump
function LoLPacket.size() end                           -- Return the size of the dump
function LoLPacket.Decode1() end      -- Returns 1 byte and increases the read pos by 1
function LoLPacket.Decode2() end       -- Returns a word and increases the read pos by 2
function LoLPacket.Decode4() end       -- Return a long and increases the read pos by 4
function LoLPacket.Encode1(eByte) end        -- Encode a byte
function LoLPacket.Encode2(eWord) end        -- Encode a word
function LoLPacket.Encode4(eLong) end        -- Encode a long
function LoLPacket.EncodeStr(eStr) end       -- Encode a string
function LoLPacket.getRemaining() end
function LoLPacket.skip() end

-- Global Functions
function EnableZoomHack() end
function IsKeyPressed(wParam) end    -- Returns true/false is key was pressed
function IsKeyDown(wParam) end      -- Returns true/false is key is down
function CanUseSpell(iSpell) end -- Returns SpellState
function CastSpell(iSpell) end --Uses Spell
function CastSpell(iSpell,x,z) end --Uses Spell at position
function CastSpell(iSpell,target) end --Uses Spell at Target Position
function SendChat(text) end --Send Chat
function BlockChat() end --Blocks next send chat
function LevelSpell(iSpell) end
function DrawText(text,size,x,y,ARGB) end --Draw Text over Screen
function DrawLine(x1, y1, x2, y2, size, ARGB) end -- Draw line over Screen
function DrawCircle(x,y,z,size,color) end --Draw a Circle around object
function GetMyHero() return unit end --Returns your Player
function GetTarget() return unit end --Returns your target
function GetTickCount() end --Returns current tick
function GetSpellData(iSpell) return spell end --Returns SpellData
function GetLatency() end -- Returns latency
function PrintChat(text) end --Prints to Chat
function PrintFloatText(target,iMode,text) end --Prints a float text above object
function PingSignal(iMode,x,y,z,bPing) end -- Creates a PingSignal
function BuyItem(itemID) end -- Buys an item
function SellItem(iSlot) end -- Sells an item
function IsItemPurchasable(itemID) end -- Returns if an item is purchasable
function IsRecipePurchasable(recipeID) end -- Returns if a recipe is purchasable
function GetCursorPos() return pos end --Returns Cursor pos
function WorldToScreen(unit) return pos3D end -- returns a pos , you need to check "if .z < 1" to know if its inside your screen, it returns the screen pos at .x and .y
function createSprite(szFile) return sprite end -- return sprite object, loads file from "Sprites" folder
function CLoLPacket(size) return LoLPacket end -- Return new LoLPacket
function SendPacket(LoLPacket) end -- Send a LoLPacket

-- Mouse Position
mousePos = {}
function mousePos.x() end
function mousePos.y() end
function mousePos.z() end

-- Camera Pos
cameraPos = {}
function cameraPos.x() end
function cameraPos.y() end
function cameraPos.z() end

-- CallBacks
function OnLoad() end
function OnDraw() end
function OnTick() end
function OnUnload() end
function OnCreateObj(object) end
function OnDeleteObj(object) end
function OnWndMsg(msg,wParam) end
function OnProcessSpell(object,spell) end
function OnSendChat(text) end
function OnRecvPacket(LoLPacket) end
function OnSendPacket(LoLPacket) end

-- Object Manager
objManager = {}
function objManager.maxObjects () end
function objManager.iCount() end
function objManager:getObject(index) return unit end

-- Hero Manager
heroManager = { }
function heroManager.iCount() end
function heroManager:getHero(index) return unit end

