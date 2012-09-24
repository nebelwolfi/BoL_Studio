if player == nil then player = GetMyHero() end
if LIB_PATH == nil then LIB_PATH = debug.getinfo(1).source:sub(debug.getinfo(1).source:find(".*\\")):sub(2) end
if SCRIPT_PATH == nil then SCRIPT_PATH = LIB_PATH:gsub("\\", "/"):gsub("/Common", "") end
if SPRITE_PATH == nil then SPRITE_PATH = SCRIPT_PATH:gsub("\\", "/"):gsub("/Scripts", "").."Sprites/" end

TEAM_ENEMY = (player.team == TEAM_BLUE and TEAM_RED or TEAM_BLUE)

function GetDistance(p1, p2)
	if p2 == nil then p2 = player end
    if p1.z == nil or p2.z == nil then return math.sqrt((p1.x-p2.x)^2+(p1.y-p2.y)^2)
	else return math.sqrt((p1.x-p2.x)^2+(p1.z-p2.z)^2) end
end
-- for compat
GetDistance2D = GetDistance

function ValidTarget(object, distance)
    return object ~= nil and object.team ~= player.team and object.visible and not object.dead and object.bTargetable and object.bInvulnerable == 0 and (distance == nil or GetDistance(object) <= distance)
end

function ValidTargetNear(object, distance, target)
   return object ~= nil and object.team == target.team and object.visible and not object.dead and object.bTargetable and GetDistance(target, object) <= distance
end

function GetDistanceFromMouse(object)
	if target ~= nil then return GetDistance(object, mousePos) end
	return 100000
end

-- Round a number
if math.round == nil then
	function math.round(num, idp)
		local mult = 10^(idp or 0)
		return math.floor(num * mult + 0.5) / mult
	end
end
if math.close == nil then
	function math.close(a,b,eps)
		eps = eps or 1e-9
		return math.abs(a - b) <= eps
	end
end

-- return true if file exist
function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

-- return if cursor is under a rectangle
function CursorIsUnder(x, y, sizeX, sizeY)
	local posX, posY = GetCursorPos().x, GetCursorPos().y
	if sizeY == nil then sizeY = sizeX end
	if sizeX < 0 then
		x = x + sizeX
		sizeX = - sizeX
	end
	if sizeY < 0 then
		y = y + sizeY
		sizeY = - sizeY
	end
	return (posX >= x and posX <= x + sizeX and posY >= y and posY <= y + sizeY)
end

--return texted version of a timer
function TimerText(seconds, len)
	if type(seconds) ~= "number" or seconds > 100000 or seconds < 0 then return " ? " end
	local minutes = seconds / 60
	local returnText
	if minutes >= 60 then
		returnText = string.format("%i:%02i:%02i", minutes / 60, minutes, seconds % 60)
	elseif minutes >= 1 then
		returnText = string.format("%i:%02i", minutes, seconds % 60)
	else
		returnText = string.format(":%02i", seconds % 60)
	end
	if len ~= nil then
		while string.len(returnText) < len do
			returnText = " "..returnText.." "
		end
	end
	return returnText
end
-- for compat
timerText = TimerText

-- return sprite
function GetSprite(file, altFile)
	if file_exists(SPRITE_PATH..file) == true then
		return createSprite(file)
	else
		if altFile ~= nil and file_exists(SPRITE_PATH..altFile) == true then
			return createSprite(altFile)
		else
			PrintChat(file.." not found (sprites installed ?)")
			return createSprite("empty.dds")
		end
	end
end
returnSprite = GetSprite

-- return real hero leveled
function GetHeroLeveled()
	return player:GetSpellData(SPELL_1).level + player:GetSpellData(SPELL_2).level + player:GetSpellData(SPELL_3).level + player:GetSpellData(SPELL_4).level
end


-- return if target have particule
function GetTargetParticule(target, particule, range)
	local range = range or 50
	for i = 1, objManager.maxObjects do
		local object = objManager:GetObject(i)
		if object ~= nil and object.name == particule and GetDistance(target,object) < range then return true end
	end
	return false
end

--[[
        Class: Vector

		API :
		---- functions ----
		VectorType(v)							-- return if as vector
		VectorIntersection(a1,b1,a2,b2)			-- return the Intersection of 2 lines
		VectorDirection(v1,v2,v)
		VectorIntersectionFromPoint(v1, v2, v)  -- return a vector on line v1-v2 closest to v
		Vector(a,b)								-- return a vector from x,y pos or from another vector
		
		---- Vector Members ----
		x
		z
		
		---- Vector Functions ----
		vector:clone()							-- return a new Vector from vector
		vector:unpack()							-- x, z
		vector:len2()
		vector:len()							-- return vector length
		vector:dist(v)							-- distance between 2 vectors (v and vector)
		vector:normalize()						-- normalize vector
		vector:normalized()						-- return a new Vector normalize from vector
		vector:rotate(phi)						-- rotate the vector by phi angle
		vector:rotated(phi)						-- return a new Vector rotate from vector by phi angle
		vector:polar()							-- return the angle from axe
		vector:angleBetween(v1, v2)				-- return the angle formed from vector to v1,v2
		vector:projectOn(v)						-- return a new Vector from vector projected on v
		vector:mirrorOn(v)						-- return a new Vector from vector mirrored on v
		vector:cross(v)							-- return cross
		vector:center(v)						-- return center between vector and v
		vector:compare(v)						-- compare vector and v
		vector:perpendicular()					-- return new Vector rotated 90° rigth
		vector:perpendicular2()					-- return new Vector rotated 90° left
]]

-- STAND ALONE FUNCTIONS
function VectorType(v)
	return (v ~= nil and type(v.x) == "number" and type(v.z) == "number")
end

function VectorIntersection(a1,b1,a2,b2)
	assert(VectorType(a1) and VectorType(b1) and VectorType(a2) and VectorType(b2), "direction: wrong argument types (4 <Vector> expected)")
	if math.close(b1.x, 0) and math.close(b2.z, 0) then return Vector(a1.x, a2.z) end
	if math.close(b1.z, 0) and math.close(b2.x, 0) then return Vector(a2.x, a1.z) end
	local m1 = (not math.close(b1.x, 0)) and b1.z / b1.x or 0
	local m2 = (not math.close(b2.x, 0)) and b2.z / b2.x or 0
	if math.close(m1, m2) then return nil end
	local c1 = a1.z - m1 * a1.x
	local c2 = a2.z - m2 * a2.x
	local ix = (c2 - c1) / (m1 - m2)
	local iy = m1 * ix + c1
	if math.close(b1.x, 0) then return Vector(a1.x, a1.x * m2 + c2) end
	if math.close(b2.x, 0) then return Vector(a2.x, a2.x * m1 + c1) end
	return Vector(ix, iy)
end

function VectorDirection(v1,v2,v)
	assert(VectorType(v1) and VectorType(v2) and VectorType(v), "direction: wrong argument types (3 <Vector> expected)")
	return (v1.x - v2.x) * (v.z - v2.z) - (v.x - v2.x) * (v1.z - v2.z)
end

function VectorIntersectionFromPoint(v1, v2, v)
	local line = Vector(v2) - v1
	local t = ((-(v1.x * line.x - line.x * v.x + (v1.z - v.z) * line.z)) / line:len2())
	return (line * t) + v1
end


class 'Vector'
-- INSTANCED FUNCTIONS
function Vector:__init(a,b)
	if a == nil then
		self.x, self.z = 0, 0
	elseif b == nil then
		if VectorType(a) then
			self.x, self.z = a.x, a.z
		else
			assert(type(a.x) == "number" and type(a.y) == "number", "Vector: wrong argument types (expected nil or <Vector> or 2 <number>)")
			self.x, self.z = a.x, a.y
		end
	else
		assert(type(a) == "number" and type(b) == "number", "Vector: wrong argument types (expected nil or <Vector> or 2 <number>)")
		self.x = a
		self.z = b
	end
end

function Vector:__add(v)
	assert(VectorType(v), "add: wrong argument types (<Vector> expected)")
	return Vector(self.x + v.x, self.z + v.z)
end

function Vector:__sub(v)
	assert(VectorType(v), "Sub: wrong argument types (<Vector> expected)")
	return Vector(self.x - v.x, self.z - v.z)
end

function Vector:__mul(v)
	if type(v) == "number" then
		return Vector(self.x * v, self.z * v)
	else
		assert(VectorType(v), "Mul: wrong argument types (<Vector> or <number> expected)")
		return Vector(self.x * v.x, self.z * v.z)
	end
end

function Vector:__div(v)
	if type(v) == "number" then
		assert(v ~= 0, "Div: wrong argument types (expected divider ~= 0)")
		return Vector(self.x / v, self.z / v)
	else
		assert(VectorType(v), "Div: wrong argument types (<Vector> or <number> expected)")
		assert(v.x ~= 0 and v.z ~= 0, "Div: wrong argument types (expected divider ~= 0)")
		return Vector(self.x / v.x, self.z / v.z)
	end
end

function Vector:__lt(v)
	assert(VectorType(v), "__lt: wrong argument types (<Vector> expected)")
	return self.x < v.x or (self.x == v.x and self.z < v.z)
end

function Vector:__le(v)
	assert(VectorType(v), "__le: wrong argument types (<Vector> expected)")
	return self.x <= v.x and self.z <= v.z
end

function Vector:__eq(v)
	assert(VectorType(v), "__eq: wrong argument types (<Vector> expected)")
	return self.x == v.x and self.z == v.z
end

function Vector:__unm()
	return Vector(- self.x, - self.z)
end

function Vector:__tostring()
	return "("..tostring(self.x)..","..tostring(self.z)..")"
end

function Vector:clone()
	return Vector(self.x, self.z)
end

function Vector:unpack()
	return self.x, self.z
end

-- old LengthSQ
function Vector:len2()
	return self.x * self.x + self.z * self.z
end

-- old Length
function Vector:len()
	return math.sqrt(self:len2())
end

function Vector:dist(v)
	assert(VectorType(v), "dist: wrong argument types (<Vector> expected)")
	return self:__sub(v):len()
end

function Vector:normalize()
	local len = self:len()
	if len ~= 0 then self.x, self.z = self.x / len, self.z / len end
end

function Vector:normalized()
	local a = self:clone()
	a:normalize()
	return a
end

function Vector:rotate(phi)
	assert(type(phi) == "number", "Rotate: wrong argument types (expected <number> for phi)")
	local c, s = math.cos(phi), math.sin(phi)
	self.x, self.z = c * self.x - s * self.z, s * self.x + c * self.z
end

function Vector:rotated(phi)
	assert(type(phi) == "number", "Rotated: wrong argument types (expected <number> for phi)")
	local a = self:clone()
	a:rotate(phi)
	return a
end

function Vector:polar()
	if math.close(self.x, 0) then
		if self.z > 0 then return 90
		elseif self.z < 0 then return 270
		else return 0
		end
	else
		local theta = math.deg(math.atan(self.z / self.x))
		if self.x < 0 then theta = theta + 180 end
		if theta < 0 then theta = theta + 360 end
		return theta
	end
end

function Vector:angleBetween(v1, v2)
	assert(VectorType(v1) and VectorType(v2), "angleBetween: wrong argument types (2 <Vector> expected)")
	local p1, p2 = (-self + v1), (-self + v2)
	local theta = p1:polar() - p2:polar()
	if theta < 0 then theta = theta + 360 end
	if theta > 180 then theta = 360 - theta end
	return theta
end

function Vector:projectOn(v)
	assert(VectorType(v), "projectOn: invalid argument: cannot project Vector on " .. type(v))
	local s = (self.x * v.x + self.z * v.z) / (v.x * v.x + v.z * v.z)
	return Vector(s * v.x, s * v.z)
end

function Vector:mirrorOn(v)
	assert(VectorType(v), "mirrorOn: invalid argument: cannot mirror Vector on " .. type(v))
	local s = 2 * (self.x * v.x + self.z * v.z) / (v.x * v.x + v.z * v.z)
	return Vector(s * v.x - self.x, s * v.z - self.z)
end

function Vector:cross(v)
	assert(VectorType(v), "cross: wrong argument types (<Vector> expected)")
	return self.x * v.z - self.z * v.x
end

function Vector:center(v)
	assert(VectorType(v), "center: wrong argument types (<Vector> expected)")
	return Vector((self.x + v.x) / 2, (self.z + v.z) / 2)
end

function Vector:compare(v)
	assert(VectorType(v), "compare: wrong argument types (<Vector> expected)")
	local ret = self.x - v.x
	if ret == 0 then ret = self.z - v.z	end
	return ret
end

function Vector:perpendicular()
	return Vector(-self.z, self.x)
end

function Vector:perpendicular2()
	return Vector(self.z, -self.x)
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Circle Class

--[[
Circle Class :
Methods:
circle = Circle(center (opt),radius (opt))

Function :
circle:Contains(v)		-- return if Vector point v is in the circle

Members :
circle.center		-- Vector point for circle's center
circle.radius			-- radius of the circle
]]

class 'Circle'

function Circle:__init(center,radius)
	assert((VectorType(center) or center == nil) and (type(radius) == "number" or radius == nil), "Circle: wrong argument types (expected <Vector> or nil, <number> or nil)")
	self.center = Vector(center) or Vector()
	self.radius = radius or 0
end

function Circle:Contains(v)
	assert(VectorType(v), "Contains: wrong argument types (expected <Vector>)")
	return math.close(self.center:dist(v),self.radius)
end

function Circle:__tostring()
	return "{center: " .. tostring(self.center) .. ", radius: " .. tostring(self.radius) .. "}"
end


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Minimum Enclosing Circle class
--[[
Global function ;
GetMEC(R, range) 					-- Find Group Center From Nearest Enemies
GetMEC(R, range, target) 			-- Find Group Center Near Target

MEC Class :
Methods:
mec = MEC(points (opt))

Function :
mec:SetPoints(points)
mec:HalfHull(left, right, pointTable, factor)		-- return table
mec:ConvexHull()						-- return table
mec:Compute()

Members :
mec.circle
mec.points
]]

class 'MEC'

function MEC:__init(points)
	self.circle = Circle()
	self.points = {}
	if points then
		self:SetPoints(points)
	end
end

function MEC:SetPoints(points)
	-- Set the points
	self.points = {}
	for i, p in ipairs(points) do
		table.insert(self.points, {Vector(p)})
	end
end

function MEC:HalfHull(left, right, pointTable, factor)
	-- Computes the half hull of a set of points
	local input = pointTable
	table.insert(input, right)
	local half = {}
	table.insert(half, left)
	for i,p in ipairs(input) do
		table.insert(half, p)
		while #half >= 3 do
			local dir = factor * VectorDirection(half[(#half+1)-3], half[(#half+1)-1], half[(#half+1)-2])
			if dir <= 0 then
				table.remove(half,#half-1)
			else
				break
			end
		end
	end
	return half
end

function MEC:ConvexHull()
	-- Computes the set of points that represent the convex hull of the set of points
	local left, right = self.points[1], self.points[#self.points]
	local upper, lower, ret = {}, {}, {}
	-- Partition remaining points into upper and lower buckets.
	for i = 2, #self.points-1 do
		table.insert((VectorDirection(left, right, self.points[i]) < 0 and upper or lower), self.points[i])
	end
	local upperHull = self:HalfHull(left, right, upper, -1)
	local lowerHull = self:HalfHull(left, right, lower, 1)
	local unique = {}
	for i,p in ipairs(upperHull) do
		unique["x" .. p.x .. "z" .. p.z] = p 
	end
	for i,p in ipairs(lowerHull) do
		unique["x" .. p.x .. "z" .. p.z] = p
	end
	for i,p in pairs(unique) do
		table.insert(ret, p)
	end
	return ret
end

function MEC:Compute()
	-- Compute the MEC.
	-- Make sure there are some points.
	if #self.points == 0 then return nil end
	-- Handle degenerate cases first
	if #self.points == 1 then
		self.circle.center = self.points[1]
		self.circle.radius = 0
		self.circle.radiusPoint = self.points[1]
	elseif #self.points == 2 then
		local a = self.points
		self.circle.center = a[1]:center(a[2])
		self.circle.radius = a[1]:Distance(self.circle.center)
		self.circle.radiusPoint = a[1]
	else
		local a = self:ConvexHull()
		local point_a = a[1]
		local point_b = nil
		local point_c = a[2]
		if not point_c then
			self.circle.center = point_a
			self.circle.radius = 0
			self.circle.radiusPoint = point_a
			return self.circle
		end
		-- Loop until we get appropriate values for point_a and point_c
		while true do
			point_b = nil
			local best_theta = 180.0
			-- Search for the point "b" which subtends the smallest angle a-b-c. 
			for i,point in ipairs(self.points) do
				if (not point == point_a) and (not point == point_c) then
					local theta_abc = point:angleBetween(point_a, point_c)
					if theta_abc < best_theta then
						point_b = point
						best_theta = theta_abc
					end                             
				end
			end
			-- If the angle is obtuse, then line a-c is the diameter of the circle,
			-- so we can return.
			if best_theta >= 90.0 or (not point_b) then
				self.circle.center = point_a:center(point_c)
				self.circle.radius = point_a:Distance(self.circle.center)
				self.circle.radiusPoint = point_a
				return self.circle
			end
			local ang_bca = point_c:angleBetween(point_b, point_a)
			local ang_cab = point_a:angleBetween(point_c, point_b)
			if ang_bca > 90.0 then
				point_c = point_b
			elseif ang_cab <= 90.0 then
				break
			else
				point_a = point_b
			end
		end
		local ch1 = (point_b - point_a) * 0.5
		local ch2 = (point_c - point_a) * 0.5
		local n1 = ch1:perpendicular2()
		local n2 = ch2:perpendicular2()
		ch1 = point_a + ch1
		ch2 = point_a + ch2
		self.circle.center = VectorIntersection(ch1, n1, ch2, n2)
		self.circle.radius = self.circle.center:dist(point_a)
		self.circle.radiusPoint = point_a
	end
	return self.circle
end

function GetMEC(radius, range, target)
    assert(type(radius) == "number" and type(range) == "number" and (target == nil or target.team ~= nil), "GetMEC: wrong argument types (expected <number>, <number>, <object> or nil)")
	local points = {}
    for i = 1, heroManager.iCount do
        local object = heroManager:GetHero(i)
		if (target and ValidTargetNear(object,radius*2,target)) or (target == nil and ValidTarget(object, (range + radius))) then
			table.insert(points, Vector(object))
		end
    end
    return _CalcSpellPosForGroup(radius,points)
end

function _CalcSpellPosForGroup(radius, points)
    if #points == 0 then
		return nil
	elseif #points == 1 then
        return Circle(Vector(points[1]))
    end
	mec = MEC()
	local combos = {}
    for j = #points,2,-1 do
		local spellPos = nil
		combos[j] = {}
        _CalcCombos(j,points,combos[j])
        for i,v in ipairs(combos[j]) do
            mec:SetPoints(v)
            local c = mec:Compute()
            if c.radius <= radius and (spellPos == nil or c.radius < spellPos.radius) then
                spellPos = Circle(c.center, c.radius)
            end
        end
        if spellPos ~= nil then return spellPos end
    end
end

function _CalcCombos(comboSize,targetsTable,comboTableToFill,comboString,index_number)
    local comboString = comboString or ""
	local index_number = index_number or 1
	local ret = comboTableToFill or {}
	if string.len(comboString) == comboSize then
        local b = {}
        for i=1,string.len(comboString),1 do
            local ai = tonumber(string.sub(comboString,i,i))
            table.insert(b,targetsTable[ai])
        end
        return table.insert(comboTableToFill,b)
    end
    for i = index_number, #targetsTable, 1 do
        _CalcCombos(comboSize,targetsTable,comboTableToFill, comboString..i, i+1)
    end
end

-- for compat
FindGroupCenterFromNearestEnemies = GetMEC
function FindGroupCenterNearTarget(target,radius,range)
	return GetMEC(radius, range, target)
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TargetSelector Class

--[[
TargetSelector Class :
Methods:
ts = TargetSelector(mode, range, targetSelectedMode (opt), magicDmgBase (opt), physicalDmgBase (opt), trueDmg (opt))

Goblal Functions :
TargetSelectorPriority()			-> print Priority (global)

TargetSelectorSetFocus() 			-> set priority to the selected champion (you need to use PRIORITY modes to use it) (global)
TargetSelectorSetFocus(id)			-> set priority to the championID (you need to use PRIORITY modes to use it) (global)
TargetSelectorSetFocus(charName)	-> set priority to the champion charName (you need to use PRIORITY modes to use it) (global)
TargetSelectorSetFocus(hero) 		-> set priority to the hero object (you need to use PRIORITY modes to use it) (global)

TargetSelectorSetHeroPriority(priority, target)	-> set the priority to target
TargetSelectorSetPriority(target1, target2, target3, target4, target5) -> set priority in order to targets

TargetSelector__OnSendChat(msg) 			-- to add to OnSendChat(msg) function if you want the chat command

TargetSelector(mode, range)			-- return a TS instance with defaut values
TargetSelector(mode, range, targetSelectedMode, magicDmgBase, physicalDmgBase, trueDmg) -- return a TS instance

Functions :
TargetSelector:updateTarget() 		-- update the instance target

Members:
ts.mode 					-> TARGET_LOW_HP, TARGET_MOST_AP, TARGET_MOST_AD, TARGET_PRIORITY, TARGET_NEAR_MOUSE, TARGET_LOW_HP_PRIORITY, TARGET_LESS_CAST, TARGET_LESS_CAST_PRIORITY
ts.range 					-> number > 0
ts.targetSelectedMode 		-> true/false
ts.magicDmgBase 			-> positive integer
ts.physicalDmgBase 			-> positive integer
ts.trueDmg 					-> positive integer
ts.conditional(object) 		-> function that return true/false to allow external filter
ts.target 					-> return the target (object or nil)

Usage :
variable = TargetSelector(mode, range, targetSelectedMode (opt), magicDmgBase (opt), physicalDmgBase (opt), trueDmg (opt))
targetSelectedMode is set to true if not filled
Damages are set to 0 if not filled
Damages are set as default to magic 100 if none is set

when you want to update, call variable:updateTarget()

Values you can change on instance :
variable.mode -> TARGET_LOW_HP, TARGET_MOST_AP, TARGET_PRIORITY, TARGET_NEAR_MOUSE, TARGET_LOW_HP_PRIORITY, TARGET_LESS_CAST, TARGET_LESS_CAST_PRIORITY
variable.range -> number > 0
variable.targetSelectedMode -> true/false
variable.magicDmgBase -> positive integer
variable.physicalDmgBase -> positive integer
variable.trueDmg -> positive integer
variable.conditional(object) -> function that return true/false to allow external filter

ex :
function OnLoad()
	ts = TargetSelector(TARGET_LESS_CAST, 600, true, 200)
end

function OnTick()
	ts:updateTarget()
	if ts.target ~= nil then
		PrintChat(ts.target.charName)
		ts.magicDmgBase = (player.ap * 10)
	end
end

function OnSendChat(msg)
	TargetSelector__OnSendChat(msg)
end

]]

-- Class related constants
TARGET_LOW_HP = 1
TARGET_MOST_AP = 2
TARGET_MOST_AD = 3
TARGET_LESS_CAST = 4
TARGET_NEAR_MOUSE = 5
TARGET_PRIORITY = 6
TARGET_LOW_HP_PRIORITY = 7
TARGET_LESS_CAST_PRIORITY = 8

-- Class related global
_enemyHeros = {}
_TargetSelector__texted = {"LowHP", "MostAP", "MostAD", "LessCast", "NearMouse", "Priority", "LowHPPriority", "LessCastPriority"}

-- Class related function
function _enemyHeros__init()
	if #_enemyHeros == 0 then
		for i = 1, heroManager.iCount do
			local hero = heroManager:getHero(i)
			if hero ~= nil and hero.team ~= player.team then
				table.insert(_enemyHeros, {hero = hero, index = i})
			end
		end
	end	
end

function _enemyHeros__hero(target, assertText)
	local selected
	if type(target) == "string" then
		for index,enemyHero in ipairs(_enemyHeros) do
			if enemyHero.hero.charName == target then
				selected = enemyHero.hero
			end
		end
	elseif type(target) == "number" then
		selected = heroManager:getHero(target)
	elseif target == nil then
		selected = GetTarget()
	else
		assert(type(target.networkID) == "number", assertText)
		selected = target
	end
	return selected
end

function _enemyHeros__index(target, assertText)
	local selected
	if target == nil then target = GetTarget() end
	if type(target) == "string" then
		for index,enemyHero in ipairs(_enemyHeros) do
			if enemyHero.hero.charName == target then
				selected = index
				break
			end
		end
	elseif type(target) == "number" then
		selected = target
	elseif target ~= nil then
		assert(type(target.networkID) == "number", assertText)
		for index,enemyHero in ipairs(_enemyHeros) do
			if enemyHero.hero.networkID == target.networkID then
				selected = index
				break
			end
		end 
	end
	return selected
end

function TargetSelectorPriority()
	for i, target in ipairs(_enemyHeros) do
        if target.hero ~= nil then
            PrintChat("[TS] Enemy " .. target.index .. ": " .. target.hero.charName .. " Mode=" .. (target.ignore and "ignore" or "target") .." Priority=" .. target.priority)
        end
    end
end

function TargetSelectorSetFocus(target)
	local selected = _enemyHeros__hero(target, "TargetSelectorSetFocus: wrong argument types (<charName> or <heroIndex> or <hero> or nil expected)")
	if selected ~= nil and selected.type == "obj_AI_Hero" and selected.team ~= player.team then
		for index,enemyHero in ipairs(_enemyHeros) do
			if enemyHero.hero.networkID == selected.networkID then
				enemyHero.priority = 1
				PrintChat("[TS] Focusing " .. enemyHero.hero.charName)
			else
				enemyHero.priority = #_enemyHeros
			end
		end
	end
end

function TargetSelectorSetHeroPriority(priority, target)
	assert(type(priority) == "number" and priority >= 0 and priority <= #_enemyHeros, "TargetSelectorSetHeroPriority: wrong argument types (<number> 1 to "..#_enemyHeros.." expected)")
	local selected = _enemyHeros__hero(target, "TargetSelectorSetHeroPriority: wrong argument types (<number>, <charName> or <heroIndex> or <hero> or nil expected)")
	if selected ~= nil and selected.type == "obj_AI_Hero" and selected.team ~= player.team then
		local oldPriority
		for index,enemyHero in ipairs(_enemyHeros) do
			if enemyHero.hero.networkID == ignore.networkID then
				local oldPriority = enemyHero.priority
				break
			end
		end
		if oldPriority == nil or oldPriority == priority then return end
		local priorityMove = (oldPriority > priority and 1 or -1)
		for index,enemyHero in ipairs(_enemyHeros) do
			if enemyHero.hero.networkID == ignore.networkID then
				enemyHero.priority = priority
			elseif oldPriority > priority and enemyHero.priority < oldPriority then
				enemyHero.priority = enemyHero.priority + 1
			elseif oldPriority < priority and enemyHero.priority > oldPriority then
				enemyHero.priority = enemyHero.priority - 1
			end
		end
	end
end

function TargetSelectorSetPriority(target1, target2, target3, target4, target5)
	assert((target5 ~= nil and #_enemyHeros == 5) or (target4 ~= nil and #_enemyHeros < 5) or (target3 ~= nil and #_enemyHeros == 3) or (target2 ~= nil and #_enemyHeros == 2) or (target1 ~= nil and #_enemyHeros == 1), "TargetSelectorSetPriority: wrong argument types (arg should fit the number of enemy hero)")
	TargetSelectorSetHeroPriority(1, target1)
	TargetSelectorSetHeroPriority(2, target2)
	TargetSelectorSetHeroPriority(3, target3)
	TargetSelectorSetHeroPriority(4, target4)
	TargetSelectorSetHeroPriority(5, target5)
end

function TargetSelectorIgnore(target)
	local selected = _enemyHeros__hero(target, "TargetSelectorSetFocus: wrong argument types (<charName> or <heroIndex> or <hero> or nil expected)")
	if selected ~= nil and selected.type == "obj_AI_Hero" and selected.team ~= player.team then
		for index,enemyHero in ipairs(_enemyHeros) do
			if enemyHero.hero.networkID == selected.networkID then
				enemyHero.ignore = not enemyHero.ignore
				PrintChat("[TS] "..(enemyHero.ignore and "Ignoring " or "Re-targetting ")..enemyHero.hero.charName)
				break
			end
		end
	end
end

-- just here for chat way
function TargetSelector__OnSendChat(msg)
    if msg:sub(1,1) ~= "." then return end
	local args = string.gmatch(msg, "%S+")
	local cmd = args[1]:lower()
	if cmd:sub(1,3) == ".ts" then
		BlockChat()
		for arg in args do
			if tonumber(arg) then arg = tonumber(arg) end
		end
		if cmd == ".tsprint" then
			TargetSelectorPriority()
		elseif cmd == ".tsfocus" then
			TargetSelectorSetFocus(args[2])
		elseif cmd == ".tspriorityhero" then
			TargetSelectorSetHeroPriority(args[2], args[3])
		elseif cmd == ".tspriority" then
			TargetSelectorSetPriority(args[2], args[3], args[4], args[5], args[6])
		elseif cmd == ".tsignore" then
			TargetSelectorIgnore(args[2])
		end
    end
end

class 'TargetSelector'
function TargetSelector:__init(mode, range, targetSelected, magicDmgBase, physicalDmgBase, trueDmg)
	-- Init Global
	assert(type(mode) == "number" and type(range) == "number", "TargetSelector: wrong argument types (<mode>, <number> expected)")
	_enemyHeros__init()
	for index,_enemyHero in ipairs(_enemyHeros) do
		_enemyHero.ignore, _enemyHero.priority = false, 1
	end
	self.mode = mode
	self.range = range
	self.targetSelected = (targetSelected == false and false or true)
	self.magicDmgBase = magicDmgBase or 0
	self.physicalDmgBase = physicalDmgBase or 0
	self.trueDmg = trueDmg or 0
	self.target = nil
	function self.conditional(thisTarget) return true end
	-- set default to magic 100 if none is set
	if self.magicDmgBase == 0 and self.physicalDmgBase == 0 and self.trueDmg == 0 then self.magicDmgBase = 100 end
end

function TargetSelector:printMode()
    PrintChat("[TS] Target mode: " .._TargetSelector__texted[self.mode])
end

function TargetSelector:targetSelectedByPlayer()
	if self.targetSelected then
		local currentTarget = GetTarget()
		if ValidTarget(currentTarget, 2000) and self.conditional(currentTarget) then
			self.target = currentTarget
			return true
		end
	end
	return false
end

function TargetSelector:updateTarget()
    -- Resets the target if player died
    if player.dead then
        self.target = nil
		return
	end
	-- Get current selected target (by player) if needed
    if self:targetSelectedByPlayer() then return end
	local selected, value
	local range = (self.mode == TARGET_NEAR_MOUSE and 2000 or self.range)
    for i, _enemyHero in ipairs(_enemyHeros) do
        local hero = _enemyHero.hero
        if ValidTarget(hero, range) and not _enemyHero.ignore and self.conditional(hero) then
			if self.mode == TARGET_LOW_HP or self.mode == TARGET_LOW_HP_PRIORITY or self.mode == TARGET_LESS_CAST or self.mode == TARGET_LESS_CAST_PRIORITY then
			-- Returns lowest effective HP target that is in range
			-- Or lowest cast to kill target that is in range
				local magicDmg = (self.magicDmgBase > 0 and player:CalcMagicDamage(hero, self.magicDmgBase) or 0)
				local physicalDmg = (self.physicalDmgBase > 0 and player:CalcDamage(hero, self.physicalDmgBase) or 0)
				local totalDmg = magicDmg + physicalDmg + self.trueDmg
				-- priority mode
				if self.mode == TARGET_LOW_HP_PRIORITY or self.mode == TARGET_LESS_CAST_PRIORITY then
					totalDmg = totalDmg / _enemyHero.priority
				end
				local heroValue
				if self.mode == TARGET_LOW_HP or self.mode == TARGET_LOW_HP_PRIORITY then
					heroValue = hero.health - totalDmg
				else
					heroValue = hero.health / totalDmg
				end
				if not selected or heroValue < value then
					selected = hero
					value = heroValue
				end
			elseif self.mode == TARGET_MOST_AP then
			-- Returns target that has highest AP that is in range
				if not selected or hero.ap > selected.ap then selected = hero end
			elseif self.mode == TARGET_MOST_AD then
			-- Returns target that has highest AD that is in range
				if not selected or hero.totalDamage > selected.totalDamage then selected = hero end
			elseif self.mode == TARGET_PRIORITY then
			-- Returns target with highest priority # that is in range
				if not selected or _enemyHero.priority < value then
					selected = hero
					value = _enemyHero.priority
				end
			elseif self.mode == TARGET_NEAR_MOUSE then
			-- Returns target that is the closest to the mouse cursor.
				local distance = GetDistance(mousePos, hero)
				if not selected or distance < value then
					selected = hero
					value = distance
				end
			end
        end
    end
    self.target = selected
end


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- GetMinionCollision
--[[
	Goblal Function :
	GetMinionCollision(posEnd, spellWidth)			-> return true/false if collision with minion from player to posEnd with spellWidth.
	
]]
function GetMinionCollision(posEnd, spellWidth)
	assert(VectorType(posEnd) and type(spellWidth) == "number", "GetMinionCollision: wrong argument types (<Vector>, <number> expected)")
	for i = 0, objManager.maxObjects, 1 do
		local minion = objManager:getObject(i)
		if minion and minion.ms == 325 and minion.team ~= player.team and not minion.dead and minion.visible and string.find(minion.name, "Minion_") then
			if GetDistance(minion) < distance then
				local closestPoint = VectorIntersectionFromPoint(player, posEnd, minion)
				if GetDistance(closestPoint, minion) <= spellWidth / 2 then return true end
			end
		end
	end
	return false
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TargetPrediction Class
--[[
Globals Functions
TargetPrediction__OnTick()			-- OnTick()

Methods:
tp = TargetPrediction(range, proj_speed, delay, widthCollision, smoothness)

Functions :
tp:GetPrediction(target)			-- return nextPosition, minionCollision, nextHealth

members :
tp.nextPosition						-- vector pos
tp.minions
tp.nextHealth
tp.range
tp.proj_speed
tp.delay
tp.width
tp.smoothness
]]

-- use _enemyHeros with TargetSelector
_TargetPrediction__tick = 0

-- should be place on OnTick()
function TargetPrediction__OnTick()
    local osTime = os.clock()
    if osTime - _TargetPrediction__tick > 0.35 then
        _TargetPrediction__tick = osTime
		for i, _enemyHero in ipairs(_enemyHeros) do
			local hero = _enemyHero.hero
			if hero.dead then
				_enemyHero.prediction = nil
			elseif hero.visible then
				if _enemyHero.prediction then
					local deltaTime = osTime - _enemyHero.prediction.lastUpdate
					_enemyHero.prediction.movement = (Vector(hero) - _enemyHero.prediction.position) / deltaTime
					_enemyHero.prediction.healthDifference = (hero.health - _enemyHero.prediction.health) / deltaTime
					_enemyHero.prediction.health = hero.health
					_enemyHero.prediction.position = Vector(hero)
					_enemyHero.prediction.lastUpdate = osTime
				else
					_enemyHero.prediction = { position = Vector(hero), lastUpdate = osTime, minions = false, health = hero.health }
				end
			end
        end
    end
end

class 'TargetPrediction'

function TargetPrediction:__init(range, proj_speed, delay, widthCollision, smoothness)
	assert(type(range) == "number", "TargetPrediction: wrong argument types (<number> expected for range)")
	_enemyHeros__init()
	self.range = range
	self.proj_speed = proj_speed and proj_speed * 1000
	self.delay = delay and delay / 1000 or 0
	self.width = widthCollision
	self.smoothness = smoothness
end

function TargetPrediction:GetPrediction(target)
    assert(target ~= nil, "GetPrediction: wrong argument types (<target> expected)")
	local index = _enemyHeros__index(target, "GetPrediction: wrong argument types (<charName> or <heroIndex> or <hero> expected)")
	if not index then return end
	local selected = _enemyHeros[index].hero
    if _enemyHeros[index].prediction and _enemyHeros[index].prediction.movement then
		if index ~= self.target then
			self.nextPosition = nil
			self.target = index
			self.calculateTime = 0
		end
		local osTime = os.clock()
		local proj_speed = proj_speed and proj_speed * 1000
        local delay = delay and delay / 1000 or 0
        if player:GetDistance(selected) < self.range + 300 then
            if osTime - (_enemyHeros[index].prediction.calculateTime or 0) > 0 then
                _enemyHeros[index].prediction.calculateTime = osTime
                local latency = GetLatency() / 1000
				latency = latency or 0
                local PositionPrediction
                if selected.visible then
					PositionPrediction = (_enemyHeros[index].prediction.movement * (delay + latency)) + selected
                elseif osTime - _enemyHeros[index].prediction.lastUpdate < 3 then
					PositionPrediction = (_enemyHeros[index].prediction.movement * (delay + latency + osTime - _enemyHeros[index].prediction.lastUpdate)) + _enemyHeros[index].prediction.position
                else _enemyHeros[index].prediction = nil return
                end
				local t = 0
				if proj_speed and proj_speed > 0 then
					local a, b, c = PositionPrediction, _enemyHeros[index].prediction.movement, Vector(player)
                    local d, e, f, g, h, i, j, k, l = (-a.x + c.x), (-a.z + c.z), b.x * b.x, b.z * b.z, proj_speed * proj_speed, a.x * a.x, a.z * a.z, c.x * c.x, c.z * c.z
                    local t = (-(math.sqrt(-f * (l - 2 * c.z * a.z + j) + 2 * b.x * b.z * d * e - g * (k - 2 * c.x * a.x + i) + (k - 2 * c.x * a.x + l - 2 * c.z * a.z + i + j) * h) - b.x * d - b.z * e)) / (f + g - h)
					PositionPrediction = (_enemyHeros[index].prediction.movement * t) + PositionPrediction
                end
                if smoothness and smoothness < 100 and self.nextPosition then
                    self.nextPosition = (PositionPrediction * ((100 - smoothness) / 100)) + (self.nextPosition * (smoothness / 100))
                else
                    self.nextPosition = PositionPrediction:clone()
                end
                if PositionPrediction:dist(player) < self.range then
					--update next Health
                    self.nextHealth = selected.health + (_enemyHeros[index].prediction.healthDifference or selected.health) * (t + delay + latency)
                    --update minions collision
					self.minions = false
					if width then
						self.minions = GetMinionCollision(PositionPrediction, width)
                    end
                else return
                end
            end
            return self.nextPosition, self.minions, self.nextHealth
        end
    end
end


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- MAP
--[[
Goblal Function :
GetMap()			-> return map

Members :
	map.index = 1-4 (0 mean not found)
	map.name -> return the full map name
	map.shortName -> return the shorted map name (usefull for using it in table)
	map.min {x, y} -> return min map x, y
	map.max{x, y} -> return max map x, y
	map{x, y} -> return map size x, y
]]

_gameMap = {index = 0, name = "unknown", shortName = "unknown", min = {x = 0, y = 0}, max = {x = 0, y = 0}, x = 0, y = 0}
function GetMap()
	if _gameMap.index == 0 then
		for i = 1, objManager.maxObjects do
			local object = objManager:getObject(i)
			if object ~= nil then
				if object.type == "obj_Shop" and object.team == TEAM_BLUE then
					if math.floor(object.x) == -175 and math.floor(object.y) == 163 and math.floor(object.z) == 1056 then
						_gameMap = {index = 1, name = "Summoner's Rift", shortName = "summonerRift", min = {x = -538, y = -165}, max = {x = 14279, y = 14527}, x = 14817, y = 14692}
						break
					elseif math.floor(object.x) == -217 and math.floor(object.y) == 276 and math.floor(object.z) == 7039 then
						_gameMap = {index = 2, name = "The Twisted Treeline", shortName = "twistedTreeline", min = {x = -996, y = -1239}, max = {x = 14120, y = 13877}, x = 15116, y = 15116}
						break
					elseif math.floor(object.x) == 556 and math.floor(object.y) == 191 and math.floor(object.z) == 1887 then
						_gameMap = {index = 3, name = "The Proving Grounds", shortName = "provingGrounds", min = {x = -56, y = -38}, max = {x = 12820, y = 12839}, x = 12876, y = 12877}
						break
					elseif math.floor(object.x) == 16 and math.floor(object.y) == 168 and math.floor(object.z) == 4452 then
						_gameMap = {index = 4, name = "The Crystal Scar", shortName = "crystalScar", min = {x = -15, y = 0}, max = {x = 13911, y = 13703}, x = 13926, y = 13703}
						break
					end
				end
			end
		end
	end
	return _gameMap
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- GameState Class
--[[
GameState Class :
Methods:
gameState = GameState()				--return a gameState instance

Functions :
gameState:gameIsOver()				-- update the gameIsOver state

Members:
gameState.winner			-> TEAM_BLUE / TEAM_RED winner
gameState.looser 			-> TEAM_BLUE / TEAM_RED looser

Usage :
ex :
function OnLoad()
	gameState = GameState()
end

function OnTick()
	if gameState:gameIsOver() then
		if gameState.winner == player.team then PrintChat("you are the best !") end
		return
	end
end

]]

_gameState = {objects = {}, isOver = false, needCheck = false, nextUpdate = 0, tickUpdate = 500}

class 'GameState'

function GameState:gameIsOver()
	if _gameState.needCheck then
		local tick = GetTickCount()
		if _gameState.nextUpdate > tick then return end
		_gameState.nextUpdate = tick + _gameState.tickUpdate
		for i, objectCheck in pairs(_gameState.objects) do
			if objectCheck.object == nil or objectCheck.object.dead or objectCheck.object.health == 0 then
				_gameState.isOver = true
				_gameState.looser = objectCheck.team
				_gameState.winner = (objectCheck.team == TEAM_BLUE and TEAM_RED or TEAM_BLUE)
				_gameState.needCheck = false
				break
			end
		end
	end
	if _gameState.isOver and self.looser == 0 and self.winner == 0 then
		self.looser = _gameState.looser
		self.winner = _gameState.winner
	end
	return _gameState.isOver
end

function GameState:__init()
	if (# _gameState.objects == 0) then
		map = GetMap()
		if (map.index == 1 or map.index == 2 or map.index == 3) then
			for i = 1, objManager.maxObjects, 1 do
				local object = objManager:getObject(i)
				if object ~= nil and object.type == "obj_HQ" then 
					table.insert(_gameState.objects, { object = object, team = object.team })
				end
			end
			_gameState.needCheck = (# _gameState.objects > 0)
		end
	end
	self.looser = 0
	self.winner = 0
end


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Start Saved Values
--[[
Goblal Function :
GetStart()			-> return start

Members :
	start.tick			-- return saved GetTickCount() at start
	start.osTime		-- return saved os.time at start
	start.WINDOW_W		-- return saved WINDOW_W
	start.WINDOW_H		-- return saved WINDOW_H
]]

_gameStart = {configFile = LIB_PATH.."start.cfg", init = true}

function GetStart()
	if _gameStart.init then
		-- init values
		_gameStart.WINDOW_W = tonumber(WINDOW_W ~= nil and WINDOW_W or 0)
		_gameStart.WINDOW_H = tonumber(WINDOW_H ~= nil and WINDOW_H or 0)
		_gameStart.tick = tonumber(GetTickCount())
		_gameStart.osTime = os.time(t)
		_gameStart.save = {}
		if file_exists(_gameStart.configFile) then dofile(_gameStart.configFile) end
		local gameStarted = false
		for i = 1, objManager.maxObjects, 1 do
			local object = objManager:getObject(i)
			if object ~= nil and object.type == "obj_AI_Minion" and string.find(object.name,"Minion_T") then 
				gameStarted = true
				break
			end
		end
		if _gameStart.save.osTime ~= nil and (_gameStart.save.osTime > (_gameStart.osTime - 120) or gameStarted) then
			_gameStart.WINDOW_W = _gameStart.save.WINDOW_W
			_gameStart.WINDOW_H = _gameStart.save.WINDOW_H
			_gameStart.tick = _gameStart.save.tick
			_gameStart.osTime = _gameStart.save.osTime
		else
			local file = io.open(_gameStart.configFile, "w")
			if file then
				file:write("_gameStart.save.osTime = ".._gameStart.osTime.."\n")
				file:write("_gameStart.save.WINDOW_W = ".._gameStart.WINDOW_W.."\n")
				file:write("_gameStart.save.WINDOW_H = ".._gameStart.WINDOW_H.."\n")
				file:write("_gameStart.save.tick = ".._gameStart.tick.."\n")
				file:close()
			end
			file = nil
		end
		--clean
		_gameStart.save = nil
		_gameStart.configFile = nil
		_gameStart.init = nil
	end
	return _gameStart
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--minionManager
--[[
Goblal Functions :
minionManager__OnCreateObj(object)			-- OnCreateObj
minionManager__OnDeleteObj(object)			-- OnDeleteObj
minionManager__OnLoad()						-- onLoad()

minionManager Class :

Methods:
minionArray = minionManager(mode, range, fromPos, sortMode)		--return a minionArray instance

Functions :
minionArray:update()				-- update the minionArray instance

Members:
minionArray.objects					-- minionArray objects table
minionArray.iCount					-- minionArray objects count
minionArray.mode					-- minionArray instance mode (MINION_ALL, etc)
minionArray.range					-- minionArray instance range
minionArray.fromPos					-- minionArray instance x, z from wich the range is based (player by default)
minionArray.sortMode				-- minionArray instance sort mode (MINION_SORT_HEALTH_ASC, etc... or nil if no sorted)

Usage :
ex :
function OnLoad()
	enemyMinions = minionManager(MINION_ENEMY, 600, player, MINION_SORT_HEALTH_ASC)
	allyMinions = minionManager(MINION_ALLY, 300, player, MINION_SORT_HEALTH_DES)
end

function OnTick()
	allyMinions:update()
	enemyMinions:update()
	for index, minion in pairs(enemyMinions.objects) do
		-- what you want
	end
	-- ex changing range
	enemyMinions.range = 250
	enemyMinions:update()
end

function OnCreateObj()
	minionManager__OnCreateObj(object)
end

function OnDeleteObj()
	minionManager__OnDeleteObj(object)
end

]]

_minionTable = {{}, {}, {}, {}}
_minionManager = {init = true, ally = "##", enemy ="##"}
-- Class related constants
MINION_ALL = 1
MINION_ENEMY = 2
MINION_ALLY = 3
MINION_OTHER = 4
MINION_SORT_HEALTH_ASC = 1
MINION_SORT_HEALTH_DEC = 2
MINION_SORT_MAXHEALTH_ASC = 3
MINION_SORT_MAXHEALTH_DEC = 4

function minionManager__OnCreateObj(object)
	if object ~= nil and object.type == "obj_AI_Minion" and object.name ~= nil and not object.dead then
		local name = object.name
		for index, minionTable in pairs(_minionTable) do
			if minionTable[name] ~= nil then return end
		end
		_minionTable[MINION_ALL][name] = object
		if string.find(name,_minionManager.ally) then _minionTable[MINION_ALLY][name] = object
		elseif string.find(name,_minionManager.enemy) then _minionTable[MINION_ENEMY][name] = object
		else _minionTable[MINION_OTHER][name] = object
		end
	end
end

function minionManager__OnDeleteObj(object)
	if object ~= nil and object.type == "obj_AI_Minion" and object.name ~= nil then
		for index, minionTable in pairs(_minionTable) do
			if minionTable[object.name] ~= nil then minionTable[object.name] = nil end
		end
	end
end

function minionManager__OnLoad()
	if _minionManager.init then
		if GetMap().index ~= 4 then
			_minionManager.ally = "Minion_T"..player.team
			_minionManager.enemy = "Minion_T"..TEAM_ENEMY
		else
			_minionManager.ally = (player.team == TEAM_BLUE and "Blue" or "Red")
			_minionManager.enemy = (player.team == TEAM_BLUE and "Red" or "Blue")
		end
		for i = 1, objManager.maxObjects do
			local object = objManager:getObject(i)
			minionManager__OnCreateObj(object)
		end
		_minionManager.init = nil
	end
end

class 'minionManager'

function minionManager:__init(mode, range, fromPos, sortMode)
	assert(type(mode) == "number" and type(range) == "number", "minionManager: wrong argument types (<mode>, <number> expected)")
	minionManager__OnLoad()
	self.mode = mode
	self.range = range
	self.fromPos = fromPos or player
	self.sortMode = sortMode
	self.objects = {}
	self.iCount = 0
	self:update()
end

function minionManager:update()
	self.objects = {}
	for name,object in pairs(_minionTable[self.mode]) do
		if object ~= nil and object.dead == false and object.visible and GetDistance(self.fromPos,object) <= self.range then
			table.insert(self.objects, object)
		end
	end
	if self.sortMode ~= nil then
		if self.sortMode == MINION_SORT_HEALTH_ASC then
			table.sort(self.objects, function(a,b) return a.health<b.health end)
		elseif self.sortMode == MINION_SORT_HEALTH_DEC then
			table.sort(self.objects, function(a,b) return a.health>b.health end)
		elseif self.sortMode == MINION_SORT_MAXHEALTH_ASC then
			table.sort(self.objects, function(a,b) return a.maxHealth<b.maxHealth end)
		elseif self.sortMode == MINION_SORT_MAXHEALTH_DEC then
			table.sort(self.objects, function(a,b) return a.maxHealth>b.maxHealth end)
		end
	end
	self.iCount = # self.objects
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Inventory
--[[
Goblal Function :
CastItem(itemID) 					-- Cast item
CastItem(itemID, hero) 				-- Cast item on hero
CastItem(itemID, x, z) 				-- Cast item on pos x,z

GetInventorySlotItem(itemID)		-- return the slot or nil
GetInventoryHaveItem(itemID)		-- return true/false
GetInventorySlotIsEmpty(slot)		-- return true/false
GetInventoryItemIsCastable(itemID)	-- return true/false
]]

function GetInventorySlotItem(itemID)
	assert(type(itemID) == "number", "GetInventorySlotItem: wrong argument types (<number> expected)")
    for i,j in pairs({ITEM_1,ITEM_2,ITEM_3,ITEM_4,ITEM_5,ITEM_6}) do
        if player:getInventorySlot(j) == itemID then return j end
    end
	return nil
end

function GetInventoryHaveItem(itemID)
	assert(type(itemID) == "number", "GetInventoryHaveItem: wrong argument types (<number> expected)")
	return (GetInventorySlotItem(itemID) ~= nil)
end

function GetInventorySlotIsEmpty(slot)
    return (player:getInventorySlot(slot) == 0)
end

function GetInventoryItemIsCastable(itemID)
	assert(type(itemID) == "number", "GetInventoryItemIsCastable: wrong argument types (<number> expected)")
	local slot = GetInventorySlotItem(itemID)
	if slot == nil then return false end
	return (player:CanUseSpell(slot) == READY)
end

function CastItem(itemID, var1, var2)
	assert(type(itemID) == "number", "CastItem: wrong argument types (<number> expected)")
	local slot = GetInventorySlotItem(itemID)
	if slot == nil then return false end
	if (player:CanUseSpell(slot) == READY) then
		if (var2 ~= nil) then CastSpell(slot, var1, var2)
		elseif (var1 ~= nil) then CastSpell(slot, var1)
		else CastSpell(slot)
		end
		return true
	end
	return false
end
