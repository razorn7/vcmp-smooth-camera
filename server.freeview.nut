/* -----------------------------------------------
	Freeview Camera Resource (Server-Side)	
	Version: v1.0
	Author: Razor#7311
------------------------------------------------ */

class freeviewClass {
	isOnView = false;
	Skin = -1;
	Immunity = -1;
	Pos = Vector(0, 0, 0);
}

Freeview <- {
	players = array(GetMaxPlayers(), null),
	
    	StreamType = 0x07,
	
	enterView = function(player) {
		if (this.players[player.ID].isOnView == false) {
			this.players[player.ID].Skin = player.Skin;
			this.players[player.ID].Pos = player.Pos;
			this.players[player.ID].Immunity = player.Immunity;
			
			player.Skin = 0;
			player.SetAlpha(0);
			player.Immunity = -1;
		
			Stream.StartWrite();
            Stream.WriteByte(this.StreamType);
			Stream.SendStream(player);
			
			this.players[player.ID].isOnView = true;
		}
		else {
			PrivMessage(player, "[Error] Already in Freeview mode.");
		}
	}
	
	exitView = function(player) {
		if (this.players[player.ID].isOnView == true) {
			player.Skin = this.players[player.ID].Skin;
			player.Pos = this.players[player.ID].Pos;
			player.SetAlpha(255);
			player.Immunity = this.players[player.ID].Immunity;

			Stream.StartWrite();
            Stream.WriteByte(this.StreamType);
			Stream.SendStream(player);
			
			this.players[player.ID].isOnView = false;
		}
		else {
			PrivMessage(player, "[Error] You're not in Freeview mode.");
		}
	}
}
