--[[-------------------------------------------------------------------------
Database config
---------------------------------------------------------------------------]]
local SLCDatabaseConfig = {
	ENGINE = "SQLite", //"MySQL" for MySQL, anything else for SQLite
	HOST = "",
	PORT = "3306",
	USER = "",
	PASSWORD = "",
	DATABASE = "",
}

if SLCDatabaseConfig.ENGINE == "MySQL" then
	SLCDatabase:Connect( {
		host = SLCDatabaseConfig.HOST,
		port = SLCDatabaseConfig.PORT,
		username = SLCDatabaseConfig.USER,
		password = SLCDatabaseConfig.PASSWORD,
		database = SLCDatabaseConfig.DATABASE,
	} )
end