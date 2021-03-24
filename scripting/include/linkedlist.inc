#if defined _linkedlist_included_
  #endinput
#endif
#define _linkedlist_included_

// --------------

methodmap LinkedList {
	public native LinkedList(int startSize = 0);
	public native void Close();

	public native void Push(any data);
	public native void Insert(int index, any data);
	public native void Erase(int index);
	
	public native any Get(int index);
	public native void Set(int index, any data);

	public native void Clear();

	property int Size {
		public native get();
	}
}

// -------------- 

public SharedPlugin __pl_linkedlist = {
	name = "linkedlist",
	file = "linkedlist.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};


public void __pl_linkedlist_SetNTVOptional() {
#if !defined REQUIRE_PLUGIN
	// MarkNativeAsOptional("");
#endif
}
