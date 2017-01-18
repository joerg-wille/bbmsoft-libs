package net.bbmsoft.fxtended.annotations.util

import org.eclipse.xtend.core.compiler.batch.XtendCompilerTester
import org.junit.Test

class SingletonTest {

	extension XtendCompilerTester compilerTester = XtendCompilerTester.newXtendCompilerTester(Singleton)

	@Test
	def void testSingletonEmptyConstructor() {
		
		val input = '''
			import net.bbmsoft.fxtended.annotations.util.Singleton
			
			@Singleton 
			class Item {
			
			}
		'''
		
		val output = '''
			import net.bbmsoft.fxtended.annotations.util.Singleton;
			
			@Singleton
			@SuppressWarnings("all")
			public class Item {
			  private final static Item instance = new Item();
			  
			  public static final Item getInstance() {
			    return instance;
			  }
			  
			  private Item() {
			    
			  }
			}
		'''
		
		input.assertCompilesTo(output)
	}
	
	@Test
	def void testSingletonImplementedConstructor() {
		
		val input = '''
			import net.bbmsoft.fxtended.annotations.util.Singleton
			
			@Singleton 
			class Item {
				
				private new() {
					doStuff
				}
				
				private def void doStuff() {}
			}
		'''
		
		val output = '''
			import net.bbmsoft.fxtended.annotations.util.Singleton;
			
			@Singleton
			@SuppressWarnings("all")
			public class Item {
			  private Item() {
			    this.doStuff();
			  }
			  
			  private void doStuff() {
			  }
			  
			  private final static Item instance = new Item();
			  
			  public static final Item getInstance() {
			    return instance;
			  }
			}
		'''
		
		input.assertCompilesTo(output)
	}
}
