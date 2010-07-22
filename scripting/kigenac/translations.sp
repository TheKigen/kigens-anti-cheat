/*
    Kigen's Anti-Cheat Translations Module
    Copyright (C) 2007-2010 CodingDirect LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#define TRANSLATIONS

// Defined Translations
#define KAC_LOADED "KAC_LOADED"
#define KAC_BANNED "KAC_BANNED"
#define KAC_GBANNED "KAC_GBANNED"
#define KAC_VACBANNED "KAC_VACBANNED"
#define KAC_KCMDSPAM "KAC_KCMDSPAM"
#define KAC_ADDCMDUSAGE "KAC_ADDCMDUSAGE"
#define KAC_ADDCMDSUCCESS "KAC_ADDCMDSUCCESS"
#define KAC_ADDCMDFAILURE "KAC_ADDCMDFAILURE"
#define KAC_REMCMDUSAGE "KAC_REMCMDUSAGE"
#define KAC_REMCMDSUCCESS "KAC_REMCMDSUCCESS"
#define KAC_REMCMDFAILURE "KAC_REMCMDFAILURE"
#define KAC_FAILEDTOREPLY "KAC_FAILEDTOREPLY"
#define KAC_FAILEDAUTH "KAC_FAILEDAUTH"
#define KAC_CLIENTCORRUPT "KAC_CLIENTCORRUPT"
#define KAC_REMOVEPLUGINS "KAC_REMOVEPLUGINS"
#define KAC_HASPLUGIN "KAC_HASPLUGIN"
#define KAC_MUTED "KAC_MUTED"
#define KAC_HASNOTEQUAL "KAC_HASNOTEQUAL"
#define KAC_SHOULDEQUAL "KAC_SHOULDEQUAL"
#define KAC_HASNOTGREATER "KAC_HASNOTGREATER"
#define KAC_SHOULDGREATER "KAC_SHOULDGREATER"
#define KAC_HASNOTLESS "KAC_HASNOTLESS"
#define KAC_SHOULDLESS "KAC_SHOULDLESS"
#define KAC_HASNOTBOUND "KAC_HASNOTBOUND"
#define KAC_SHOULDBOUND "KAC_SHOULDBOUND"
#define KAC_BANIP "KAC_BANIP"
#define KAC_ADDCVARUSAGE "KAC_ADDCVARUSAGE"
#define KAC_REMCVARUSAGE "KAC_REMCVARUSAGE"
#define KAC_REMCVARSUCCESS "KAC_REMCVARSUCCESS"
#define KAC_REMCVARFAILED "KAC_REMCVARFAILED"
#define KAC_ADDCVARBADNAME "KAC_ADDCVARBADNAME"
#define KAC_ADDCVARBADCOMP "KAC_ADDCVARBADCOMP"
#define KAC_ADDCVARBADACT "KAC_ADDCVARBADACT"
#define KAC_ADDCVARBADBOUND "KAC_ADDCVARBADBOUND"
#define KAC_ADDCVAREXISTS "KAC_ADDCVAREXISTS"
#define KAC_ADDCVARSUCCESS "KAC_ADDCVARSUCCESS"
#define KAC_ADDCVARFAILED "KAC_ADDCVARFAILED"
#define KAC_CHANGENAME "KAC_CHANGENAME"
#define KAC_CBANNED "KAC_CBANNED"
#define KAC_STATUSREPORT "KAC_STATUSREPORT"
#define KAC_ON "KAC_ON"
#define KAC_OFF "KAC_OFF"
#define KAC_DISABLED "KAC_DISABLED"
#define KAC_ERROR "KAC_ERROR"
#define KAC_NOREPORT "KAC_NOREPORT"
#define KAC_TRANSLATEMOD "KAC_TRANSLATEMOD"
#define KAC_RCONPREVENT "KAC_RCONPREVENT"
#define KAC_NETMOD "KAC_NETMOD"
#define KAC_UNABLETOCONTACT "KAC_UNABLETOCONTACT"
#define KAC_EYEMOD "KAC_EYEMOD"
#define KAC_ANTIWH "KAC_ANTIWH"
#define KAC_NOSDKHOOK "KAC_NOSDKHOOK"
#define KAC_CVARS "KAC_CVARS"
#define KAC_CMDMOD "KAC_CMDMOD"
#define KAC_CMDSPAM "KAC_CMDSPAM"
#define KAC_CLIENTMOD "KAC_CLIENTMOD"
#define KAC_CLIENTBALANCE "KAC_CLIENTBALANCE"
#define KAC_CLIENTANTIRESPAWN "KAC_CLIENTANTIRESPAWN"
#define KAC_CLIENTNAMEPROTECT "KAC_CLIENTNAMEPROTECT"
#define KAC_AUTOASSIGNED "KAC_AUTOASSIGNED"
#define KAC_SAYBLOCK "KAC_SAYBLOCK"
#define KAC_FORCEDREVAL "KAC_FORCEDREVAL"
#define KAC_CANNOTREVAL "KAC_CANNOTREVAL"

new Handle:g_hLanguages = INVALID_HANDLE;

Trans_OnPluginStart()
{
	new Handle:f_hTemp = INVALID_HANDLE;
	g_hLanguages = CreateTrie();

	// Load languages into the adt_trie.
	SetTrieValue(g_hLanguages, "en", any:CreateTrie());
//	SetTrieValue(g_hLanguages, "nl", any:CreateTrie());
	
	//- English -//
	if ( !GetTrieValue(g_hLanguages, "en", any:f_hTemp) || f_hTemp == INVALID_HANDLE )
		SetFailState("Unable to create language tree for English");
	
	// Load the phrases into Translations.
	SetTrieString(f_hTemp, KAC_LOADED, 		"Kigen's Anti-Cheat has been loaded successfully.");
	SetTrieString(f_hTemp, KAC_BANNED, 		"You have been banned for a cheating infraction");
	SetTrieString(f_hTemp, KAC_GBANNED, 		"You are banned from all Kigen's Anti-Cheat (KAC) protected servers.  See http://www.kigenac.com/ for more information");
	SetTrieString(f_hTemp, KAC_VACBANNED, 		"This Kigen's Anti-Cheat (KAC) protected server does not allow VALVe's Anti-Cheat (VAC) banned players");
	SetTrieString(f_hTemp, KAC_KCMDSPAM, 		"You have been kicked for command spamming");
	SetTrieString(f_hTemp, KAC_ADDCMDUSAGE, 	"Usage: kac_addcmd <command name> <ban (1 or 0)>");
	SetTrieString(f_hTemp, KAC_ADDCMDSUCCESS, 	"You have successfully added %s to the command block list.");
	SetTrieString(f_hTemp, KAC_ADDCMDFAILURE, 	"%s already exists in the command block list.");
	SetTrieString(f_hTemp, KAC_REMCMDUSAGE, 	"Usage: kac_removecmd <command name>");
	SetTrieString(f_hTemp, KAC_REMCMDSUCCESS, 	"You have successfully removed %s from the command block list.");
	SetTrieString(f_hTemp, KAC_REMCMDFAILURE, 	"%s is not in the command block list.");
	SetTrieString(f_hTemp, KAC_FAILEDTOREPLY, 	"Your client has failed to reply to a query in time.  Please reconnect or restart your game");
	SetTrieString(f_hTemp, KAC_FAILEDAUTH, 		"Your client has failed to authorize in time.  Please reconnect or restart your game");
	SetTrieString(f_hTemp, KAC_CLIENTCORRUPT, 	"Your client has become corrupted.  Please restart your game before reconnecting");
	SetTrieString(f_hTemp, KAC_REMOVEPLUGINS, 	"Please remove any third party plugins from your client before joining this server again");
	SetTrieString(f_hTemp, KAC_HASPLUGIN, 		"%N (%s) has a plugin running, returned %s.");
	SetTrieString(f_hTemp, KAC_MUTED, 		"%N has been muted by Kigen's Anti-Cheat.");
	SetTrieString(f_hTemp, KAC_HASNOTEQUAL, 	"%N (%s) returned a bad value on %s (value %s, should be %s).");
	SetTrieString(f_hTemp, KAC_SHOULDEQUAL,		"Your convar %s should equal %s but it was set to %s.  Please correct this before rejoining");
	SetTrieString(f_hTemp, KAC_HASNOTGREATER,	"%N (%s) has convar %s set to %s when it should be greater than or equal to %s.");
	SetTrieString(f_hTemp, KAC_SHOULDGREATER, 	"Your convar %s should be greater than or equal to %s but was set to %s.  Please correct this before rejoining");
	SetTrieString(f_hTemp, KAC_HASNOTLESS,		"%N (%s) has convar %s set to %s when it should be less than or equal to %s.");
	SetTrieString(f_hTemp, KAC_SHOULDLESS, 		"Your convar %s should be less than or equal to %s but was set to %s.  Please correct this before rejoining");
	SetTrieString(f_hTemp, KAC_HASNOTBOUND,		"%N (%s) has convar %s set to %s when it should be beteween %s and %f.");
	SetTrieString(f_hTemp, KAC_SHOULDBOUND,		"Your convar %s should be between %s and %f but was set to %s.  Please correct this before rejoining");
	SetTrieString(f_hTemp, KAC_BANIP,		"You were banned by the server");
	SetTrieString(f_hTemp, KAC_ADDCVARUSAGE, 	"Usage: kac_addcvar <cvar name> <comparison type> <action> <value> <value2 if bound>");
	SetTrieString(f_hTemp, KAC_REMCVARUSAGE, 	"Usage: kac_removecvar <cvar name>");
	SetTrieString(f_hTemp, KAC_REMCVARSUCCESS, 	"ConVar %s was successfully removed from the check list.");
	SetTrieString(f_hTemp, KAC_REMCVARFAILED, 	"Unable to find ConVar %s in the check list.");
	SetTrieString(f_hTemp, KAC_ADDCVARBADNAME, 	"The ConVar name \"%s\" is invalid and cannot be used.");
	SetTrieString(f_hTemp, KAC_ADDCVARBADCOMP, 	"Unrecognized comparison type \"%s\", acceptable values: \"equal\", \"greater\", \"less\", \"between\", or \"strequal\".");
	SetTrieString(f_hTemp, KAC_ADDCVARBADACT, 	"Unrecognized action type \"%s\", acceptable values: \"warn\", \"mute\", \"kick\", or \"ban\".");
	SetTrieString(f_hTemp, KAC_ADDCVARBADBOUND, 	"Bound comparison type needs two values to compare with.");
	SetTrieString(f_hTemp, KAC_ADDCVAREXISTS, 	"The ConVar %s already exists in the check list.");
	SetTrieString(f_hTemp, KAC_ADDCVARSUCCESS, 	"Successfully added ConVar %s to the check list.");
	SetTrieString(f_hTemp, KAC_ADDCVARFAILED, 	"Failed to add ConVar %s to the check list.");
	SetTrieString(f_hTemp, KAC_CHANGENAME, 		"Please change your name");
	SetTrieString(f_hTemp, KAC_CBANNED, 		"You have been banned for a command usage violation");
	SetTrieString(f_hTemp, KAC_STATUSREPORT, 	"Kigen's Anti-Cheat Status Report");
	SetTrieString(f_hTemp, KAC_ON,			"On");
	SetTrieString(f_hTemp, KAC_OFF, 		"Off");
	SetTrieString(f_hTemp, KAC_DISABLED, 		"Disabled");
	SetTrieString(f_hTemp, KAC_ERROR,		"Error");
	SetTrieString(f_hTemp, KAC_NOREPORT, 		"There is nothing to report.");
	SetTrieString(f_hTemp, KAC_TRANSLATEMOD, 	"Translations");
	SetTrieString(f_hTemp, KAC_RCONPREVENT, 	"RCON Crash Prevention");
	SetTrieString(f_hTemp, KAC_NETMOD, 		"Network");
	SetTrieString(f_hTemp, KAC_UNABLETOCONTACT, 	"Unable to contact the KAC Master");
	SetTrieString(f_hTemp, KAC_EYEMOD, 		"Eye Test");
	SetTrieString(f_hTemp, KAC_ANTIWH, 		"Anti-Wallhack");
	SetTrieString(f_hTemp, KAC_NOSDKHOOK, 		"Disabled; Unable to find SDKHooks.ext");
	SetTrieString(f_hTemp, KAC_CVARS, 		"CVars Detection");
	SetTrieString(f_hTemp, KAC_CMDMOD, 		"Command Protection");
	SetTrieString(f_hTemp, KAC_CMDSPAM, 		"Command Spam Protection");
	SetTrieString(f_hTemp, KAC_CLIENTMOD, 		"Client Module");
	SetTrieString(f_hTemp, KAC_CLIENTBALANCE, 	"Client Team Auto-Balance");
	SetTrieString(f_hTemp, KAC_CLIENTANTIRESPAWN, 	"Client Anti-Rejoin");
	SetTrieString(f_hTemp, KAC_CLIENTNAMEPROTECT, 	"Client Name Protection");
	SetTrieString(f_hTemp, KAC_AUTOASSIGNED, 	"[KAC] You have been Auto-Assigned to a team.");
	SetTrieString(f_hTemp, KAC_SAYBLOCK, 		"[KAC] Your say has been blocked due to a invalid character.");
	SetTrieString(f_hTemp, KAC_FORCEDREVAL, 	"[KAC] Forced revalidation on all connected players.");
	SetTrieString(f_hTemp, KAC_CANNOTREVAL, 	"[KAC] Cannot force revalidation until all player have already been validated.");

	//- Dutch -//
/*	if ( !GetTrieValue(g_hLanguages, "nl", any:f_hTemp) || f_hTemp == INVALID_HANDLE )
		SetFailState("Unable to create language tree for Dutch");

	// Load the phrases into Translations.
	SetTrieString(f_hTemp, KAC_LOADED, 		"Kigen's Anti-Cheat is succesvol geladen / opgestart.");
	SetTrieString(f_hTemp, KAC_BANNED, 		"U ben verbannen voor een schending van de regels met betrekking tot valsspelen");
	SetTrieString(f_hTemp, KAC_GBANNED, 		"You are banned from all Kigen's Anti-Cheat (KAC) protected servers.  See http://www.kigenac.com/ for more information");
	SetTrieString(f_hTemp, KAC_VACBANNED, 		"This Kigen's Anti-Cheat (KAC) protected server does not allow VALVe's Anti-Cheat (VAC) banned players");
	SetTrieString(f_hTemp, KAC_KCMDSPAM, 		"U ben verwijderd voor het herhalen van commando's");
*/

}

stock KAC_Translate(client, String:trans[], String:dest[], maxlen)
{
	if ( client )
		GetTrieString(g_hCLang[client], trans, dest, maxlen);
	else
		GetTrieString(g_hSLang, trans, dest, maxlen);
}

stock KAC_ReplyToCommand(client, const String:trans[], any:...)
{
	decl String:f_sBuffer[256], String:f_sFormat[256];
	if ( !client )
		GetTrieString(g_hSLang, trans, f_sFormat, sizeof(f_sFormat));
	else
		GetTrieString(g_hCLang[client], trans, f_sFormat, sizeof(f_sFormat));
	VFormat(f_sBuffer, sizeof(f_sBuffer), f_sFormat, 3);
	ReplyToCommand(client, "%s", f_sBuffer);
}

stock KAC_PrintToServer(const String:trans[], any:...)
{
	decl String:f_sBuffer[256], String:f_sFormat[256];
	GetTrieString(g_hSLang, trans, f_sFormat, sizeof(f_sFormat));
	VFormat(f_sBuffer, sizeof(f_sBuffer), f_sFormat, 2);
	PrintToServer("%s", f_sBuffer);
}

stock KAC_PrintToChat(client, const String:trans[], any:...)
{
	decl String:f_sBuffer[256], String:f_sFormat[256];
	GetTrieString(g_hCLang[client], trans, f_sFormat, sizeof(f_sFormat));
	VFormat(f_sBuffer, sizeof(f_sBuffer), f_sFormat, 3);
	PrintToChat(client, "%s", f_sBuffer);
}

stock KAC_PrintToChatAdmins(const String:trans[], any:...)
{
	decl String:f_sBuffer[256], String:f_sFormat[256];
	for(new i=1;i<=MaxClients;i++)
	{
		if ( g_bIsAdmin[i] )
		{
			GetTrieString(g_hCLang[i], trans, f_sFormat, sizeof(f_sFormat));
			VFormat(f_sBuffer, sizeof(f_sBuffer), f_sFormat, 2);
			PrintToChat(i, "%s", f_sBuffer);
		}
	}
}

stock KAC_PrintToChatAll(const String:trans[], any:...)
{
	decl String:f_sBuffer[256], String:f_sFormat[256];
	for(new i=1;i<=MaxClients;i++)
	{
		if ( g_bInGame[i] )
		{
			GetTrieString(g_hCLang[i], trans, f_sFormat, sizeof(f_sFormat));
			VFormat(f_sBuffer, sizeof(f_sBuffer), f_sFormat, 2);
			PrintToChat(i, "%s", f_sBuffer);
		}
	}
}

stock KAC_Kick(client, const String:trans[], any:...)
{
	decl String:f_sBuffer[256], String:f_sFormat[256];
	GetTrieString(g_hCLang[client], trans, f_sFormat, sizeof(f_sFormat));
	VFormat(f_sBuffer, sizeof(f_sBuffer), f_sFormat, 3);
	KickClient(client, "%s", f_sBuffer);
	OnClientDisconnect(client); // Do this since the client is no longer useful to us. - Kigen
}

stock KAC_Ban(client, time, const String:trans[], const String:format[], any:...)
{
	new String:f_sBuffer[256], String:f_sEReason[256];
	GetTrieString(g_hCLang[client], trans, f_sEReason, sizeof(f_sEReason));
	VFormat(f_sBuffer, sizeof(f_sBuffer), format, 5);
	if ( g_bSourceBans )
		SBBanPlayer(0, client, time, f_sBuffer);
	else
		BanClient(client, time, BANFLAG_AUTO, f_sBuffer, f_sEReason, "KAC");
	OnClientDisconnect(client); // Bashats!
}

//- EoF -//
