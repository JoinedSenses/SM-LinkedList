#if defined _linkedlist_included_
  #endinput
#endif
#define _linkedlist_included_

// --------------

enum LinkedList {
	NULL_LINKEDLIST,
}

methodmap LinkedList {
	public native LinkedList(int startSize = 0);
	public native void Close();

	public native void Push(any data);
	public native void Insert(int index, any data);
	public native void Erase(int index);
	
	public native any Get(int index);
	public native void Set(int index, any data);

	public native void Clear();

	public native LinkedList Clone();

	property int Size {
		public native get();
	}
}

native LinkedList CloneLinkedList(LinkedList list, Handle plugin);

// -------------- 

public SharedPlugin __pl_linkedlist = {
	name = "LinkedList",
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
