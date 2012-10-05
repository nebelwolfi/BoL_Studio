--[[
	Script: packetShow v0.1
	Author: SurfaceS
	
	Dev use only
	
	require common
]]

do
	local packetShow = {
		record = true,
		dump = {},
		packetNumber = 0,
		currentType = 0,
		display = {
			x = 300,
			y = 100,
			shiftY = 20,
			row = { shiftX = 0 },
			way = { shiftX = 30 },
			header = { shiftX = 60 },
			dwArg1 = { shiftX = 150 },
			dwArg2 = { shiftX = 170 },
			data = { shiftX = 200 },
		},
		recordHK = 45,		-- insert
		deleteHK = 46,		-- delete
		saveHK = 35, 		-- End
		maxRow = 30,		-- number of last packet to show
		dumpFile = LIB_PATH.."packetShow.csv",
		filterUse = true,
		filter = {43, 45, },
		packetHeaders = {
			[43] = {
				ID = "CameraPos R",
				dataDump = function (packet)
					local data = packet:Decode1()		-- header
					data = data.." "..packet:Decode4()	-- ?? see 45
					data = data.." "..packet:Decode1()	-- index
					return data
				end,
			},
			[45] = {
				ID = "CameraPos S",
				dump = function (packet)
					
					
				end,
				data = "",
				dataDump = function (packet)
					local data = packet:Decode1()		-- header
					data = data.." "..packet:Decode4()	-- ??
					data = data.." "..packet:DecodeF()	-- camera pos X
					data = data.." "..packet:DecodeF()	-- camera pos Y
					data = data.." "..packet:DecodeF()	-- camera pos Z
					data = data.." "..packet:DecodeF()	-- ??
					data = data.." "..packet:Decode1()	-- change only if change zoom from max
					data = data.." "..packet:Decode1()	--
					data = data.." "..packet:Decode1()	--
					data = data.." "..packet:Decode1()	--
					data = data.." "..packet:Decode1()	-- zoom ??
					data = data.." "..packet:Decode1()	--
					data = data.." "..packet:Decode1()	-- 
					data = data.." "..packet:Decode1()	-- 
					data = data.." "..packet:Decode4()  -- ?? see 43
					data = data.." "..packet:Decode1()	-- index
					return data
				end,
			},
		},
	}
	
	function packetShow.saveToFile()
		local file = io.open(packetShow.dumpFile, "w")
		if file then
			file:write("Row\tWay\tHeader\tdwArg1\tdwArg2\tDatas\n")
			for i,dumpRow in ipairs(packetShow.dump) do
				file:write(dumpRow.row.."\t"..dumpRow.way.."\t"..dumpRow.header.."\t"..dumpRow.dwArg1.."\t"..dumpRow.dwArg2.."\t"..dumpRow.data.."\n")
			end
			file:close()
		end
	end
	
	function packetShow.dumpPacket(packet, sent)
		packetShow.packetNumber = packetShow.packetNumber + 1
		local header = packet.header
		if packetShow.filterUse then
			local isFiltered = true
			for i,filterId in ipairs(packetShow.filter) do
				if header == filterId then
					isFiltered = false
					break
				end
			end
			if isFiltered then return end
		end
		local packetDump = {
			row = tostring(packetShow.packetNumber),
			way = (sent and "S" or "R"),
			wayColor = (sent and 0xFFFF0000 or 0xFF00FF00),
			header = (packetShow.packetHeaders[header] and packetShow.packetHeaders[header].ID or string.format(" %02X", packet.header)),
			dwArg1 = tostring(packet.dwArg1),
			dwArg2 = tostring(packet.dwArg2),
			data = "",
		}

		if packetShow.packetHeaders[header] and packetShow.packetHeaders[header].dataDump then
			packetDump.data = packetShow.packetHeaders[header].dataDump(packet)
		else
			for i = 1, packet.size do
				packetDump.data = packetDump.data..string.format(" %02X", packet:Decode1())
			end
		end
		table.insert(packetShow.dump,packetDump)
	end
	
	function OnDraw()
		local dumpRows = # packetShow.dump
		local dumpShowStart = math.max(1, dumpRows - packetShow.maxRow)
		for i = dumpShowStart, dumpRows do
			local textY = packetShow.display.y + (packetShow.display.shiftY * (i - dumpShowStart))
			DrawText(packetShow.dump[i].row, 12, packetShow.display.x + packetShow.display.row.shiftX, textY, 4294967295)
			DrawText(packetShow.dump[i].way, 12, packetShow.display.x + packetShow.display.way.shiftX, textY, packetShow.dump[i].wayColor)
			DrawText(packetShow.dump[i].header, 12, packetShow.display.x + packetShow.display.header.shiftX, textY, 4294967295)
			DrawText(packetShow.dump[i].dwArg1, 12, packetShow.display.x + packetShow.display.dwArg1.shiftX, textY, 4294967295)
			DrawText(packetShow.dump[i].dwArg2, 12, packetShow.display.x + packetShow.display.dwArg2.shiftX, textY, 4294967295)
			DrawText(packetShow.dump[i].data, 12, packetShow.display.x + packetShow.display.data.shiftX, textY, 4294967295)
		end
	end
	
	function OnRecvPacket(packet)
		if packetShow.record then packetShow.dumpPacket(packet, false) end
	end
	
	function OnSendPacket(packet)
		if packetShow.record then packetShow.dumpPacket(packet, true) end
	end

	function OnWndMsg(msg,wParam)
		if msg == KEY_DOWN then
			if wParam == packetShow.deleteHK then
				packetShow.dump = {}
				packetShow.packetNumber = 0
			elseif wParam == packetShow.recordHK then
				packetShow.record = not packetShow.record
			elseif wParam == packetShow.saveHK then
				packetShow.saveToFile()
			end
		end
	end
end
