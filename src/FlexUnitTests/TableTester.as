package FlexUnitTests
{
	import flexunit.framework.Assert;
	import flexunit.framework.TestCase;
	
	import mx.collections.ArrayCollection;

	public class TableTester extends TestCase
	{		
		// Reference declaration for class to test
		private var classToTestRef:Table
		
		private var table:Table
		
		[Before]
		override public function setUp():void
		{
			super.setUp();
			table = BaseDB.addTable('testingTable');
			table.unique_key = 'id';
			
			var row:Object = new Object;
			row.id = 'uniqueIDValue';
			row.description = 'here is the object description';
			row.date = new Date;
			
			table.insert(new ArrayCollection([row]));
		}
		
		[After]
		override public function tearDown():void
		{
			super.tearDown();
			
			BaseDB.removeTable('testingTable');

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
		public function testInsert():void {
			var row:Object = new Object;
			row.id = 'uniqueIDValue2';
			row.description = 'here is the object description for insert test';
			row.date = new Date;
			
			table.insert(new ArrayCollection([row]));
		}
		
		[Test]
		public function testFind():void {
			var t:Table = BaseDB.getTableByName('testingTable');
			
			var row:Object = t.find('uniqueIDValue');
			Assert.assertNotNull(row);
			Assert.assertEquals(row.description, 'here is the object description');
		}
		
		[Test]
		public function testFindAll():void {
			var row:Object = new Object;
			row.id = 'uniqueIDValue2';
			row.description = 'here is the object description for insert test';
			row.date = new Date;
			
			table.insert(new ArrayCollection([row]));
			
			Assert.assertEquals(table.find_all().length,2);
		}
		
		[Test]
		public function testFindBetween():void {
			
		}
		
		[Test]
		public function testFindAllByFilter():void {
			
		}
		
		
		
		[Test]
		public function testRemove():void {
			var row:Object = new Object;
			row.id = 'uniqueIDValue2';
			row.description = 'here is the object description for insert test';
			row.date = new Date;
			
			table.insert(new ArrayCollection([row]));
			table.remove(row);
			
			Assert.assertNull(table.find('uniqueIDValue2'));
		}
		
		[Test]
		public function testSetUniqueKey():void {
			
		}
		
		[Test]
		public function testGetUniqueKey():void {
			Assert.assertEquals(table.unique_key, 'id');
		}
		
		[Test]
		public function testAddIndexes():void {
			
		}
	}
}