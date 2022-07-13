/* -----------------------------------------------
	Freeview Camera Resource (Client-Side)	
	Version: v1.0
	Author: Razor#7311
------------------------------------------------ */

function GetFrontPos(pos, angle, gap) return Vector(pos.X - gap * sin(angle), pos.Y + gap * cos(angle), pos.Z);
function GetSidePos(pos, angle, gap) return Vector(cos(angle) * gap + pos.X, sin(angle) * gap + pos.Y, pos.Z);

Freeview <- {
	/* --------------------------------------------------------------- */
	// - You can change these values according to what you want
	StreamType = 0x07,
	
	Speed = 0.25,
	DefaultSpeed = 0.25,
	SpeedLimit = 3,
	/* --------------------------------------------------------------- */
	
	Temp_Speed = 0,
	
	X = 0,
	Y = 0,
	Z = 0,
	Angle = 0,
	
	hudType = 0,
	
	isOnView = false,
	
	isMovingUp = false,
	isMovingDown = false,
	isMovingFront = false,
	isMovingBack = false,
	isMovingLeft = false,
	isMovingRight = false,
	
	player = World.FindLocalPlayer(),
	
	labelInfo = null,
	
	sW = GUI.GetScreenSize().X,
	sH = GUI.GetScreenSize().Y,

	UP = KeyBind(0x26),
	DOWN = KeyBind(0x28),
	LEFT = KeyBind(0x25),
	RIGHT = KeyBind(0x27),
	W = KeyBind(0x57),
	A = KeyBind(0x41),
	D = KeyBind(0x44),
	S = KeyBind(0x53),
	PAGEUP = KeyBind(0x21),
	PAGEDOWN = KeyBind(0x22),
	INSERT = KeyBind(0x2D),
	DELETE = KeyBind(0x2E),
	HOME = KeyBind(0x24),
	SHIFT = KeyBind(0x10),

	loadLabel = function() {
		this.labelInfo = GUILabel();
		this.labelInfo.Size = VectorScreen(this.sW * 0.01, this.sH * 0.01);
		this.labelInfo.TextAlignment = GUI_ALIGN_LEFT;
		this.labelInfo.FontFlags = GUI_FFLAG_OUTLINE;
		this.labelInfo.AddFlags(GUI_FLAG_TEXT_TAGS);
		this.labelInfo.FontSize = this.sH * 0.020;
		this.labelInfo.Pos = VectorScreen(this.sW * 0.01, this.sH * 0.95)
	}
	
	unloadLabels = function() {
		this.labelInfo = null;
	}
	
	enterView = function() {
		if (this.isOnView == false) {
			this.X = World.FindLocalPlayer().Position.X;
			this.Y = World.FindLocalPlayer().Position.Y;
			this.Z = World.FindLocalPlayer().Position.Z + 10;
			
			this.loadLabel();
			this.isOnView = true;
			
			Console.Print("[Freeview] Entered in Freeview mode.");
		}
		else {
			this.exitView();
		}
	}
	
	exitView = function() {
		if (this.isOnView == true) {
			Hud.AddFlags(HUD_FLAG_RADAR | HUD_FLAG_WEAPON | HUD_FLAG_CLOCK | HUD_FLAG_CASH | HUD_FLAG_HEALTH | HUD_FLAG_WANTED);
			
			this.X = 0;
			this.Y = 0;
			this.Z = 0;
			
			this.isOnView = false,
	
			this.isMovingUp = false;
			this.isMovingDown = false;
			this.isMovingFront = false;
			this.isMovingBack = false;
			this.isMovingLeft = false;
			this.isMovingRight = false;
			
			this.Temp_Speed = 0;
			
			this.unloadLabels();
			
			this.isOnView = false;
			
			Console.Print("[Freeview] Exited the Freeview mode.");
		}
	}

	onScriptProcess = function() {
		if (this.isOnView == true) {
			/* --------------------------------------------------------------------- */
			// - Credits to @vito for this calculation
			local angle,
			an = GUI.ScreenPosToWorld(Vector((this.sW * 0.5), (this.sH * 0.5), 1)), 
			bn = GUI.ScreenPosToWorld(Vector((this.sW * 0.5), (this.sH * 0.5), -1)),
			
			front = ::atan2(an.Y - bn.Y, an.X - bn.X),
			back = ::atan2(-an.Y - -bn.Y, -an.X - -bn.X);
			/* --------------------------------------------------------------------- */
	
			this.Angle = front;

			if (this.isMovingFront == true || this.isMovingBack == true) {
				if (this.isMovingFront == true) {
					angle = front;
				}
				else if (this.isMovingBack == true) {
					angle = back;
				}
				
				this.Angle = angle;
				this.X = GetSidePos(player.Position, angle, (this.Speed + this.Temp_Speed)).X;
				this.Y = GetSidePos(player.Position, angle, (this.Speed + this.Temp_Speed)).Y;
			}
			if (this.isMovingLeft == true || this.isMovingRight == true) {
				if (this.isMovingLeft == true) {
					angle = front;
				}
				else if (this.isMovingRight == true) {
					angle = back;
				}
				
				this.Angle = angle;
				this.X = GetFrontPos(player.Position, angle, (this.Speed + this.Temp_Speed)).X;
				this.Y = GetFrontPos(player.Position, angle, (this.Speed + this.Temp_Speed)).Y;
			}
			if (this.isMovingUp == true || this.isMovingDown == true) {
				if (this.isMovingUp == true) {
					this.Z += (this.Speed + this.Temp_Speed);
				}
				else if (this.isMovingDown == true) {
					this.Z -= (this.Speed + this.Temp_Speed);
				}
			}
			
			player.Position.X = this.X;
			player.Position.Y = this.Y;
			player.Position.Z = this.Z;
			
			this.hudType != 2 ? this.labelInfo.Text = "[#a3a3a3]Speed: [#88b8de]x[#ffffff]" + format("%1.1f", this.Speed) + "[#88b8de] | [#a3a3a3]Position: [#ffffff]Vector([#88b8de]" + this.X + ", " + this.Y + ", " + this.Z + "[#ffffff])[#88b8de] | [#a3a3a3]Angle: [#ffffff]" + this.Angle : this.labelInfo.Text = "";
		}
	}
	
	increaseSpeed = function() {
		this.Speed += this.DefaultSpeed;
		
		if (this.Speed > this.SpeedLimit) {
			this.Speed = this.DefaultSpeed;
		}
	}
	
	decreaseSpeed = function() {
		this.Speed -= this.DefaultSpeed;
		
		if (this.Speed < this.DefaultSpeed) {
			this.Speed = this.SpeedLimit;
		}
	}
	
	hudMode = function() {
		this.hudType++;
		if (this.hudType > 2) this.hudType = 0;
		
		switch(this.hudType) {
			case 0:
				Hud.AddFlags(HUD_FLAG_RADAR | HUD_FLAG_WEAPON | HUD_FLAG_CLOCK | HUD_FLAG_CASH | HUD_FLAG_HEALTH | HUD_FLAG_WANTED);
			break;
			case 1:
				Hud.RemoveFlags(HUD_FLAG_RADAR | HUD_FLAG_WEAPON | HUD_FLAG_CLOCK | HUD_FLAG_CASH | HUD_FLAG_HEALTH | HUD_FLAG_WANTED);
			break;
		}
	}
	
	onKeyBindDown = function(keyBind) {
		if (this.isOnView == true) {
			switch(keyBind) {
				case this.UP:
				case this.W:
				this.isMovingFront = true;
				break;
				case this.DOWN:
				case this.S:
				this.isMovingBack = true;
				break;
				
				case this.LEFT:
				case this.A:
				this.isMovingLeft = true;
				break;
				case this.RIGHT:
				case this.D:
				this.isMovingRight = true;
				break;
				
				case this.PAGEUP:
				this.isMovingUp = true;
				break;
				
				case this.PAGEDOWN:
				this.isMovingDown = true;
				break;
				
				case this.INSERT:
				this.increaseSpeed();
				break;
				
				case this.DELETE:
				this.decreaseSpeed();
				break;
				
				case this.HOME: 
				this.hudMode();
				break;
				
				case this.SHIFT:
				this.Temp_Speed = 1;
				break;
			}
		}
	}
	
	onKeyBindUp = function(keyBind) {
		if (this.isOnView == true) {
			switch(keyBind) {
				case this.UP:
				case this.W:
				this.isMovingFront = false;
				break;
				case this.DOWN:
				case this.S:
				this.isMovingBack = false;
				break;
				
				case this.LEFT:
				case this.A:
				this.isMovingLeft = false;
				break;
				case this.RIGHT:
				case this.D:
				this.isMovingRight = false;
				break;
				
				case this.PAGEUP:
				this.isMovingUp = false;
				break;
				
				case this.PAGEDOWN:
				this.isMovingDown = false;
				break;
								
				case this.SHIFT:
				this.Temp_Speed = 0;
				break;
			}
		}
	}

    onServerData = function(byte) {
        switch(byte) {
            case this.StreamType:
            this.enterView();
            break;
        }
    }
}
