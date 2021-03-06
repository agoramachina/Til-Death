local t = Def.ActorFrame{}

t[#t+1] = LoadActor("../_chatbox")
t[#t+1] = LoadActor("../ScreenSelectMusic decorations/profile")
t[#t+1] = LoadActor("../ScreenSelectMusic decorations/msd")
t[#t+1] = LoadActor("../ScreenSelectMusic decorations/songsearch")
t[#t+1] = LoadActor("tabs")
t[#t+1] = LoadActor("../ScreenSelectMusic decorations/score")
t[#t+1] = LoadActor("dumbrate")
t[#t+1] = LoadActor("../ScreenSelectMusic decorations/filters")

local g = Def.ActorFrame{
	TabChangedMessageCommand=function(self)
		local top= SCREENMAN:GetTopScreen()
		if getTabIndex() == 0 then
			self:visible(true)
			top:ChatboxVisible(true)
			top:ChatboxInput(true)
		else 
			self:visible(false)
			top:ChatboxVisible(false)
			top:ChatboxInput(false)
		end
	end,
}

g[#g+1] = Def.Banner{
	InitCommand=cmd(x,10;y,60;halign,0;valign,0);
	SetMessageCommand=function(self)
		local top = SCREENMAN:GetTopScreen()
		if top:GetName() == "ScreenSelectMusic" or top:GetName() == "ScreenNetSelectMusic" then
			local song = GAMESTATE:GetCurrentSong()
			local group = top:GetMusicWheel():GetSelectedSection()
			if song then
				self:LoadFromSong(song)
			elseif group then
				self:LoadFromSongGroup(group)
			end
		end
		self:scaletoclipped(capWideScale(get43size(384),384),capWideScale(get43size(120),120))
	end;
	CurrentSongChangedMessageCommand=cmd(queuecommand,"Set"),
	CurrentStepsP1ChangedMessageCommand=cmd(queuecommand,"Set");
	CurrentStepsP2ChangedMessageCommand=cmd(queuecommand,"Set");
};
g[#g+1] = Def.Quad{
	InitCommand=cmd(xy,10,60+capWideScale(get43size(120),120)-capWideScale(get43size(10),10);zoomto,capWideScale(get43size(384),384),capWideScale(get43size(20),20);halign,0;diffuse,color("#000000");diffusealpha,0.7);
}
g[#g+1] = LoadFont("Common Normal") .. {
	Name="songTitle";
	InitCommand=cmd(xy,15,60+capWideScale(get43size(120),120)-capWideScale(get43size(10),10);visible,true;halign,0;zoom,capWideScale(get43size(0.45),0.45);maxwidth,capWideScale(get43size(340),340)/capWideScale(get43size(0.45),0.45));
	BeginCommand=cmd(queuecommand,"Set");
	SetCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		if song ~= nil then
			self:settext(song:GetDisplayMainTitle().." // "..song:GetDisplayArtist())
		else
			self:settext("")
		end
	end;
	CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
};

g[#g+1] = LoadActor("wifeonline")
g[#g+1] = LoadActor("onlinebpm")
g[#g+1] = LoadActor("radaronline")

g[#g+1] = Def.ActorFrame {
	InitCommand=cmd(xy,capWideScale(get43size(384),384)+26,70,halign,0;valign,0;zoom,math.min(1,SCREEN_WIDTH/854));
	OffCommand=cmd(bouncebegin,0.2;xy,capWideScale(get43size(384),384)+26-500,70;); -- visible(false) doesn't seem to work with sleep
	OnCommand=cmd(bouncebegin,0.2;xy,capWideScale(get43size(384),384)+26,70;);
	TabChangedMessageCommand=function(self)
		self:finishtweening()
		if getTabIndex() == 0 then
			self:playcommand("On");
		else 
			self:playcommand("Off");
		end;
	end;
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong(); 
		if song then
			self:finishtweening();
			self:playcommand("TweenOn");
		elseif not song and self:GetZoomX() == 1 then
			self:finishtweening();
			self:playcommand("TweenOff");
		end;
	end;
	Def.StepsDisplayList {
		Name="StepsDisplayListRow";

		CursorP1 = Def.ActorFrame {
			InitCommand=cmd(x,55;player,PLAYER_1);
			PlayerJoinedMessageCommand=function(self, params)
				if params.Player == PLAYER_1 then
					self:visible(true);
					(cmd(zoom,0;bounceend,1;zoom,1))(self);
				end;
			end;
			PlayerUnjoinedMessageCommand=function(self, params)
				if params.Player == PLAYER_1 then
					self:visible(true);
					(cmd(bouncebegin,1;zoom,0))(self);
				end;
			end;
			Def.Quad{
				InitCommand=cmd(zoomto,6,22;halign,1;valign,0.5);
				BeginCommand=cmd(queuecommand,"Set");
				SetCommand=function(self)
					if GAMESTATE:GetNumPlayersEnabled()>=2 then
						self:zoomy(11);
						self:valign(1);
					else
						self:zoomy(22);
						self:valign(0.5);
					end;
				end;
				PlayerJoinedMessageCommand=cmd(playcommand,"Set");
				PlayerUnjoinedMessageCommand=cmd(playcommand,"Set");
			};
			LoadFont("Common Normal") .. {
				InitCommand=cmd(x,-1;halign,1;valign,0.5;zoom,0.3;diffuse,color("#000000"));
				BeginCommand=cmd(queuecommand,"Set");
				SetCommand=function(self)
					self:settext('1')
					if GAMESTATE:GetNumPlayersEnabled()>=2 then
						self:y(-6)
					else
						self:y(0)
					end;
				end;
				PlayerJoinedMessageCommand=cmd(playcommand,"Set");
				PlayerUnjoinedMessageCommand=cmd(playcommand,"Set");
			};
		};
		CursorP2 = Def.ActorFrame {
			InitCommand=cmd(x,55;player,PLAYER_2);
			PlayerJoinedMessageCommand=function(self, params)
				if params.Player == PLAYER_2 then
					self:visible(true);
					(cmd(zoom,0;bounceend,1;zoom,1))(self);
				end;
			end;
			PlayerUnjoinedMessageCommand=function(self, params)
				if params.Player == PLAYER_2 then
					self:visible(true);
					(cmd(bouncebegin,1;zoom,0))(self);
				end;
			end;
			Def.Quad{
				InitCommand=cmd(zoomto,6,22;halign,1;valign,0.5);
				BeginCommand=cmd(queuecommand,"Set");
				SetCommand=function(self)
					if GAMESTATE:GetNumPlayersEnabled()>=2 then
						self:zoomy(11);
						self:valign(0);
					else
						self:zoomy(22);
						self:valign(0.5);
					end;
				end;
				PlayerJoinedMessageCommand=cmd(playcommand,"Set");
				PlayerUnjoinedMessageCommand=cmd(playcommand,"Set");
			};
			LoadFont("Common Normal") .. {
				InitCommand=cmd(x,-1;halign,1;valign,0.5;zoom,0.3;diffuse,color("#000000"));
				BeginCommand=cmd(queuecommand,"Set");
				SetCommand=function(self)
					self:settext('2')
					if GAMESTATE:GetNumPlayersEnabled()>=2 then
						self:y(6)
					else
						self:y(0)
					end;
				end;
				PlayerJoinedMessageCommand=cmd(playcommand,"Set");
				PlayerUnjoinedMessageCommand=cmd(playcommand,"Set");
			};
		};
		CursorP1Frame = Def.Actor{
			ChangeCommand=cmd(stoptweening;decelerate,0.05);
		};
		CursorP2Frame = Def.Actor{
			ChangeCommand=cmd(stoptweening;decelerate,0.05);
		};
	};
};
t[#t+1] = g

return t
