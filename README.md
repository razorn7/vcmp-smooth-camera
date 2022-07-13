## Smooth Freeview Camera for Vice City Multiplayer (VC:MP)
A feature that allows the player to enter camera mode freely.

### Setup
1. Clone the [repository](https://github.com/Razorn7/Smooth-Freeview-Camera-for-VCMP/)
2. After you have cloned the repository, click you will see two files, copy `server.freeview.nut` to your server's `/scripts` folder, then there will be the `client.freeview.nut` file, you should copy it to the `store/script` folder on your server.
3. Then have your server load both files, server and client side.
4. (Server-Side) Add the hooks to the `onPlayerJoin` and `onPlayerPart` events to be like that:

- ```squirrel
  function onPlayerJoin(player) {
	  Freeview.players[player.ID] = freeviewClass();
  }
  
- ```squirrel
  function onPlayerPart(player, reason) {
	  Freeview.players[player.ID] = null;
  }

5. (Client-Side) Now, add the hooks to the `Script::ScriptProcess`, `Server::ServerData`, `KeyBind::OnDown` and `KeyBind::OnUp` events to be like that:

- ```squirrel
  function onPlayerJoin(player) {
	  Freeview.players[player.ID] = freeviewClass();
  }
  
- ```squirrel
  function Server::ServerData(stream) {
	  local int = stream.ReadInt(), string = stream.ReadString(), byte = stream.ReadByte();
	  Freeview.onServerData(byte);
  }

- ```squirrel
  function KeyBind::OnDown(key) {
	  Freeview.onKeyBindDown(key);
  }
  
- ```squirrel
  function KeyBind::OnUp(key) {
	  Freeview.onKeyBindUp(key);
  }

6. To enter camera mode, just use `Freeview.enterView(player)` and to exit use `Freeview.exitView(player)`. Enjoy!

### Functions
- `Freeview.enterView(player)` - Used to enter in Freeview mode.
- `Freeview.exitView(player)` - Used to exit Freeview mode.

### Key Binds
**Arrow Up/W** - Move to front
**Arrow Down/S** - Move to back
**Arrow Left/A** - Move to left
**Arrow Right/D** - Move to right
**PageUp** - Move to Up
**PageDown** - Move to Down
**Home** - Change HUD mode
**Insert** - Increase Speed
**Delete** - Decrease Speed

### Demonstration
https://www.youtube.com/watch?v=--Hk-ey752w
