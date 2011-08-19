package FlexUnitTests
{
	import flexunit.framework.Assert;
	import flexunit.framework.TestCase;

	public class BaseDBTester extends TestCase
	{		
		// Reference declaration for class to test
		private var classToTestRef:BaseDB
		
		[Before]
		override public function setUp():void
		{
			super.setUp();
		}
		
		[After]
		override public function tearDown():void
		{
			super.tearDown();
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
		
		[Test]
		public function testRemovingATable():void {
			var table:Table = BaseDB.addTable('testTable');
			
			Assert.assertEquals(BaseDB.removeTable('testTable'), true);
			
		}
		
		
	}
}