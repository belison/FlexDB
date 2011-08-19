package UnitTests
{
	
	import flexunit.framework.Assert;

	public class BaseDBTester
	{		
		// Reference declaration for class to test
		private var classToTestRef:BaseDB
		
		[Before]
		public function setUp():void
		{
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test]
		public function testGettingAnInstance():void {
			var instance:BaseDB = BaseDB.instance;
			
			Assert.assertEquals(BaseDB.instance, instance);
		}
		
		[Test]
		public function testAddingATable():void {
			var table:Table = BaseDB.addTable('testTable');
			
			Assert.assertNotNull(table);
			Assert.assertEquals(table.name, 'testTable');
			Assert.assertEquals(BaseDB.getTableByName('testTable'), table);
			
		}
		
		
	}
}