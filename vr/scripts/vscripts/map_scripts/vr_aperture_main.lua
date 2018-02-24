------------ Copyright (c) Valve Corporation, All rights reserved. ------------
--
-- Controls the gameplay logic for map: vr_aperture_main
--
-------------------------------------------------------------------------------

AllTriggers = {}
ScriptLogicEntity = nil
ScriptLogicScope = nil
HasUpdateFunc = false

-----------------------------------------------------------
function VRAperturePrint( msg )
	print( "VR_APERTURE_MAIN: " .. msg )
end


-----------------------------------------------------------
function OnInit()
	VRAperturePrint( "OnInit()" )

	--Create the logic_script entity that controls the logic for the map
	ScriptLogicEntity = SpawnScriptEnt( "ApertureLogic", "vr_aperture_logic" )
	ScriptLogicScope = ScriptLogicEntity:GetPrivateScriptScope()

	VRAperturePrint( "Created script logic entity" )

	CallScriptLogicFunction( "OnInit" )

	if vlua.contains( ScriptLogicScope, "OnUpdate" ) then
		HasUpdateFunc = true
	end
end


-----------------------------------------------------------
function OnPrecache( context )
	VRAperturePrint( "OnPrecache()" )
	--PrecacheResource( "particle", "*.vpcf", context )
	--PrecacheResource( "soundfile", "*.vsnd", context )
	--PrecacheResource( "sound", "*.vsnd", context )
	--PrecacheResource( "particle_folder", "particles", context )
	CallScriptLogicFunction( "OnPrecache", context )
end


-----------------------------------------------------------
function OnActivate()
	VRAperturePrint( "OnActivate()" )

	CallScriptLogicFunction( "OnActivate" )
end


-----------------------------------------------------------
function OnGameplayStart()
	VRAperturePrint( "OnGameplayStart()" )

	CallScriptLogicFunction( "OnGameplayStart" )
end


-----------------------------------------------------------
function OnPlayerSpawned()
	VRAperturePrint( "OnPlayerSpawned()" )

	ScriptSystem_AddPerFrameUpdateFunction( OnUpdate )

	CallScriptLogicFunction( "OnPlayerSpawned" )
end


-----------------------------------------------------------
function OnHMDAvatarAndHandsSpawned()
	VRAperturePrint( "OnHMDAvatarAndHandsSpawned()" )

	CallScriptLogicFunction( "OnHMDAvatarAndHandsSpawned" )
end


-----------------------------------------------------------
function OnShutdown()
	VRAperturePrint( "OnShutdown()" )

	CallScriptLogicFunction( "OnShutdown" )
end


-----------------------------------------------------------
function OnUpdate()
	if VRAperturePrint == false then
		return
	end

	if HasUpdateFunc then
		CallScriptLogicFunction( "OnUpdate" )
	end
end


-----------------------------------------------------------
function SpawnScriptEnt( entName, scriptName, pos, ang )
	pos = pos or Vector(0, 0, 0)
	ang = ang or QAngle(0, 0, 0)
	local spawnTable = 
	{
		classname = "logic_script",
		targetname = entName,
		vscripts = scriptName,
		origin = pos,
		angles = ang
	}
	
	local spawnedEnt = SpawnEntityFromTableSynchronous( "logic_script", spawnTable )
	return spawnedEnt
end


-----------------------------------------------------------
function CallScriptLogicFunction( functionName, params )
	if vlua.contains( ScriptLogicScope, functionName ) then 
		if params == nil then 
			ScriptLogicScope[functionName]( ScriptLogicScope )
		else 
			ScriptLogicScope[functionName]( ScriptLogicScope, params )
		end
	else
		VRAperturePrint( "Logic ent doesn't contain function named: " .. functionName )
	end
end