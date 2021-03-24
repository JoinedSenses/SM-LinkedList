#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <linkedlist>

public Plugin myinfo = {
	name = "LinkedList Test",
	author = "JoinedSenses",
	description = "Tests ListedList",
	version = "0.1.0",
	url = "https://github.com/JoinedSenses"
}

public void OnPluginStart() {
	RegAdminCmd("sm_testlinkedlist", cmdTestLinkedList, ADMFLAG_ROOT);
}

public Action cmdTestLinkedList(int client, int args) {
	char buffer[32];

	LinkedList list = LinkedList();

	for (int i = 0; i < 3; ++i) {
		list.Push(i + 1);
	}

	int size = list.Size;
	for (int i = 0; i < size; ++i) {
		Format(buffer, sizeof buffer, "%s%i ", buffer, list.Get(i));
	}

	ReplyToCommand(client, "%s", buffer); // 1 2 3 
	buffer[0] = '\0';

	list.Insert(2, 7);
	list.Erase(1);
	list.Insert(0, 8);

	size = list.Size;
	for (int i = 0; i < size; ++i) {
		Format(buffer, sizeof buffer, "%s%i ", buffer, list.Get(i));
	}

	ReplyToCommand(client, "%s", buffer); // 8 1 7 3
	buffer[0] = '\0';

	for (int i = 0; i < size; ++i) {
		list.Set(i, i);
	}

	for (int i = 0; i < size; ++i) {
		Format(buffer, sizeof buffer, "%s%i ", buffer, list.Get(i)); // 0 1 2 3
	}

	list.Clear();

	Format(buffer, sizeof buffer, "%s(%i) ", buffer, list.Size); // 0 1 2 3 (0);

	list.Push(1);

	list.Close();

	Format(buffer, sizeof buffer, "%s(%s) ", buffer, IsValidHandle(list) ? "Valid" : "Closed"); // 0 1 2 3 (0) (Closed)

	list = NULL_LINKEDLIST;

	ReplyToCommand(client, "%s", buffer);

	return Plugin_Handled;
}