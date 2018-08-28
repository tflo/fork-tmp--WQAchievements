local WQA = WQAchievements
local L = WQA.L

local newOrder
do
	local current = 0
	function newOrder()
		current = current + 1
		return current
	end
end

function WQA:UpdateOptions()
	------------------
	-- 	Options Table
	------------------
	WQA.options = {
		type = "group",
		childGroups = "tab",
		args = {
			general = {
				order = newOrder(),
				type = "group",
				childGroups = "tree",
				name = "General",
				args = {}
			},
			rewards = {
				order = newOrder(),
				type = "group",
				childGroups = "tree",
				name = "Rewards",
				args = {
					gear = {
						order = newOrder(),
						name = "Gear",
						type = "group",
						inline = true,
						args = {
							itemLevelUpgrade = {
								type = "toggle",
								name = "ItemLevel Upgrade",
								--width = "double",
								set = function(info, val)
									WQA.db.char.options.rewards.gear.itemLevelUpgrade = val
								end,
								descStyle = "inline",
							    get = function()
							    	return WQA.db.char.options.rewards.gear.itemLevelUpgrade
						    	end,
							    order = newOrder()
							},
							itemLevelUpgradeMin = {
								name = "minimum ItemLevel Upgrade",
								type = "input",
								order = newOrder(),
								--width = .6,
								set = function(info,val)
						   			WQA.db.char.options.rewards.gear.itemLevelUpgradeMin = tonumber(val)
						   		end,
						    	get = function() return tostring(WQA.db.char.options.rewards.gear.itemLevelUpgradeMin)  end
							},
							desc1 = { type = "description", fontSize = "small", name = " ", order = newOrder(), },
							PawnUpgrade = {
								type = "toggle",
								name = "% Upgrade (Pawn)",
								--width = "double",
								set = function(info, val)
									WQA.db.char.options.rewards.gear.PawnUpgrade = val
								end,
								descStyle = "inline",
							    get = function()
							    	return WQA.db.char.options.rewards.gear.PawnUpgrade
						    	end,
							    order = newOrder()
							},
							PawnUpgradeMin = {
								name = "minimum % Upgrade",
								type = "input",
								order = newOrder(),
								--width = .6,
								set = function(info,val)
						   			WQA.db.char.options.rewards.gear.PawnUpgradeMin = tonumber(val)
						   		end,
						    	get = function() return tostring(WQA.db.char.options.rewards.gear.PawnUpgradeMin)  end
							},
							desc2 = { type = "description", fontSize = "small", name = " ", order = newOrder(), },
							unknownAppearance = {
								type = "toggle",
								name = "Unknown appearance",
								--width = "double",
								set = function(info, val)
									WQA.db.char.options.rewards.gear.unknownAppearance = val
								end,
								descStyle = "inline",
							    get = function()
							    	return WQA.db.char.options.rewards.gear.unknownAppearance
						    	end,
							    order = newOrder()
							},
							unknownSource = {
								type = "toggle",
								name = "Unknown source",
								--width = "double",
								set = function(info, val)
									WQA.db.char.options.rewards.gear.unknownSource = val
								end,
								descStyle = "inline",
							    get = function()
							    	return WQA.db.char.options.rewards.gear.unknownSource
						    	end,
							    order = newOrder()
							},
						}
					},
				}
			},
			custom = {
				order = newOrder(),
				type = "group",
				childGroups = "tree",
				name = "Custom",
				args = {
					--Add WQ
					header1 = { type = "header", name = "Add a World Quest", order = newOrder(), },
					addWQ = {
						name = "WorldQuestID",
						--desc = "To add a worldquest, enter a unique name for the worldquest, and click Okay",
						type = "input",
						order = newOrder(),
						width = .6,
						set = function(info,val)
				   			WQA.data.custom.wqID = val
				   		end,
				    	get = function() return tostring(WQA.data.custom.wqID )  end
					},
					rewardID = {
						name = "Reward (optional)",
						desc = "Enter an achievementID or itemID",
						type = "input",
						width = .6,
						order = newOrder(),
						set = function(info,val)
				   			WQA.data.custom.rewardID = val
				   		end,
				    	get = function() return tostring(WQA.data.custom.rewardID )  end
					},
					rewardType = {
						name = "Reward type",
						order = newOrder(),
						type = "select",
						values = {item = "Item", achievement = "Achievement", none = "none"},
						width = .6,
						set = function(info,val)
				   			WQA.data.custom.rewardType = val
				   		end,
				    	get = function() return WQA.data.custom.rewardType end
					},
					button = {
						order = newOrder(),
						type = "execute",
						name = "Add",
						width = .3,
						func = function() WQA:CreateCustomQuest() end
					},
					--Configure
					header2 = { type = "header", name = "Configure custom World Quests", order = newOrder(), },
				}
			},
			options = {
				order = newOrder(),
				type = "group",
				name = "Options",
				args = {
					desc1 = { type = "description", fontSize = "medium", name = "Select where WQA is allowed to post", order = newOrder(), },
					chat = {
						type = "toggle",
						name = "Chat",
						width = "double",
						set = function(info, val)
							WQA.db.char.options.chat = val
						end,
						descStyle = "inline",
					    get = function()
					    	return WQA.db.char.options.chat
				    	end,
					    order = newOrder()
					},
					PopUp = {
						type = "toggle",
						name = "PopUp",
						width = "double",
						handler = WQA,
						set = function(info, val)
							WQA.db.char.options.PopUp = val
						end,
						descStyle = "inline",
					    get = function()
					    	return WQA.db.char.options.PopUp
				    	end,
					    order = newOrder()
					}
				}
			}
		},
	}

	for i = 1, 2 do
		local v = self.data[i]
		self.options.args.general.args[v.name] = {
			order = i,
			name = v.name,
			type = "group",
			inline = true,
			args = {
			}
		}
		self:CreateGroup(self.options.args.general.args[v.name].args, v, "achievements")
		self:CreateGroup(self.options.args.general.args[v.name].args, v, "mounts")
		self:CreateGroup(self.options.args.general.args[v.name].args, v, "pets")
		self:CreateGroup(self.options.args.general.args[v.name].args, v, "toys")
	end

	self:UpdateCustomQuests()
end

function WQA:ToggleSet(info, val)
	--print(info[#info-2],info[#info-1],info[#info])
	local expansion = info[#info-2]
	local category = info[#info-1]
	local option = info[#info]
	--if not WQA.db.char[expansion] then WQA.db.char[expansion] = {} end
	if not WQA.db.char[category] then WQA.db.char[category] = {} end
	if not val == true then
		WQA.db.char[category][option] = true
	else
		WQA.db.char[category][option] = nil
	end
end

function WQA:ToggleGet()
end

function WQA:CreateGroup(options, data, groupName)
	if data[groupName] then
		options[groupName] = {
			order = 1,
			name = L[groupName],
			type = "group",
			args = {
			}
		}
		local args = options[groupName].args
		local expansion = data.name
		local data = data[groupName]
		for _,object in pairs(data) do
			args[object.name] = {
				type = "toggle",
				name = object.name,
				width = "double",
				handler = WQA,
				set = "ToggleSet",
				descStyle = "inline",
			    get = function()
			    	if not WQA.db.char[groupName] then return true end
			    	if not WQA.db.char[groupName][object.name]  then return true end
			    	return false
		    	end,
			    order = newOrder()	
			}
			if object.itemID then
				args[object.name].name = select(2,GetItemInfo(object.itemID)) or object.name
			else
				args[object.name].name = GetAchievementLink(object.id) or object.name
			end
		end
	end
end

function WQA:CreateCustomQuest()
 	if not self.db.global.custom then self.db.global.custom = {} end
 	self.db.global.custom[tonumber(self.data.custom.wqID)] = {rewardID = tonumber(self.data.custom.rewardID), rewardType = self.data.custom.rewardType}
 	self:UpdateCustomQuests()
 end

function WQA:UpdateCustomQuests()
 	local data = self.db.global.custom
 	if type(data) ~= "table" then return false end
 	local args = self.options.args.custom.args
 	for id,object in pairs(data) do
		args[tostring(id)] = {
			type = "toggle",
			name = GetQuestLink(id) or tostring(id),
			width = "double",
			handler = WQA,
			set = "ToggleSet",
			descStyle = "inline",
		    get = function()
		    	if not WQA.db.char.custom then return true end
		    	if not WQA.db.char.custom[tostring(id)]  then return true end
		    	return false
	    	end,
		    order = newOrder(),
		    width = 1.2
		}
		args[id.."Reward"] = {
			name = "Reward (optional)",
			desc = "Enter an achievementID or itemID",
			type = "input",
			width = .6,
			order = newOrder(),
			set = function(info,val)
				self.db.global.custom[id].rewardID = tonumber(val)
			end,
			get = function() return
				tostring(self.db.global.custom[id].rewardID or "")
			end
		}
		args[id.."RewardType"] = {
			name = "Reward type",
			order = newOrder(),
			type = "select",
			values = {item = "Item", achievement = "Achievement", none = "none"},
			width = .6,
			set = function(info,val)
				self.db.global.custom[id].rewardType = val
			end,
			get = function() return self.db.global.custom[id].rewardType or nil end
		}
		args[id.."Delete"] = {
			order = newOrder(),
			type = "execute",
			name = "Delete",
			width = .5,
			func = function()
				args[tostring(id)] = nil
				args[id.."Reward"] = nil
				args[id.."RewardType"] = nil
				args[id.."Delete"] = nil
				args[id.."space"] = nil
				self.db.global.custom[id] = nil
				self:UpdateCustomQuests()
				GameTooltip:Hide()
			end
		}
		args[id.."space"] = {
			name =" ",
			width = .4,
			order = newOrder(),
			type = "description"
		}
	end
 end