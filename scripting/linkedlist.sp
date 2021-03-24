#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <linkedlist>

#define PLUGIN_NAME "LinkedList"
#define PLUGIN_AUTHOR "JoinedSenses"
#define PLUGIN_DESCRIPTION "LinkedList for SourcePawn"
#define PLUGIN_VERSION "0.1.0"
#define PLUGIN_URL "https://github.com/JoinedSenses"

public Plugin myinfo = {
	name = PLUGIN_NAME,
	author = PLUGIN_AUTHOR,
	description = PLUGIN_DESCRIPTION,
	version = PLUGIN_VERSION,
	url = PLUGIN_URL
}

// 

methodmap Node < Handle {
	public native Node(Handle owner);

	property Node Next {
		public native get();
		public native set(Node next);
	}

	property any Data {
		public native get();
		public native set(any data);
	}
}

enum struct _Node {
	Node next;
	any data;
}

enum struct _LinkedList {
	Handle owner;
	Node front;
	Node back;
	int size;
}

//

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max) {
	CreateNative("Node.Node", Node_Node);
	CreateNative("Node.Next.get", Node_Next_get);
	CreateNative("Node.Next.set", Node_Next_set);
	CreateNative("Node.Data.get", Node_Data_get);
	CreateNative("Node.Data.set", Node_Data_set);

	CreateNative("LinkedList.LinkedList", LinkedList_LinkedList);
	CreateNative("LinkedList.Close", LinkedList_Close);
	CreateNative("LinkedList.Push", LinkedList_Push);
	CreateNative("LinkedList.Insert", LinkedList_Insert);
	CreateNative("LinkedList.Erase", LinkedList_Erase);
	CreateNative("LinkedList.Get", LinkedList_Get);
	CreateNative("LinkedList.Set", LinkedList_Set);
	CreateNative("LinkedList.Clear", LinkedList_Clear);
	CreateNative("LinkedList.Size.get", LinkedList_Size_get);
}

public void OnPluginStart() {
	CreateConVar(
		"sm_linkedlist_version",
		PLUGIN_VERSION,
		PLUGIN_DESCRIPTION,
		FCVAR_SPONLY|FCVAR_NOTIFY|FCVAR_DONTRECORD
	).SetString(PLUGIN_VERSION);
}

// == Natives

public any Node_Node(Handle plugin, int params) {
	Handle arr = CreateArray(sizeof _Node, 1);

	_Node node;
	SetArrayArray(arr, 0, node);

	Handle clone = CloneHandle(arr, GetNativeCell(1));

	CloseHandle(arr);

	return clone;
}

public any Node_Next_get(Handle plugin, int params) {
	Handle self = GetNativeCell(1);

	return GetArrayCell(self, 0, _Node::next);
}

public any Node_Next_set(Handle plugin, int params) {
	Handle self = GetNativeCell(1);

	SetArrayCell(self, 0, GetNativeCell(2), _Node::next);

	return 0;
}

public any Node_Data_get(Handle plugin, int params) {
	Handle self = GetNativeCell(1);

	return GetArrayCell(self, 0, _Node::data);
}

public any Node_Data_set(Handle plugin, int params) {
	Handle self = GetNativeCell(1);

	SetArrayCell(self, 0, GetNativeCell(2), _Node::data);

	return 0;
}

public any LinkedList_LinkedList(Handle plugin, int params) {
	int startsize = GetNativeCell(1);
	Handle arr = CreateArray(sizeof _LinkedList, 1);

	_LinkedList list;
	list.owner = plugin;

	if (startsize > 0) {
		Node current = new Node(plugin);
		list.front = current;
		list.size = 1;

		for (int i = 1; i < startsize; ++i) {
			current.Next = new Node(plugin);
			current = current.Next;

			++list.size;
		}

		list.back = current;
	}

	SetArrayArray(arr, 0, list);

	Handle clone = CloneHandle(arr, plugin);

	CloseHandle(arr);

	return clone;
}

public any LinkedList_Close(Handle plugin, int params) {
	Handle self = GetNativeCell(1);
	
	_LinkedList list;
	GetArrayArray(self, 0, list);

	Node node;
	while (list.front != null) {
		node = list.front;
		list.front = list.front.Next;
		CloseHandle(node);
	}

	CloseHandle(self);

	return 0;
}

public any LinkedList_Push(Handle plugin, int params) {
	Handle self = GetNativeCell(1);

	_LinkedList list;
	GetArrayArray(self, 0, list);

	++list.size;

	Node node = new Node(list.owner);
	node.Data = GetNativeCell(2);

	if (list.front == null) {
		list.front = node;
		list.back = node;
	}
	else {
		list.back.Next = node;
		list.back = node;
	}

	SetArrayArray(self, 0, list);

	return 0;
}

public any LinkedList_Insert(Handle plugin, int params) {
	Handle self = GetNativeCell(1);

	_LinkedList list;
	GetArrayArray(self, 0, list);

	int idx = GetNativeCell(2);
	if (idx < 0 || idx >= list.size) {
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid index (%i)", idx);
	}

	Node node = new Node(list.owner);
	node.Data = GetNativeCell(3);

	Node current = list.front;
	Node previous;

	for (int i = 0; i < idx; ++i) {
		previous = current;
		current = current.Next;
	}

	if (previous == null) {
		node.Next = list.front;
		list.front = node;
	}
	else {
		node.Next = current;
		previous.Next = node;
	}

	++list.size;

	SetArrayArray(self, 0, list);

	return 0;
}

public any LinkedList_Erase(Handle plugin, int params) {
	Handle self = GetNativeCell(1);

	_LinkedList list;
	GetArrayArray(self, 0, list);

	Node previous;
	Node current = list.front;

	int idx = GetNativeCell(2);

	if (idx < 0 || idx >= list.size) {
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid index (%i)", idx);
	}

	for (int i = 0; i < idx; ++i) {
		previous = current;
		current = current.Next;
	}

	if (current == list.front) {
		list.front = current.Next;
	}

	if (current == list.back) {
		list.back = previous;
	}

	if (previous != null) {
		previous.Next = current.Next;
	}

	CloseHandle(current);

	--list.size;

	SetArrayArray(self, 0, list);

	return 0;
}

public any LinkedList_Get(Handle plugin, int params) {
	Handle self = GetNativeCell(1);

	Node node = GetArrayCell(self, 0, _LinkedList::front);

	int idx = GetNativeCell(2);
	for (int i = 0; i < idx; ++i) {
		node = node.Next;
	}

	return node.Data;
}

public any LinkedList_Set(Handle plugin, int params) {
	Handle self = GetNativeCell(1);

	Node node = GetArrayCell(self, 0, _LinkedList::front);

	int idx = GetNativeCell(2);
	for (int i = 0; i < idx; ++i) {
		node = node.Next;
	}

	node.Data = GetNativeCell(3);

	return 0;
}

public any LinkedList_Clear(Handle plugin, int params) {
	Handle self = GetNativeCell(1);

	_LinkedList list;
	GetArrayArray(self, 0, list);

	Node node;
	while (list.front != null) {
		node = list.front;
		list.front = list.front.Next;
		CloseHandle(node);
	}

	list.back = null;
	list.size = 0;

	SetArrayArray(self, 0, list);

	return 0;
}

public any LinkedList_Size_get(Handle plugin, int params) {
	Handle self = GetNativeCell(1);

	return GetArrayCell(self, 0, _LinkedList::size);
}