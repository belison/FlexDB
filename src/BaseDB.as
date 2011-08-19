package  
{

	public class BaseDB
	{
		
		private var tables:Object = new Object;
		
		
		private static var _instance:BaseDB = new BaseDB;
		
		public function BaseDB()
		{
			
			
		}
		
		public static function get instance():BaseDB {
			return _instance;
		}
		
		
		public static function getTableByName(name:String):Table {
			return instance.tables[name] as Table;
		}
		
		
		/**
		 * An table name must be a unique string
		 */
		public static function addTable(name:String):Table {
			
			if (instance.tables.hasOwnProperty(name)) {
				return null;
			} else {
				var t:Table = new Table;
				t.name = name;
				instance.tables[name] = t;
			}
			
			return t;
		}
		
		public static function removeTable(name:String):Boolean {
			if (instance.tables.hasOwnProperty(name)) {
				delete instance.tables[name];
				return true;
			}
			
			return false;
		}
		
	}
}