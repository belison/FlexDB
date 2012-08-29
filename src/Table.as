package  
{
	import flash.events.Event;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	import mx.collections.ArrayCollection;
	import mx.events.PropertyChangeEvent;
	import mx.utils.UIDUtil;

	public class Table
	{
			
		private var _unique_key:String;
		
		private var indexes:Object = new Object;
		private var raw_collection:ArrayCollection;
		
		public var name:String;
		
		public function Table()
		{
		}
		
		public function find(key:String):Object {
			if (key && unique_key && indexes.hasOwnProperty(unique_key) ) {
				
				if (indexes[unique_key].hasOwnProperty(key)) {
					return indexes[unique_key][key]
				}
				
			}
			
			return null;
		}
		
		public function find_all():ArrayCollection {
			var return_col:ArrayCollection = new ArrayCollection;
			
			if (raw_collection) {	
				return_col.source = return_col.source.concat(raw_collection.source);
			}
			
			return return_col;
		}
		
		public function find_all_by(index:String, value:String):ArrayCollection {
			var return_col:ArrayCollection = new ArrayCollection;
			if (indexes[index].hasOwnProperty(value) && indexes[index][value] && indexes[index][value] is Array) {
				return_col.source = return_col.source.concat(indexes[index][value]);
			}

			return  return_col;
		}
		
		public function find_between(index:String, start:Object, end:Object, compareFunction:Function = null):ArrayCollection {
			var col:ArrayCollection = new ArrayCollection();
			
			for (var key:Object in indexes[index]) {		
				if (Boolean(compareFunction)) {
					if (compareFunction.call(this, start,end,key)) {
						col.source = col.source.concat(indexes[index][key]);
					}	
				} else {
				
					if (key >= start && key <= end) {
						col.source = col.source.concat(indexes[index][key]);
					} 		
				}
			}
			
			return col
		}
		
		public function find_all_by_filter(filterFunction:Function):ArrayCollection {
			var filtered_collection:ArrayCollection = new ArrayCollection(raw_collection.source.slice(0,raw_collection.length));
			filtered_collection.filterFunction = filterFunction;
			filtered_collection.refresh();
			return filtered_collection;
		}
		
		
		public function insert(collection:ArrayCollection, mergeFunction:Function = null):ArrayCollection {
			var inserted:ArrayCollection = new ArrayCollection;
			
			for each (var item:Object in collection) {
				//experimental 
				if (!item[unique_key])
					item[unique_key] = UIDUtil.createUID();
				
				if (unique_key && indexes.hasOwnProperty(unique_key) ) {
					
					if (indexes[unique_key].hasOwnProperty(item[unique_key])) {
						//Already exists need to compare
						if ( Boolean(mergeFunction) ) {
							mergeFunction.call(this, indexes[unique_key][item[unique_key]], item);
						}
						continue
					}
	
				}
				
				for (var index:String in indexes) {
					indexItem(item, index);
				}
				
				if (!raw_collection) {
					raw_collection = new ArrayCollection;
				}
				raw_collection.addItem(item);
				inserted.addItem(item);
			}
			return inserted
		}
		
		
		public function remove(item:Object):void {
			if (raw_collection.contains(item)) {
				for (var index:String in indexes) {
					unindexItem(item, index);
				}
				
				raw_collection.removeItemAt(raw_collection.getItemIndex(item));
			}
		}
		
		
		public function set unique_key(key:String):void {
			_unique_key = key;
			addIndexes([key]);
		}
		
		public function get unique_key():String {
			return _unique_key;
		}
		
		public function addIndexes(array:Array):void {
			
			for each(var index:String in array) {
				if (indexes.hasOwnProperty(name)) {
					continue;
				} else {
					indexes[index] = new Object;
					indexCollection(index);
				}
			}
		}
		
		
		private function indexCollection(index:String):void {
			for each(var item:Object in  raw_collection) {
				indexItem(item, index);
			}
		}
		
		private function indexItem(item:Object, index:String, watch:Boolean = true):void {
			if (item.hasOwnProperty(index) && item[index] !== undefined || (index.indexOf('.') > -1)) {
				if (index == unique_key) {
					indexes[index][item[index]] = item;
				} else {
					var watcher:ChangeWatcher;
					
					if (index.indexOf('.') > -1) {
						//complex index
						var pieces:Array = index.split('.');
						var arrayKey:String = pieces[0];
						var arrayVal:String = pieces[1];
						
						for each(var subItem:Object in item[arrayKey]) {
							if (!indexes[index].hasOwnProperty(subItem[arrayVal].toString())) {
								indexes[index][subItem[arrayVal].toString()] = new Array;
							}
							
														
							(indexes[index][subItem[arrayVal].toString()] as Array).push(item);
						}
						
						if (ChangeWatcher.canWatch(item, arrayKey) && watch) {
							watcher = ChangeWatcher.watch(item, arrayKey, handleComplexIndexValueChanged);
						}
						
						
					} else {
					
						if (!indexes[index].hasOwnProperty(item[index].toString())) {
							indexes[index][item[index].toString()] = new Array;
						}
						
						(indexes[index][item[index].toString()] as Array).push(item);
						
						if (ChangeWatcher.canWatch(item, index) && watch) {
							watcher = ChangeWatcher.watch(item, index, handleIndexValueChanged);
						}
					}
				}
				
				
			}
		}
		
		private function unindexItem(item:Object, index:String, oldValue:Object = null):void {
			if (index == unique_key) {
				delete indexes[index][item[index]]
			} else {
				var itemIndex:Number
				
				if (index.indexOf('.') > -1) {
					
					var pieces:Array = index.split('.');
					var arrayKey:String = pieces[0];
					var arrayVal:String = pieces[1];
					var loopCollection:Object = item[arrayKey];
					
					
					if (oldValue) {
						loopCollection = oldValue;
					}
					
					for each(var subItem:Object in loopCollection) {
						if (!(indexes[index] as Object).hasOwnProperty(subItem[arrayVal].toString()) ) {
							continue;
						}
						itemIndex = (indexes[index][subItem[arrayVal].toString()] as Array).indexOf(item)
						
						if (itemIndex > -1) {
							(indexes[index][subItem[arrayVal].toString()] as Array).splice(itemIndex, 1);
						}

					}
					
				} else {
					itemIndex = (indexes[index][item[index].toString()] as Array).indexOf(item)
							
					if (itemIndex > -1) {
						(indexes[index][item[index].toString()] as Array).splice(itemIndex, 1);
					}
				}
			}
			
		}
		
		
		private function handleIndexValueChanged(event:PropertyChangeEvent):void {
			var oldIndex:Number = (indexes[event.property.toString()][event.oldValue.toString()] as Array).indexOf(event.source)
			
			if (oldIndex > -1) {
				(indexes[event.property.toString()][event.oldValue.toString()] as Array).splice(oldIndex, 1);
			}
			
			indexItem(event.source, event.property.toString(), false);
		}
		
		
		private function handleComplexIndexValueChanged(event:PropertyChangeEvent):void {			
			var complexKey:String;
			
			if (event.oldValue.length > 0) {
				complexKey = event.property.toString()+'.'+(event.oldValue as ArrayCollection).getItemAt(0)['complexIndexKey'];
				unindexItem(event.source, complexKey, event.oldValue);
			} 
			
			if (event.newValue.length > 0) {
				complexKey = event.property.toString()+'.'+(event.newValue as ArrayCollection).getItemAt(0)['complexIndexKey'];
				indexItem(event.source, complexKey, false);
			}
		}
	}
}