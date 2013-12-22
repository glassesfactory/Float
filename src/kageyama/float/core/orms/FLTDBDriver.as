/**
 * Created by MEGNAE on 2013/12/21.
 */
package kageyama.float.core.orms
{
    import flash.data.SQLConnection;
    import flash.data.SQLStatement;
    import flash.data.SQLTableSchema;
    import flash.filesystem.File;
    import flash.utils.Dictionary;

    public class FLTDBDriver
    {
        protected static var $schemas:Dictionary = new Dictionary();
        protected static var $dbFiles:Object;
        protected static var $connectionPool:Object;

        public static function getConnection(dbName:String = "main", isAsync:Boolean=true):SQLConnection
        {
            var con:SQLConnection;
            var poolKey:String = dbName + "_-_" + (isAsync ? "async" : "sync");

            if( poolKey in $connectionPool)
            {
                con = $connectionPool[poolKey];
                if(!con.connected)
                {
                    con = reopenConnection(con, poolKey);
                }
                return con;
            }

            if( !(dbName in $dbFiles))
                return null

            var file:File = _getFile(dbName);

            if(isAsync)
                con.openAsync(file);
            else
                con.open(file);

            $connectionPool[poolKey] = con;
            return con;
        }



        /**
         * コネクションを再接続する
         * @param con
         * @param poolKey
         * @return
         */
        public static function reopenConnection(con:SQLConnection, poolKey:String=null):SQLConnection
        {
            if( !poolKey )
                poolKey = _getPoolKey(con);
            //あれ
            if( !poolKey )
                throw new Error("おお");

            var keys:Array = poolKey.split('_-_');
            var dbName:String = keys[0];
            var isAsync:Boolean = keys.pop() == "async";

            var file:File = _getFile(dbName);
            if(isAsync)
                con.openAsync(file);
            else
                con.open(file);

            return con;
        }



        public static function registerDBFile(fileNameOrFileObj:Object, dbName:String):void
        {
            $dbFiles[dbName] = (fileNameOrFileObj is File) ? fileNameOrFileObj : File.applicationStorageDirectory.resolvePath(fileNameOrFileObj as String);
        }



        /**
         * コネクションから poolKey を返す
         * @param con
         * @return
         */
        private static function _getPoolKey(con:SQLConnection):String
        {
            for( var key in $connectionPool)
            {
                if($connectionPool[key] == con)
                {
                    delete $connectionPool[key]
                    return key;
                }
            }
            return null
        }


        private static function _getFile(dbName:String):File
        {
            var f:File = $dbFiles[dbName] is File ? $dbFiles[dbName] as File : File.applicationStorageDirectory.resolvePath(dbName);
            return f;
        }
    }
}