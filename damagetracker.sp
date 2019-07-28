#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <tf2_stocks>
#include <colors>
#include <freak_fortress_2>
#include <freak_fortress_2_subplugin>
#include <tf2items>
#define MB 4
#define ME 2048
public Plugin:myinfo = {
	name = "Freak Fortress 2: Static Damage Tracker",
	author = "Original byMasterOfTheXP, Updated by Frenzoid",
	version = "1.5",
};
/*
This plugin allows clients to type "!ff2dmg <number 1 to 8>" to enable the damage tracker.
If a client enables it, the top X damagers will always be printed to the top left of their screen.
You can personalize the colors and if you want it to be enabled by default for the players.
*/

new damageTracker[MAXPLAYERS + 1];
new Handle:damageHUD;

new Handle:g_hVarColorR;
new Handle:g_hVarColorG;
new Handle:g_hVarColorB;
new Handle:g_hVarColorA;
new Handle:g_hCvarEnabledDefault;

int g_bVarColorR;
int g_bVarColorG;
int g_bVarColorB;
int g_bVarColorA;
new bool:g_bCvarEnabledDefault;
new bool:enabled = true;

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	return APLRes_Success;
}

public OnPluginStart2()
{

	g_hVarColorR = CreateConVar("sm_dmgtrck_color_r", "255", "Damage Tracker's RGBA's R color: Default 255.", _, true, 0.0, true, 255.0);
	g_bVarColorR = GetConVarInt(g_hVarColorR);
	HookConVarChange(g_hVarColorR, OnConVarChange);

	g_hVarColorG = CreateConVar("sm_dmgtrck_color_g", "255", "Damage Tracker's RGBA's G color: Default 255.", _, true, 0.0, true, 255.0);
	g_bVarColorG = GetConVarInt(g_hVarColorG);
	HookConVarChange(g_hVarColorG, OnConVarChange);

	g_hVarColorB = CreateConVar("sm_dmgtrck_color_b", "255", "Damage Tracker's RGBA's B color: Default 255.", _, true, 0.0, true, 255.0);
	g_bVarColorB = GetConVarInt(g_hVarColorB);
	HookConVarChange(g_hVarColorB, OnConVarChange);

	g_hVarColorA = CreateConVar("sm_dmgtrck_color_a", "255", "Damage Tracker's RGBA's A transparency (opacity): Default 255.", _, true, 0.0, true, 255.0);
	g_bVarColorA = GetConVarInt(g_hVarColorA);
	HookConVarChange(g_hVarColorA, OnConVarChange);

	g_hCvarEnabledDefault = CreateConVar("sm_dmgtrck_def_enabled", "1", "Enable ff2 damage tracker by default: default value = true", _, true, 0.0, true, 1.0);
	g_bCvarEnabledDefault = GetConVarBool(g_hCvarEnabledDefault);
	HookConVarChange(g_hCvarEnabledDefault, OnConVarChange);
	
	HookEvent("player_spawn", OnPlayerSpawn);

	RegConsoleCmd("ff2dmg", Command_damagetracker, "ff2dmg - Enable/disable the damage tracker.");
	RegConsoleCmd("haledmg", Command_damagetracker, "haledmg - Enable/disable the damage tracker.");
	RegConsoleCmd("ff2dmgdebug", Command_debug, "ff2dmg - Enable/disable the damage tracker.");
	
	CreateTimer(0.1, Timer_Millisecond);
	damageHUD = CreateHudSynchronizer();
}

public Action:Timer_Millisecond(Handle:timer)
{
	CreateTimer(0.1, Timer_Millisecond);
	if (FF2_GetRoundState() != 1) 
		return Plugin_Continue;
	
	new highestDamage = 0;
	new highestDamageClient = -1;
	
	for (new z = 1; z <= GetMaxClients(); z++)
	{
		if (IsClientInGame(z) && FF2_GetClientDamage(z) > highestDamage)
		{
			highestDamage = FF2_GetClientDamage(z);
			highestDamageClient = z;
		}
	}

	new secondHighestDamage = 0;
	new secondHighestDamageClient = -1;

	for (new z = 1; z <= GetMaxClients(); z++)
	{
		if (IsClientInGame(z) && FF2_GetClientDamage(z) > secondHighestDamage && z != highestDamageClient)
		{
			secondHighestDamage = FF2_GetClientDamage(z);
			secondHighestDamageClient = z;
		}
	}

	new thirdHighestDamage = 0;
	new thirdHighestDamageClient = -1;
	
	for (new z = 1; z <= GetMaxClients(); z++)
	{
		if (IsClientInGame(z) && FF2_GetClientDamage(z) > thirdHighestDamage && z != highestDamageClient && z != secondHighestDamageClient)
		{
			thirdHighestDamage = FF2_GetClientDamage(z);
			thirdHighestDamageClient = z;
		}
	}

	new fourthHighestDamage = 0;
	new fourthHighestDamageClient = -1;

	for (new z = 1; z <= GetMaxClients(); z++)
	{
		if (IsClientInGame(z) && FF2_GetClientDamage(z) > fourthHighestDamage && z != highestDamageClient && z != secondHighestDamageClient && z != thirdHighestDamageClient)
		{
			fourthHighestDamage = FF2_GetClientDamage(z);
			fourthHighestDamageClient = z;
		}
	}

	new fifthHighestDamage = 0;
	new fifthHighestDamageClient = -1;

	for (new z = 1; z <= GetMaxClients(); z++)
	{
		if (IsClientInGame(z) && FF2_GetClientDamage(z) > fifthHighestDamage && z != highestDamageClient && z != secondHighestDamageClient && z != thirdHighestDamageClient && z != fourthHighestDamageClient)
		{
			fifthHighestDamage = FF2_GetClientDamage(z);
			fifthHighestDamageClient = z;
		}
	}

	new sixthHighestDamage = 0;
	new sixthHighestDamageClient = -1;

	for (new z = 1; z <= GetMaxClients(); z++)
	{
		if (IsClientInGame(z) && FF2_GetClientDamage(z) > sixthHighestDamage && z != highestDamageClient && z != secondHighestDamageClient && z != thirdHighestDamageClient && z != fourthHighestDamageClient && z != fifthHighestDamageClient)
		{
			sixthHighestDamage = FF2_GetClientDamage(z);
			sixthHighestDamageClient = z;
		}
	}

	new seventhHighestDamage = 0;
	new seventhHighestDamageClient = -1;

	for (new z = 1; z <= GetMaxClients(); z++)
	{
		if (IsClientInGame(z) && FF2_GetClientDamage(z) > seventhHighestDamage && z != highestDamageClient && z != secondHighestDamageClient && z != thirdHighestDamageClient && z != fourthHighestDamageClient && z != fifthHighestDamageClient && z != sixthHighestDamageClient)
		{
			seventhHighestDamage = FF2_GetClientDamage(z);
			seventhHighestDamageClient = z;
		}
	}

	new eigthHighestDamage = 0;
	new eigthHighestDamageClient = -1;

	for (new z = 1; z <= GetMaxClients(); z++)
	{
		if (IsClientInGame(z) && FF2_GetClientDamage(z) > eigthHighestDamage && z != highestDamageClient && z != secondHighestDamageClient && z != thirdHighestDamageClient && z != fourthHighestDamageClient && z != fifthHighestDamageClient && z != sixthHighestDamageClient && z != seventhHighestDamageClient)
		{
			eigthHighestDamage = FF2_GetClientDamage(z);
			eigthHighestDamageClient = z;
		}
	}

	for (new z = 1; z <= GetMaxClients(); z++)
	{
		if (IsClientInGame(z) && !IsFakeClient(z) && damageTracker[z] > 0)
		{
			new a_index = FF2_GetBossIndex(z);
			if (a_index == -1) // client is not Hale
			{
				new userIsWinner = false;

				if (z == highestDamageClient) userIsWinner = true;
				if (damageTracker[z] > 1 && z == secondHighestDamageClient) userIsWinner = true;
				if (damageTracker[z] > 2 && z == thirdHighestDamageClient) userIsWinner = true;
				if (damageTracker[z] > 3 && z == fourthHighestDamageClient) userIsWinner = true;
				if (damageTracker[z] > 4 && z == fifthHighestDamageClient) userIsWinner = true;
				if (damageTracker[z] > 5 && z == sixthHighestDamageClient) userIsWinner = true;
				if (damageTracker[z] > 6 && z == seventhHighestDamageClient) userIsWinner = true;
				if (damageTracker[z] > 7 && z == eigthHighestDamageClient) userIsWinner = true;

				SetHudTextParams(0.0, 0.0, 0.2, g_bVarColorR, g_bVarColorG, g_bVarColorB, g_bVarColorA);
				SetGlobalTransTarget(z);

				new String:first[64];
				new String:second[64];
				new String:third[64];
				new String:fourth[64];
				new String:fifth[64];
				new String:sixth[64];
				new String:seventh[64];
				new String:eigth[64];
				new String:user[64];

				if (highestDamageClient != -1) Format(first, 64, "[1] %N : %i\n", highestDamageClient, highestDamage);
				if (highestDamageClient == -1) Format(first, 64, "[1]\n", highestDamageClient, highestDamage);
				if (damageTracker[z] > 1 && secondHighestDamageClient != -1) Format(second, 64, "[2] %N : %i\n", secondHighestDamageClient, secondHighestDamage);
				if (damageTracker[z] > 1 && secondHighestDamageClient == -1) Format(second, 64, "[2]\n", secondHighestDamageClient, secondHighestDamage);
				if (damageTracker[z] > 2 && thirdHighestDamageClient != -1) Format(third, 64, "[3] %N : %i\n", thirdHighestDamageClient, thirdHighestDamage);
				if (damageTracker[z] > 2 && thirdHighestDamageClient == -1) Format(third, 64, "[3]\n", thirdHighestDamageClient, thirdHighestDamage);
				if (damageTracker[z] > 3 && fourthHighestDamageClient != -1) Format(fourth, 64, "[4] %N : %i\n", fourthHighestDamageClient, fourthHighestDamage);
				if (damageTracker[z] > 3 && fourthHighestDamageClient == -1) Format(fourth, 64, "[4]\n", fourthHighestDamageClient, fourthHighestDamage);
				if (damageTracker[z] > 4 && fifthHighestDamageClient != -1) Format(fifth, 64, "[5] %N : %i\n", fifthHighestDamageClient, fifthHighestDamage);
				if (damageTracker[z] > 4 && fifthHighestDamageClient == -1) Format(fifth, 64, "[5]\n", fifthHighestDamageClient, fifthHighestDamage);
				if (damageTracker[z] > 5 && sixthHighestDamageClient != -1) Format(sixth, 64, "[6] %N : %i\n", sixthHighestDamageClient, sixthHighestDamage);
				if (damageTracker[z] > 5 && sixthHighestDamageClient == -1) Format(sixth, 64, "[6]\n", sixthHighestDamageClient, sixthHighestDamage);
				if (damageTracker[z] > 6 && seventhHighestDamageClient != -1) Format(seventh, 64, "[7] %N : %i\n", seventhHighestDamageClient, seventhHighestDamage);
				if (damageTracker[z] > 6 && seventhHighestDamageClient == -1) Format(seventh, 64, "[7]\n", seventhHighestDamageClient, seventhHighestDamage);
				if (damageTracker[z] > 7 && eigthHighestDamageClient != -1) Format(eigth, 64, "[8] %N : %i\n", eigthHighestDamageClient, eigthHighestDamage);
				if (damageTracker[z] > 7 && eigthHighestDamageClient == -1) Format(eigth, 64, "[8]\n", eigthHighestDamageClient, eigthHighestDamage);
				if (userIsWinner) Format(user, 64, " ");
				if (!userIsWinner) Format(user, 64, "---------\n[  ] %N : %i", z, FF2_GetClientDamage(z));
				if (z == secondHighestDamageClient && !userIsWinner) Format(user, 64, "---------\n[2] %N : %i", z, FF2_GetClientDamage(z));
				if (z == thirdHighestDamageClient && !userIsWinner) Format(user, 64, "---------\n[3] %N : %i", z, FF2_GetClientDamage(z));
				if (z == fourthHighestDamageClient && !userIsWinner) Format(user, 64, "---------\n[4] %N : %i", z, FF2_GetClientDamage(z));
				if (z == fifthHighestDamageClient && !userIsWinner) Format(user, 64, "---------\n[5] %N : %i", z, FF2_GetClientDamage(z));
				if (z == sixthHighestDamageClient && !userIsWinner) Format(user, 64, "---------\n[6] %N : %i", z, FF2_GetClientDamage(z));
				if (z == seventhHighestDamageClient && !userIsWinner) Format(user, 64, "---------\n[7] %N : %i", z, FF2_GetClientDamage(z));
				if (z == eigthHighestDamageClient && !userIsWinner) Format(user, 64, "---------\n[8] %N : %i", z, FF2_GetClientDamage(z));

				ShowSyncHudText(z, damageHUD, "%s%s%s%s%s%s%s%s%s", first, second, third, fourth, fifth, sixth, seventh, eigth, user);
			}
		}
	}

	return Plugin_Continue;
}

public OnConVarChange(Handle:hConvar, const String:strOldValue[], const String:strNewValue[])
{
	if(hConvar == g_hVarColorR)
	{
			g_bVarColorR = GetConVarInt(g_hVarColorR);
	}

	if(hConvar == g_hVarColorG)
	{
			g_bVarColorG = GetConVarInt(g_hVarColorG);
	}

	if(hConvar == g_hVarColorB)
	{
			g_bVarColorB = GetConVarInt(g_hVarColorB);
	}

	if(hConvar == g_hVarColorA)
	{
			g_bVarColorA = GetConVarInt(g_hVarColorA);
	}

	if(hConvar == g_hCvarEnabledDefault)
	{
			g_bCvarEnabledDefault = GetConVarBool(g_hCvarEnabledDefault);
	}

}

public Action:Command_debug(client, args)
{
	if (args != 0) {
		new String:arg1[64];
		GetCmdArgString(arg1, sizeof(arg1));

		if(StrEqual(arg1,"showInitialStatus",false) && enabled == false)
			CPrintToChat(client, "{olive}[DMGTRCK]{default} INITIAL STATUS: {olive}LAUNCHED{default}.");

		if(StrEqual(arg1,"showInitialStatus",false) && enabled == true)
			CPrintToChat(client, "{olive}[DMGTRCK]{default} INITIAL STATUS: {olive}READY{default}.");


		if(StrEqual(arg1,"showActualStatus",false) && g_bCvarEnabledDefault == true) 
			CPrintToChat(client, "{olive}[DMGTRCK]{default} ACTUAL STATUS: {olive}ENABLED{default}.");

		if(StrEqual(arg1,"showActualStatus",false) && g_bCvarEnabledDefault == false) 
			CPrintToChat(client, "{olive}[DMGTRCK]{default} ACTUAL STATUS: {olive}DISABLED{default}.");

	}

}

public Action:Command_damagetracker(client, args)
{
	if (client == 0)
	{
		PrintToServer("[FF2] The damage tracker cannot be enabled by Console.");
		return Plugin_Continue;
	}

	if (args == 0)
	{
		new String:playersetting[3];
		if (damageTracker[client] == 0) playersetting = "Off";
		if (damageTracker[client] > 0) playersetting = "On";
		CPrintToChat(client, "{olive}[FF2]{default} The damage tracker is {olive}%s{default}.\n{olive}[FF2]{default} Change it by saying \"!ff2dmg on\" or \"!ff2dmg off\"!\n{olive}[FF2]{default} Or, specify a number (!ff2dmg <#>) for that many slots to track!", playersetting);
		return Plugin_Continue;
	}

	new String:arg1[64];
	new newval = 3;

	if (args != -1) {
		GetCmdArgString(arg1, sizeof(arg1));
	}
	
	if (args == -1) {
		arg1 = "on";
	}

	if (StrEqual(arg1,"off",false)){ damageTracker[client] = 0; enabled = false; }
	if (StrEqual(arg1,"on",false)) { damageTracker[client] = 3; enabled = true; }
	if (StrEqual(arg1,"0",false)) { damageTracker[client] = 0; enabled = false; }
	if (StrEqual(arg1,"of",false)) { damageTracker[client] = 0; enabled = false; }
	if (!StrEqual(arg1,"off",false) && !StrEqual(arg1,"on",false) && !StrEqual(arg1,"0",false) && !StrEqual(arg1,"of",false))
	{
		newval = StringToInt(arg1);
		new String:newsetting[3];
		if (newval > 8) newval = 8;
		if (newval != 0) damageTracker[client] = newval;
		if (newval != 0 && damageTracker[client] == 0) newsetting = "off";
		if (newval != 0 && damageTracker[client] > 0) newsetting = "on";
		CPrintToChat(client, "{olive}[FF2]{default} The damage tracker is now {lightgreen}%s{default}!", newsetting);
	}
	
	return Plugin_Continue;
}

public OnClientPutInServer(client)
{
	damageTracker[client] = 0;
}

public Action:FF2_OnAbility2(index, const String:plugin_name[], const String:ability_name[], action)
{
	return Plugin_Continue;
}

public OnPlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));	
	if (g_bCvarEnabledDefault == true && enabled == true) {
		Command_damagetracker(client, -1);
	}

}
