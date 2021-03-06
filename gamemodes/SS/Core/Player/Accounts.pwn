#include <YSI\y_hooks>


#define ACCOUNTS_TABLE_PLAYER		"Player"
#define FIELD_PLAYER_NAME			"name"		// 00
#define FIELD_PLAYER_PASS			"pass"		// 01
#define FIELD_PLAYER_IPV4			"ipv4"		// 02
#define FIELD_PLAYER_ALIVE			"alive"		// 03
#define FIELD_PLAYER_KARMA			"karma"		// 04
#define FIELD_PLAYER_REGDATE		"regdate"	// 05
#define FIELD_PLAYER_LASTLOG		"lastlog"	// 06
#define FIELD_PLAYER_SPAWNTIME		"spawntime"	// 07
#define FIELD_PLAYER_TOTALSPAWNS	"spawns"	// 08
#define FIELD_PLAYER_WARNINGS		"warnings"	// 09
#define FIELD_PLAYER_AIMSHOUT		"aimshout"	// 10
#define FIELD_PLAYER_GPCI			"gpci"		// 11

enum
{
	FIELD_ID_PLAYER_NAME,
	FIELD_ID_PLAYER_PASS,
	FIELD_ID_PLAYER_IPV4,
	FIELD_ID_PLAYER_ALIVE,
	FIELD_ID_PLAYER_KARMA,
	FIELD_ID_PLAYER_REGDATE,
	FIELD_ID_PLAYER_LASTLOG,
	FIELD_ID_PLAYER_SPAWNTIME,
	FIELD_ID_PLAYER_TOTALSPAWNS,
	FIELD_ID_PLAYER_WARNINGS,
	FIELD_ID_PLAYER_AIMSHOUT,
	FIELD_ID_PLAYER_GPCI
}


static
				LoginPasswordAttempts[MAX_PLAYERS],
// ACCOUNTS_TABLE_PLAYER
DBStatement:	stmt_AccountExists,
DBStatement:	stmt_AccountCreate,
DBStatement:	stmt_AccountLoad,
DBStatement:	stmt_AccountUpdate,

DBStatement:	stmt_AccountGetPassword,
DBStatement:	stmt_AccountSetPassword,

DBStatement:	stmt_AccountGetIpv4,
DBStatement:	stmt_AccountSetIpv4,

DBStatement:	stmt_AccountGetAliveState,
DBStatement:	stmt_AccountSetAliveState,

DBStatement:	stmt_AccountGetKarma,
DBStatement:	stmt_AccountSetKarma,

DBStatement:	stmt_AccountGetRegdate,
DBStatement:	stmt_AccountSetRegdate,

DBStatement:	stmt_AccountGetLastLog,
DBStatement:	stmt_AccountSetLastLog,

DBStatement:	stmt_AccountGetSpawnTime,
DBStatement:	stmt_AccountSetSpawnTime,

DBStatement:	stmt_AccountGetTotalSpawns,
DBStatement:	stmt_AccountSetTotalSpawns,

DBStatement:	stmt_AccountGetWarnings,
DBStatement:	stmt_AccountSetWarnings,

DBStatement:	stmt_AccountGetAimShout,
DBStatement:	stmt_AccountSetAimShout,

DBStatement:	stmt_AccountGetGpci,
DBStatement:	stmt_AccountSetGpci,

DBStatement:	stmt_AccountGetAliasData;
	

hook OnGameModeInit()
{
	db_query(gAccounts, "CREATE TABLE IF NOT EXISTS "ACCOUNTS_TABLE_PLAYER" (\
		"FIELD_PLAYER_NAME" TEXT,\
		"FIELD_PLAYER_PASS" TEXT,\
		"FIELD_PLAYER_IPV4" INTEGER,\
		"FIELD_PLAYER_ALIVE" INTEGER,\
		"FIELD_PLAYER_KARMA" INTEGER,\
		"FIELD_PLAYER_REGDATE" INTEGER,\
		"FIELD_PLAYER_LASTLOG" INTEGER,\
		"FIELD_PLAYER_SPAWNTIME" INTEGER,\
		"FIELD_PLAYER_TOTALSPAWNS" INTEGER,\
		"FIELD_PLAYER_WARNINGS" INTEGER,\
		"FIELD_PLAYER_AIMSHOUT" TEXT,\
		"FIELD_PLAYER_GPCI" TEXT)");

	db_query(gAccounts, "CREATE INDEX IF NOT EXISTS "ACCOUNTS_TABLE_PLAYER"_index ON "ACCOUNTS_TABLE_PLAYER"("FIELD_PLAYER_NAME")");

	DatabaseTableCheck(gAccounts, ACCOUNTS_TABLE_PLAYER, 12);

	stmt_AccountExists			= db_prepare(gAccounts, "SELECT COUNT(*) FROM "ACCOUNTS_TABLE_PLAYER" WHERE "FIELD_PLAYER_NAME"=? COLLATE NOCASE");
	stmt_AccountCreate			= db_prepare(gAccounts, "INSERT INTO "ACCOUNTS_TABLE_PLAYER" VALUES(?,?,?,0,0,?,?,0,0,0,?,?)");
	stmt_AccountLoad			= db_prepare(gAccounts, "SELECT * FROM "ACCOUNTS_TABLE_PLAYER" WHERE "FIELD_PLAYER_NAME"=? COLLATE NOCASE");
	stmt_AccountUpdate			= db_prepare(gAccounts, "UPDATE "ACCOUNTS_TABLE_PLAYER" SET "FIELD_PLAYER_ALIVE"=?, "FIELD_PLAYER_KARMA"=?, "FIELD_PLAYER_WARNINGS"=? WHERE "FIELD_PLAYER_NAME"=? COLLATE NOCASE");

	stmt_AccountGetPassword		= db_prepare(gAccounts, "SELECT "FIELD_PLAYER_PASS" FROM "ACCOUNTS_TABLE_PLAYER" WHERE "FIELD_PLAYER_NAME"=? COLLATE NOCASE");
	stmt_AccountSetPassword		= db_prepare(gAccounts, "UPDATE "ACCOUNTS_TABLE_PLAYER" SET "FIELD_PLAYER_PASS"=? WHERE "FIELD_PLAYER_NAME"=? COLLATE NOCASE");

	stmt_AccountGetIpv4			= db_prepare(gAccounts, "SELECT "FIELD_PLAYER_IPV4" FROM "ACCOUNTS_TABLE_PLAYER" WHERE "FIELD_PLAYER_NAME"=? COLLATE NOCASE");
	stmt_AccountSetIpv4			= db_prepare(gAccounts, "UPDATE "ACCOUNTS_TABLE_PLAYER" SET "FIELD_PLAYER_IPV4"=? WHERE "FIELD_PLAYER_NAME"=? COLLATE NOCASE");

	stmt_AccountGetAliveState	= db_prepare(gAccounts, "SELECT "FIELD_PLAYER_ALIVE" FROM "ACCOUNTS_TABLE_PLAYER" WHERE "FIELD_PLAYER_NAME"=? COLLATE NOCASE");
	stmt_AccountSetAliveState	= db_prepare(gAccounts, "UPDATE "ACCOUNTS_TABLE_PLAYER" SET "FIELD_PLAYER_ALIVE"=? WHERE "FIELD_PLAYER_NAME"=? COLLATE NOCASE");

	stmt_AccountGetKarma		= db_prepare(gAccounts, "SELECT "FIELD_PLAYER_KARMA" FROM "ACCOUNTS_TABLE_PLAYER" WHERE "FIELD_PLAYER_NAME"=? COLLATE NOCASE");
	stmt_AccountSetKarma		= db_prepare(gAccounts, "UPDATE "ACCOUNTS_TABLE_PLAYER" SET "FIELD_PLAYER_KARMA"=? WHERE "FIELD_PLAYER_NAME"=? COLLATE NOCASE");

	stmt_AccountGetRegdate		= db_prepare(gAccounts, "SELECT "FIELD_PLAYER_REGDATE" FROM "ACCOUNTS_TABLE_PLAYER" WHERE "FIELD_PLAYER_NAME"=? COLLATE NOCASE");
	stmt_AccountSetRegdate		= db_prepare(gAccounts, "UPDATE "ACCOUNTS_TABLE_PLAYER" SET "FIELD_PLAYER_REGDATE"=? WHERE "FIELD_PLAYER_NAME"=? COLLATE NOCASE");

	stmt_AccountGetLastLog		= db_prepare(gAccounts, "SELECT "FIELD_PLAYER_LASTLOG" FROM "ACCOUNTS_TABLE_PLAYER" WHERE "FIELD_PLAYER_NAME"=? COLLATE NOCASE");
	stmt_AccountSetLastLog		= db_prepare(gAccounts, "UPDATE "ACCOUNTS_TABLE_PLAYER" SET "FIELD_PLAYER_LASTLOG"=? WHERE "FIELD_PLAYER_NAME"=? COLLATE NOCASE");

	stmt_AccountGetSpawnTime	= db_prepare(gAccounts, "SELECT "FIELD_PLAYER_SPAWNTIME" FROM "ACCOUNTS_TABLE_PLAYER" WHERE "FIELD_PLAYER_NAME"=? COLLATE NOCASE");
	stmt_AccountSetSpawnTime	= db_prepare(gAccounts, "UPDATE "ACCOUNTS_TABLE_PLAYER" SET "FIELD_PLAYER_SPAWNTIME"=? WHERE "FIELD_PLAYER_NAME"=? COLLATE NOCASE");

	stmt_AccountGetTotalSpawns	= db_prepare(gAccounts, "SELECT "FIELD_PLAYER_TOTALSPAWNS" FROM "ACCOUNTS_TABLE_PLAYER" WHERE "FIELD_PLAYER_NAME"=? COLLATE NOCASE");
	stmt_AccountSetTotalSpawns	= db_prepare(gAccounts, "UPDATE "ACCOUNTS_TABLE_PLAYER" SET "FIELD_PLAYER_TOTALSPAWNS"=? WHERE "FIELD_PLAYER_NAME"=? COLLATE NOCASE");

	stmt_AccountGetWarnings		= db_prepare(gAccounts, "SELECT "FIELD_PLAYER_WARNINGS" FROM "ACCOUNTS_TABLE_PLAYER" WHERE "FIELD_PLAYER_NAME"=? COLLATE NOCASE");
	stmt_AccountSetWarnings		= db_prepare(gAccounts, "UPDATE "ACCOUNTS_TABLE_PLAYER" SET "FIELD_PLAYER_WARNINGS"=? WHERE "FIELD_PLAYER_NAME"=? COLLATE NOCASE");

	stmt_AccountGetAimShout		= db_prepare(gAccounts, "SELECT "FIELD_PLAYER_AIMSHOUT" FROM "ACCOUNTS_TABLE_PLAYER" WHERE "FIELD_PLAYER_NAME"=? COLLATE NOCASE");
	stmt_AccountSetAimShout		= db_prepare(gAccounts, "UPDATE "ACCOUNTS_TABLE_PLAYER" SET "FIELD_PLAYER_AIMSHOUT"=? WHERE "FIELD_PLAYER_NAME"=? COLLATE NOCASE");

	stmt_AccountGetGpci			= db_prepare(gAccounts, "SELECT "FIELD_PLAYER_GPCI" FROM "ACCOUNTS_TABLE_PLAYER" WHERE "FIELD_PLAYER_NAME"=? COLLATE NOCASE");
	stmt_AccountSetGpci			= db_prepare(gAccounts, "UPDATE "ACCOUNTS_TABLE_PLAYER" SET "FIELD_PLAYER_GPCI"=? WHERE "FIELD_PLAYER_NAME"=? COLLATE NOCASE");

	stmt_AccountGetAliasData	= db_prepare(gAccounts, "SELECT "FIELD_PLAYER_IPV4", "FIELD_PLAYER_PASS", "FIELD_PLAYER_GPCI" FROM "ACCOUNTS_TABLE_PLAYER" WHERE "FIELD_PLAYER_NAME"=? COLLATE NOCASE");
}


/*==============================================================================

	Loads database data into memory and applies it to the player.

==============================================================================*/


LoadAccount(playerid)
{
	new
		name[MAX_PLAYER_NAME],
		exists,
		password[MAX_PASSWORD_LEN],
		ipv4,
		alive,
		regdate,
		lastlog,
		spawntime,
		spawns,
		warnings,
		aimshout[128];

	GetPlayerName(playerid, name, MAX_PLAYER_NAME);

	stmt_bind_value(stmt_AccountExists, 0, DB::TYPE_STRING, gPlayerName[playerid], MAX_PLAYER_NAME);
	stmt_bind_result_field(stmt_AccountExists, 0, DB::TYPE_INTEGER, exists);

	if(stmt_execute(stmt_AccountExists))
	{
		stmt_fetch_row(stmt_AccountExists);

		if(exists == 0)
			return 0;
	}
	else
	{
		print("ERROR: [LoadAccount] executing statement 'stmt_AccountExists'.");
		return 0;
	}

	stmt_bind_value(stmt_AccountLoad, 0, DB::TYPE_STRING, gPlayerName[playerid], MAX_PLAYER_NAME);
	stmt_bind_result_field(stmt_AccountLoad, FIELD_ID_PLAYER_PASS, DB::TYPE_STRING, password, MAX_PASSWORD_LEN);
	stmt_bind_result_field(stmt_AccountLoad, FIELD_ID_PLAYER_IPV4, DB::TYPE_INTEGER, ipv4);
	stmt_bind_result_field(stmt_AccountLoad, FIELD_ID_PLAYER_ALIVE, DB::TYPE_INTEGER, alive);
	stmt_bind_result_field(stmt_AccountLoad, FIELD_ID_PLAYER_REGDATE, DB::TYPE_INTEGER, regdate);
	stmt_bind_result_field(stmt_AccountLoad, FIELD_ID_PLAYER_LASTLOG, DB::TYPE_INTEGER, lastlog);
	stmt_bind_result_field(stmt_AccountLoad, FIELD_ID_PLAYER_SPAWNTIME, DB::TYPE_INTEGER, spawntime);
	stmt_bind_result_field(stmt_AccountLoad, FIELD_ID_PLAYER_TOTALSPAWNS, DB::TYPE_INTEGER, spawns);
	stmt_bind_result_field(stmt_AccountLoad, FIELD_ID_PLAYER_WARNINGS, DB::TYPE_INTEGER, warnings);
	stmt_bind_result_field(stmt_AccountLoad, FIELD_ID_PLAYER_AIMSHOUT, DB::TYPE_STRING, aimshout, 128);

	if(!stmt_execute(stmt_AccountLoad))
	{
		print("ERROR: [LoadAccount] executing statement 'stmt_AccountLoad'.");
		return 0;
	}

	stmt_fetch_row(stmt_AccountLoad);

	if(gWhitelist)
	{
		if(!IsNameInWhitelist(gPlayerName[playerid]))
			return 3;
	}

	SetPlayerBitFlag(playerid, Alive, alive);
	SetPlayerBitFlag(playerid, HasAccount, true);
	SetPlayerBitFlag(playerid, IsNewPlayer, false);

	SetPlayerPassHash(playerid, password);
	SetPlayerRegTimestamp(playerid, regdate);
	SetPlayerLastLogin(playerid, lastlog);
	SetPlayerCreationTimestamp(playerid, spawntime);
	SetPlayerTotalSpawns(playerid, spawns);
	SetPlayerWarnings(playerid, warnings);
	SetPlayerAimShoutText(playerid, aimshout);

	Tutorial_End(playerid);

	if(GetPlayerIpAsInt(playerid) == ipv4)
		return 2;
	
	return 1;
}


/*==============================================================================

	Creates a new account for a player with the specified password hash.

==============================================================================*/


CreateAccount(playerid, password[])
{
	new serial[MAX_GPCI_LEN];

	gpci(playerid, serial, MAX_GPCI_LEN);

	stmt_bind_value(stmt_AccountCreate, 0, DB::TYPE_STRING,		gPlayerName[playerid], MAX_PLAYER_NAME); 
	stmt_bind_value(stmt_AccountCreate, 1, DB::TYPE_STRING,		password, MAX_PASSWORD_LEN); 
	stmt_bind_value(stmt_AccountCreate, 2, DB::TYPE_INTEGER,	GetPlayerIpAsInt(playerid)); 
	stmt_bind_value(stmt_AccountCreate, 3, DB::TYPE_INTEGER,	gettime()); 
	stmt_bind_value(stmt_AccountCreate, 4, DB::TYPE_INTEGER,	gettime()); 
	stmt_bind_value(stmt_AccountCreate, 5, DB::TYPE_STRING,		"Drop your weapon!", 18); 
	stmt_bind_value(stmt_AccountCreate, 6, DB::TYPE_STRING,		serial, MAX_GPCI_LEN); 
	stmt_execute(stmt_AccountCreate);

	SetPlayerAimShoutText(playerid, "Drop your weapon!");

	if(gWhitelist)
	{
		if(!IsNameInWhitelist(gPlayerName[playerid]))
		{
			WhitelistKick(playerid);
			return 0;
		}
	}

	CheckAdminLevel(playerid);

	if(GetPlayerAdminLevel(playerid) > 0)
		MsgF(playerid, BLUE, " >  Your admin level: %d", GetPlayerAdminLevel(playerid));

	SetPlayerBitFlag(playerid, LoggedIn, true);
	SetPlayerBitFlag(playerid, HasAccount, true);
	SetPlayerBitFlag(playerid, ToolTips, true);

	PlayerCreateNewCharacter(playerid);

	return 1;
}

DeleteAccount(name[])
{
	#pragma unused name
	// Deleting accounts is removed.
	// Disabling accounts will be used instead.
	return 1;
}

DisplayRegisterPrompt(playerid)
{
	new str[150];
	format(str, 150, ""C_WHITE"Hello %P"C_WHITE", You must be new here!\nPlease create an account by entering a "C_BLUE"password"C_WHITE" below:", playerid);

	inline Response(pid, dialogid, response, listitem, string:inputtext[])
	{
		#pragma unused pid, dialogid, listitem

		if(response)
		{
			if(!(4 <= strlen(inputtext) <= 32))
			{
				Msg(playerid, YELLOW, " >  Password must be between 4 and 32 characters.");
				DisplayRegisterPrompt(playerid);
				return 0;
			}

			new buffer[MAX_PASSWORD_LEN];

			WP_Hash(buffer, MAX_PASSWORD_LEN, inputtext);

			if(CreateAccount(playerid, buffer))
				ShowWelcomeMessage(playerid, 10);
		}
		else
		{
			MsgAllF(GREY, " >  %s left the server without registering.", gPlayerName[playerid]);
			Kick(playerid);
		}

		return 1;
	}
	Dialog_ShowCallback(playerid, using inline Response, DIALOG_STYLE_PASSWORD, "Register For A New Account", str, "Accept", "Leave");

	return 1;
}

DisplayLoginPrompt(playerid, badpass = 0)
{
	new str[128];

	if(badpass)
		format(str, 128, "Incorrect password! %d out of 5 tries", LoginPasswordAttempts[playerid]);

	else
		format(str, 128, ""C_WHITE"Welcome Back %P"C_WHITE", Please log into to your account below!\n\n"C_YELLOW"Enjoy your stay :)", playerid);

	inline Response(pid, dialogid, response, listitem, string:inputtext[])
	{
		#pragma unused pid, dialogid, listitem

		if(response)
		{
			if(strlen(inputtext) < 4)
			{
				DisplayLoginPrompt(playerid);
				return 1;
			}

			new
				inputhash[MAX_PASSWORD_LEN],
				storedhash[MAX_PASSWORD_LEN];

			WP_Hash(inputhash, MAX_PASSWORD_LEN, inputtext);
			GetPlayerPassHash(playerid, storedhash);

			if(!strcmp(inputhash, storedhash))
			{
				Login(playerid);
			}
			else
			{
				LoginPasswordAttempts[playerid]++;

				if(LoginPasswordAttempts[playerid] < 5)
				{
					DisplayLoginPrompt(playerid);
				}
				else
				{
					MsgAllF(GREY, " >  %s left the server without logging in.", gPlayerName[playerid]);
					Kick(playerid);
				}
			}
		}
		else
		{
			MsgAllF(GREY, " >  %s left the server without logging in.", gPlayerName[playerid]);
			Kick(playerid);
		}

		return 1;
	}
	Dialog_ShowCallback(playerid, using inline Response, DIALOG_STYLE_PASSWORD, "Login To Your Account", str, "Accept", "Leave");

	return 1;
}


/*==============================================================================

	Loads a player's account, updates some data and spawns them.

==============================================================================*/


Login(playerid)
{
	new serial[MAX_GPCI_LEN];

	gpci(playerid, serial, MAX_GPCI_LEN);

	stmt_bind_value(stmt_AccountSetIpv4, 0, DB::TYPE_INTEGER, GetPlayerIpAsInt(playerid));
	stmt_bind_value(stmt_AccountSetIpv4, 1, DB::TYPE_PLAYER_NAME, playerid);
	stmt_execute(stmt_AccountSetIpv4);

	stmt_bind_value(stmt_AccountSetGpci, 0, DB::TYPE_STRING, serial);
	stmt_bind_value(stmt_AccountSetGpci, 1, DB::TYPE_PLAYER_NAME, playerid);
	stmt_execute(stmt_AccountSetGpci);

	stmt_bind_value(stmt_AccountSetLastLog, 0, DB::TYPE_INTEGER, gettime());
	stmt_bind_value(stmt_AccountSetLastLog, 1, DB::TYPE_PLAYER_NAME, playerid);
	stmt_execute(stmt_AccountSetLastLog);

	CheckAdminLevel(playerid);

	if(GetPlayerAdminLevel(playerid) > 0)
	{
		new
			reports = GetUnreadReports(),
			issues = GetBugReports();

		MsgF(playerid, BLUE, " >  Your admin level: %d", GetPlayerAdminLevel(playerid));

		if(reports > 0)
			MsgF(playerid, YELLOW, " >  %d unread reports, type "C_BLUE"/reports "C_YELLOW"to view.", reports);

		if(issues > 0)
			MsgF(playerid, YELLOW, " >  %d issues, type "C_BLUE"/issues "C_YELLOW"to view.", issues);
	}

	SetPlayerBitFlag(playerid, LoggedIn, true);
	LoginPasswordAttempts[playerid] = 0;

	SetPlayerRadioFrequency(playerid, 107.0);
	SetPlayerScreenFadeLevel(playerid, 255);

	SpawnLoggedInPlayer(playerid);
}


/*==============================================================================

	Logs the player out, saving their data and deleting their items.

==============================================================================*/


Logout(playerid, docombatlogcheck = 1)
{
	new
		Float:x,
		Float:y,
		Float:z,
		Float:r;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, r);

	logf("[LOGOUT] %p logged out at %.1f, %.1f, %.1f (%.1f) Alive: %d combat logging: %d knocked out: %d logged in: %d", playerid, x, y, z, r, IsPlayerAlive(playerid), IsPlayerKnockedOut(playerid), GetPlayerBitFlag(playerid, LoggedIn));

	if(!GetPlayerBitFlag(playerid, LoggedIn))
		return 0;

	if(IsPlayerOnAdminDuty(playerid))
		return 0;

	if(docombatlogcheck)
	{
		new
			lastattacker,
			lastweapon;

		if(IsPlayerCombatLogging(playerid, lastattacker, lastweapon))
		{
			OnPlayerDeath(playerid, lastattacker, lastweapon);
		}
	}

	new
		itemid,
		ItemType:itemtype;

	itemid = GetPlayerItem(playerid);
	itemtype = GetItemType(itemid);

	if(IsItemTypeSafebox(itemtype) || IsItemTypeBag(itemtype))
	{
		if(!IsContainerEmpty(GetItemExtraData(itemid)))
		{
			CreateItemInWorld(itemid, x + floatsin(-r, degrees), y + floatcos(-r, degrees), z - FLOOR_OFFSET, .zoffset = ITEM_BUTTON_OFFSET);

			itemid = INVALID_ITEM_ID;
		}
	}

	SavePlayerData(playerid);

	if(IsPlayerAlive(playerid))
	{
		DestroyItem(itemid);
		DestroyPlayerBag(playerid);
		RemovePlayerHolsterItem(playerid);
		RemovePlayerWeapon(playerid);

		for(new i; i < INV_MAX_SLOTS; i++)
		{
			DestroyItem(GetInventorySlotItem(playerid, 0));
			RemoveItemFromInventory(playerid, 0);
		}

		if(IsValidItem(GetPlayerHat(playerid)))
			RemovePlayerHat(playerid);

		if(IsValidItem(GetPlayerMask(playerid)))
			RemovePlayerMask(playerid);

		if(IsPlayerInAnyVehicle(playerid))
		{
			new Float:health;

			GetVehicleHealth(GetPlayerLastVehicle(playerid), health);

			if(health < VEHICLE_HEALTH_MIN)
				DestroyVehicle(GetPlayerLastVehicle(playerid));

			else
				UpdateVehicleFile(GetPlayerLastVehicle(playerid));
		}
	}

	return 1;
}


/*==============================================================================

	Updates the database and calls the binary save functions if required.

==============================================================================*/


SavePlayerData(playerid)
{
	if(IsPlayerOnAdminDuty(playerid))
		return 0;

	if(!GetPlayerBitFlag(playerid, LoadedData))
		return 0;

	new
		Float:x,
		Float:y,
		Float:z,
		Float:r;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, r);

	if(IsAtConnectionPos(x, y, z))
		return 0;

	SaveBlockAreaCheck(x, y, z);

	if(IsPlayerInAnyVehicle(playerid))
		x += 1.5;

	if(IsPlayerAlive(playerid))
	{
		if(IsAtDefaultPos(x, y, z))
			return 0;

		if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
		{
			if(!gServerRestarting)
				return 0;
		}

		stmt_bind_value(stmt_AccountUpdate, 0, DB::TYPE_INTEGER, 1);
		stmt_bind_value(stmt_AccountUpdate, 1, DB::TYPE_INTEGER, GetPlayerKarma(playerid));
		stmt_bind_value(stmt_AccountUpdate, 2, DB::TYPE_INTEGER, GetPlayerWarnings(playerid));
		stmt_bind_value(stmt_AccountUpdate, 3, DB::TYPE_PLAYER_NAME, playerid);
		stmt_execute(stmt_AccountUpdate);

		SavePlayerChar(playerid);
	}
	else
	{
		stmt_bind_value(stmt_AccountUpdate, 0, DB::TYPE_INTEGER, 0);
		stmt_bind_value(stmt_AccountUpdate, 1, DB::TYPE_INTEGER, GetPlayerKarma(playerid));
		stmt_bind_value(stmt_AccountUpdate, 2, DB::TYPE_INTEGER, GetPlayerWarnings(playerid));
		stmt_bind_value(stmt_AccountUpdate, 3, DB::TYPE_PLAYER_NAME, playerid);

		stmt_execute(stmt_AccountUpdate);

		ClearPlayerInventoryFile(playerid);
	}

	return 1;
}


/*==============================================================================

	Interface functions

==============================================================================*/


// FIELD_ID_PLAYER_NAME
AccountExists(name[])
{
	new exists;

	stmt_bind_value(stmt_AccountExists, 0, DB::TYPE_STRING, name, MAX_PLAYER_NAME);
	stmt_bind_result_field(stmt_AccountExists, 0, DB::TYPE_INTEGER, exists);

	if(stmt_execute(stmt_AccountExists))
	{
		stmt_fetch_row(stmt_AccountExists);

		if(exists)
			return 1;
	}

	return 0;
}

// FIELD_ID_PLAYER_PASS
stock GetAccountPassword(name[], password[MAX_PASSWORD_LEN])
{
	stmt_bind_result_field(stmt_AccountGetPassword, 0, DB::TYPE_STRING, password, MAX_PASSWORD_LEN);
	stmt_bind_value(stmt_AccountGetPassword, 0, DB::TYPE_STRING, name, MAX_PLAYER_NAME);

	if(!stmt_execute(stmt_AccountGetPassword))
		return 0;

	stmt_fetch_row(stmt_AccountGetPassword);

	return 1;
}

stock SetAccountPassword(name[], password[MAX_PASSWORD_LEN])
{
	stmt_bind_value(stmt_AccountSetPassword, 0, DB::TYPE_STRING, password, MAX_PASSWORD_LEN);
	stmt_bind_value(stmt_AccountSetPassword, 1, DB::TYPE_STRING, name, MAX_PLAYER_NAME);

	return stmt_execute(stmt_AccountSetPassword);
}

// FIELD_ID_PLAYER_IPV4
stock GetAccountIP(name[], &ip)
{
	stmt_bind_result_field(stmt_AccountGetIpv4, 0, DB::TYPE_INTEGER, ip);
	stmt_bind_value(stmt_AccountGetIpv4, 0, DB::TYPE_STRING, name, MAX_PLAYER_NAME);

	if(!stmt_execute(stmt_AccountGetIpv4))
		return 0;

	stmt_fetch_row(stmt_AccountGetIpv4);

	return 1;
}

stock SetAccountIP(name[], ip)
{
	stmt_bind_value(stmt_AccountSetIpv4, 0, DB::TYPE_INTEGER, ip);
	stmt_bind_value(stmt_AccountSetIpv4, 1, DB::TYPE_STRING, name, MAX_PLAYER_NAME);

	return stmt_execute(stmt_AccountSetIpv4);
}

// FIELD_ID_PLAYER_ALIVE
stock GetAccountAliveState(name[], &alivestate)
{
	stmt_bind_result_field(stmt_AccountGetAliveState, 0, DB::TYPE_INTEGER, alivestate);
	stmt_bind_value(stmt_AccountGetAliveState, 0, DB::TYPE_STRING, name, MAX_PLAYER_NAME);

	if(!stmt_execute(stmt_AccountGetAliveState))
		return 0;

	stmt_fetch_row(stmt_AccountGetAliveState);

	return 1;
}

stock SetAccountAliveState(name[], alivestate)
{
	stmt_bind_value(stmt_AccountSetAliveState, 0, DB::TYPE_INTEGER, alivestate);
	stmt_bind_value(stmt_AccountSetAliveState, 1, DB::TYPE_STRING, name, MAX_PLAYER_NAME);

	return stmt_execute(stmt_AccountSetAliveState);
}

// FIELD_ID_PLAYER_KARMA
stock GetAccountKarma(name[], &karma)
{
	stmt_bind_result_field(stmt_AccountGetKarma, 0, DB::TYPE_INTEGER, karma);
	stmt_bind_value(stmt_AccountGetKarma, 0, DB::TYPE_STRING, name, MAX_PLAYER_NAME);

	if(!stmt_execute(stmt_AccountGetKarma))
		return 0;

	stmt_fetch_row(stmt_AccountGetKarma);

	return 1;
}

stock SetAccountKarma(name[], karma)
{
	stmt_bind_value(stmt_AccountSetKarma, 0, DB::TYPE_INTEGER, karma);
	stmt_bind_value(stmt_AccountSetKarma, 1, DB::TYPE_STRING, name, MAX_PLAYER_NAME);

	return stmt_execute(stmt_AccountSetKarma);
}

// FIELD_ID_PLAYER_REGDATE
stock GetAccountRegistrationDate(name[], &timestamp)
{
	stmt_bind_result_field(stmt_AccountGetRegdate, 0, DB::TYPE_INTEGER, timestamp);
	stmt_bind_value(stmt_AccountGetRegdate, 0, DB::TYPE_STRING, name, MAX_PLAYER_NAME);

	if(!stmt_execute(stmt_AccountGetRegdate))
		return 0;

	stmt_fetch_row(stmt_AccountGetRegdate);

	return 1;
}

stock SetAccountRegistrationDate(name[], timestamp)
{
	stmt_bind_value(stmt_AccountSetRegdate, 0, DB::TYPE_INTEGER, timestamp);
	stmt_bind_value(stmt_AccountSetRegdate, 1, DB::TYPE_STRING, name, MAX_PLAYER_NAME);

	return stmt_execute(stmt_AccountSetRegdate);
}

// FIELD_ID_PLAYER_LASTLOG
stock GetAccountLastLogin(name[], &timestamp)
{
	stmt_bind_result_field(stmt_AccountGetLastLog, 0, DB::TYPE_INTEGER, timestamp);
	stmt_bind_value(stmt_AccountGetLastLog, 0, DB::TYPE_STRING, name, MAX_PLAYER_NAME);

	if(!stmt_execute(stmt_AccountGetLastLog))
		return 0;

	stmt_fetch_row(stmt_AccountGetLastLog);

	return 1;
}

stock SetAccountLastLogin(name[], timestamp)
{
	stmt_bind_value(stmt_AccountSetLastLog, 0, DB::TYPE_INTEGER, timestamp);
	stmt_bind_value(stmt_AccountSetLastLog, 1, DB::TYPE_STRING, name, MAX_PLAYER_NAME);

	return stmt_execute(stmt_AccountSetLastLog);
}

// FIELD_ID_PLAYER_SPAWNTIME
stock GetAccountLastSpawnTimestamp(name[], timestamp)
{
	stmt_bind_result_field(stmt_AccountGetSpawnTime, 0, DB::TYPE_INTEGER, timestamp);
	stmt_bind_value(stmt_AccountGetSpawnTime, 0, DB::TYPE_STRING, name, MAX_PLAYER_NAME);

	if(!stmt_execute(stmt_AccountGetSpawnTime))
		return 0;

	stmt_fetch_row(stmt_AccountGetSpawnTime);

	return 1;
}

stock SetAccountLastSpawnTimestamp(name[], timestamp)
{
	stmt_bind_value(stmt_AccountSetSpawnTime, 0, DB::TYPE_INTEGER, timestamp);
	stmt_bind_value(stmt_AccountSetSpawnTime, 1, DB::TYPE_STRING, name, MAX_PLAYER_NAME);

	return stmt_execute(stmt_AccountSetSpawnTime);
}

// FIELD_ID_PLAYER_TOTALSPAWNS
stock GetAccountTotalSpawns(name[], &spawns)
{
	stmt_bind_result_field(stmt_AccountGetTotalSpawns, 0, DB::TYPE_INTEGER, spawns);
	stmt_bind_value(stmt_AccountGetTotalSpawns, 0, DB::TYPE_STRING, name, MAX_PLAYER_NAME);

	if(!stmt_execute(stmt_AccountGetTotalSpawns))
		return 0;

	stmt_fetch_row(stmt_AccountGetTotalSpawns);

	return 1;
}

stock SetAccountTotalSpawns(name[], spawns)
{
	stmt_bind_value(stmt_AccountSetTotalSpawns, 0, DB::TYPE_INTEGER, spawns);
	stmt_bind_value(stmt_AccountSetTotalSpawns, 1, DB::TYPE_STRING, name, MAX_PLAYER_NAME);

	return stmt_execute(stmt_AccountSetTotalSpawns);
}

// FIELD_ID_PLAYER_WARNINGS
stock GetAccountWarnings(name[], &warnings)
{
	stmt_bind_result_field(stmt_AccountGetWarnings, 0, DB::TYPE_INTEGER, warnings);
	stmt_bind_value(stmt_AccountGetWarnings, 0, DB::TYPE_STRING, name, MAX_PLAYER_NAME);

	if(!stmt_execute(stmt_AccountGetWarnings))
		return 0;

	stmt_fetch_row(stmt_AccountGetWarnings);

	return 1;
}

stock SetAccountWarnings(name[], warnings)
{
	stmt_bind_value(stmt_AccountSetWarnings, 0, DB::TYPE_INTEGER, warnings);
	stmt_bind_value(stmt_AccountSetWarnings, 1, DB::TYPE_STRING, name, MAX_PLAYER_NAME);

	return stmt_execute(stmt_AccountSetWarnings);
}

// FIELD_ID_PLAYER_AIMSHOUT
stock GetAccountAimshout(name[], string[128])
{
	stmt_bind_result_field(stmt_AccountGetAimShout, 0, DB::TYPE_STRING, string, 128);
	stmt_bind_value(stmt_AccountGetAimShout, 0, DB::TYPE_STRING, name, MAX_PLAYER_NAME);

	if(!stmt_execute(stmt_AccountGetAimShout))
		return 0;

	stmt_fetch_row(stmt_AccountGetAimShout);

	return 1;
}

stock SetAccountAimshout(name[], string[128])
{
	stmt_bind_value(stmt_AccountSetAimShout, 0, DB::TYPE_STRING, string, 128);
	stmt_bind_value(stmt_AccountSetAimShout, 1, DB::TYPE_STRING, name, MAX_PLAYER_NAME);

	return stmt_execute(stmt_AccountSetAimShout);
}

// FIELD_ID_PLAYER_GPCI
stock GetAccountGPCI(name[], gpci[MAX_GPCI_LEN])
{
	stmt_bind_result_field(stmt_AccountGetGpci, 0, DB::TYPE_STRING, gpci, MAX_GPCI_LEN);
	stmt_bind_value(stmt_AccountGetGpci, 0, DB::TYPE_STRING, name, MAX_PLAYER_NAME);

	if(!stmt_execute(stmt_AccountGetGpci))
		return 0;

	stmt_fetch_row(stmt_AccountGetGpci);

	return 1;
}

stock SetAccountGPCI(name[], gpci[MAX_GPCI_LEN])
{
	stmt_bind_value(stmt_AccountGetGpci, 0, DB::TYPE_STRING, gpci, MAX_GPCI_LEN);
	stmt_bind_value(stmt_AccountGetGpci, 1, DB::TYPE_STRING, name, MAX_PLAYER_NAME);

	return stmt_execute(stmt_AccountGetGpci);
}

// Pass, IP and gpci
stock GetAccountAliasData(name[], pass[129], &ip, gpci[MAX_GPCI_LEN])
{
	stmt_bind_value(stmt_AccountGetAliasData, 0, DB::TYPE_STRING, name, MAX_PLAYER_NAME);
	stmt_bind_result_field(stmt_AccountGetAliasData, 0, DB::TYPE_STRING, pass, MAX_PASSWORD_LEN);
	stmt_bind_result_field(stmt_AccountGetAliasData, 1, DB::TYPE_INTEGER, ip);
	stmt_bind_result_field(stmt_AccountGetAliasData, 2, DB::TYPE_STRING, gpci, MAX_GPCI_LEN);

	if(!stmt_execute(stmt_AccountGetAliasData))
		return 0;

	stmt_fetch_row(stmt_AccountGetAliasData);

	return 1;
}
