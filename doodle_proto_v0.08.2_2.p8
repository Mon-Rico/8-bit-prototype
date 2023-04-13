pico-8 cartridge // http://www.pico-8.com
version 41
__lua__

// This file contains the verision 8, however, the clip function is being used for the "cave" level. 
// Goal: Separate levels into respective functions, add transition of levels to the main game.
-------------main---------------
//version 0.08.2  
--[[

--added character select and
  title screen (wip)
--start prototype enemies and 
  obstacles (wip)
--optimized sprite placement
  (the correct way this time)
--moved camera function so 
  player sprite doesn't 
  oscillate

]]

//to do (priority):
--[[

--enemy/obstacle types
--menu system to chose characters
		--more character types
--sprite animations
--level design

]]

//known bugs:
--[[

]]


function _init() 
	map_end=64
	
	scene = "title"
	
	texts = {}

	create_txt("this is the title",20,cam_y+20,1+rnd(14))
	create_txt("press x to select character", 10,cam_y+60,1+rnd(14))


	//to optimize code (future goal)
//	_update60 = title_update
	//_draw = draw_title 
end


//title variables
	texts = {}


//camera variable
 cam_y = 0

//game  variables
 paused = false
	start = false
	gameover = false
	//charcter selections
	// sprite(1) = dog
	// sprite(2) = human
	// sprite(3) = alien
	// sprite(4) = frog
	sprite_num = 0
	char_selected = false
	counter = 1


//timer gobal variables
 dt = 0
 t = 0


//for the timers txt 
function txt_width(txt)
	return 64-#txt*2
end

function _update60()
	if scene == "title" then
		title_update()
	elseif scene == "select" then
		charselect_update()
			
	elseif scene == "game" then
	 
		start_game()
 	end
end

//player controls --> select character


//	sprite_num = 0

function update_txt(text)
	for t in all(texts) do  
		if t.curr_w < t.w then  
			t.curr_w+=1  
		end
	end
end

function create_txt(txt,x,y,c)
	clip(2,cam_y,0,0)
	local w, h = print(txt,0,0)
	clip()
	local text= {
		txt = txt,
		x = x,
		y = y,
		w = w,
		h = h,
		c = c,
		curr_w = 0
	}
	add(texts,text)
end


	

-->8
----------update functions-------------

--[1] title functions
--[2] character selection functions
--[3] game functions

//[1]

//title functions
function title_update()
 	update_txt()
	gameover = false
	local right = false
	
	if(btnp(❎))char_select = not char_select
		if char_select == true then
			scene = "select"
		
	end
 
end



//[2]

function charselect_update()

	
	if btnp(➡️) then
		counter +=1
	elseif btnp(⬅️) then
		counter -=1
	end
	
	if counter == 2 then
		counter = 0
	elseif counter == -1 then
		counter = 1
	end

	
//general idea; time to work with sprites
//	if btn(➡️) then print(spr(+1)) end
	//if btn(⬅️) then print(spr(-1)) end
//	if btn(⬆️) then print(spr()(+1)) end
//	if btn(⬇️) then print(spr()()) end
	


//start game
	if(btnp(🅾️))char_selected = not char_selected
		if char_selected == true then
			draw_charselect()
			scene = "game"
		end
end


//[3]

//Game over section starts because of a bug (debug needed)
function start_game()			
		//game over section   
		if player.y+position() > cam_y+128 then
						gameover = true
						sfx(4)				 
		else
		 //game pause section
						if(btnp(❎))pause = not pause
				
							if not pause then
								player_move()
								
								
							 air_time+=0.12
			//timer section
							 local fps = stat(8)
							 dt = 1/fps
								t += dt
								
								//camera
		     cam_y=player.y-45+position()
		     if cam_y>map_end then
				   	cam_y=map_end
		     else
			     map_end=cam_y
		     end
		  
		     camera(0,cam_y)

								
						  collision(platform1)
						  collision(platform2)
						  collision(platform3)
							 collision(platform4)
		   
						  plat_redraw(platform1)
							 plat_redraw(platform2) 
							 plat_redraw(platform3)
							 plat_redraw(platform4)				 
							 	
						end
						
			end		
				
end


-->8
----------draw functions--------------
--[1] main draw --> pause section inside
--[2] title
--[3] character selection
--[4] game play
--[5] game over



--[1]

function _draw()
	cls()
	
	if scene == "title" then
		draw_title()
		
	elseif scene == "select" then
		draw_charselect()
		
	elseif scene == "game" then
		//game pause section
	   
		 if pause then
			 print("game paused",2,cam_y+50,6)
		 else
		//a 3-2-1 warning before starting again needed
			 
			 draw_hud()
		 end
		 
		//game over section 
		
		 if gameover == true then
		 	
		  draw_gameover()			   
	  end
   
	end
end 
   --[[
	//for debugging
	print(air_time,0,cam_y+18,7) 
	print(player.y+position(),
						 0,cam_y+6,7)
	print(position(),0,cam_y+12,7)
	print(cam_y,0,cam_y+122,7)
	print(plat_highest,0,cam_y+18,7)
	print(flag,0,cam_y+24,7)
	print(platform1.t,0,cam_y,7)
	print(platform2.t,4,cam_y,7)
	print(platform3.t,8,cam_y,7)
	print(platform4.t,12,cam_y,7)
   ]]
   
--[2]
function draw_title()
	cls()
	for t in all(texts) do  
		clip(t.x,t.y,t.curr_w,t.h)  
		print(t.txt,t.x,t.y,t.c) 
	end  
	clip()
end   
   


--[3]
function draw_charselect()
	cls()
	rect(0,127,cam_y+127,0,5,0)
	//arrow right
	spr(3,player.x-40,cam_y+50,2,2)
	//arrow left
	spr(7,player.x+20,cam_y+50,2,2)
	
	if counter == 1 then
		spr(1,player.x-10,cam_y+50,2,2)
	elseif counter == 2 then
		spr(3,player.x-10,cam_y+50,2,2)
	elseif counter == 3 then
		rect(player.x+10,cam_y+45,cam_y+50,70,5)
	end
		
//print(⬆️⬇️⬅️➡️)
//print(spr(1-4)(1-2))
	
	print("choose your character", 20,cam_y+10,15)
	print("press ⬆️ to enter",2,cam_y+110,15)
	print("press z to start game",2,cam_y+120,15)


end

   
   
--[4]
function draw_hud()
 cls()
 
   //timer section
	
	local curt_t =flr(t*10)/10
	local formatted_t = curt_t..""
	if(curt_t%1==0)formatted_t = formatted_t..".0"
		
  print("time:",2,cam_y+8,7)
	print(formatted_t,22,cam_y+8,7)
   
   // distance section
   
 distance() 
 local dis = flr(player_highest/10)..""
	print("distance:",2,cam_y+2,7)
 print(dis,38,cam_y+2,7)
 
	x_view = player.x-30
	y_view = player.y +position()



	
	
	if y_view > cam_y+8 then
		clip_previous = y_view
		y_view = -cam_y+player.y+position()-10
	end

 //draw entities 
	clip(x_view, y_view,70,50,clip_previous)
 	background()
	player_draw()  
	platform_draw(platform1)
	platform_draw(platform2)
	platform_draw(platform3)
	platform_draw(platform4)
	spawn_enemy(rock)	
	clip()


end

function background() 
	rectfill(0,127,127,127,5)
	rectfill(cam_y+50,cam_y,128,128,5)
end


--[5]
function draw_gameover()
	cls()
	
 	//create_txt("game over",2,cam_y+20,rnd(14))
 	print("game over",2,cam_y+20,6)
end

  


-->8
-----------player---------------
player={x=64,y=64,width=15,
        height=15,speed=1.2,
        right=false,//if the player is facing right
        bounce=-20}//how high player bounce
player_highest=player.y-128
        
air_time=0 //time between last bounce
gravity=3
function position()
 return player.bounce*air_time+gravity/2*air_time^2
end



function player_move()
	if btn(➡️) and player.x+player.width<127 then
	 player.x+=player.speed
	 right=true
	elseif btn(⬅️) and player.x>0 then
		player.x-=player.speed
		right=false
	end
end


function player_draw()

// (debug) player boundary 
	rect(player.x+2,
	player.y+2+position(),
	player.x+-1+player.width,
	player.y+-1+player.height+position(),7)

//player sprite
	if right == false then
	 spr(1,player.x,player.y+position(),2,2)
	else     
	 spr(1,player.x,player.y+position(),2,2,true)
 end		
end

function distance() 
	if player.y+position() < -player_highest then
	 player_highest=-(player.y+position())
	end
end

function clip_update()


end


-->8
----------platform--------------
--be sure to add collision() and
--platform_draw() into script 0
--for every new platform added

--platform types (t):
--normal = 1
--breakable = 2
--super jump = 3

--tb (times bounced)

// for debugging
flag = false
//

platform1={x=player.x+player.width-14,
											y=player.y+player.height,
											t=1,tb=0}

platform2={x=player.x+player.width-54,
											y=player.y+player.height-30,
											t=1,tb=0}

platform3={x=player.x+player.width-34,
											y=player.y+player.height-60,
											t=3,tb=0}

platform4={x=player.x+player.width-24,
											y=player.y+player.height-80,
											t=2,tb=0}

platform_width=20
plat_highest=platform1.y



function platform_draw(platform)
 if platform.y<plat_highest then
  plat_highest=platform.y
 end
         
	if platform.t == 1 or 
	   platform.t == 2 then
  rect(platform.x,platform.y,
	 platform.x+platform_width,
	 platform.y,7)
	 if platform.t == 2 and
	        platform.tb>0 then
	  spr(32,platform.x,platform.y)
	  spr(32,platform.x+10,platform.y)
	 end
	else if platform.t == 3 then
	 rect(platform.x,platform.y,
	 platform.x+platform_width,
	 platform.y,12)
	end
	end
	
end 


function plat_redraw(platform)
	if (platform.y>cam_y+128) then
		platform.x=rnd(128-platform_width)
  platform.y=cam_y-rnd(10)
  
 //limit for distance btwn platforms 
  if platform.y<plat_highest-60 then
		 platform.y=plat_highest-60
		 
//		 flag=true //for debug		
		end
		
	//chance to change type
	//breakable --> 1/2 chance
	//superjump --> 1/20 chance		
	 if flr(rnd(2)) == 0 then
			if flr(rnd(10)) == 0 then
				platform.t=3
			else
			 platform.t=2
   end
		else
			platform.t=1
		end
	
		platform.tb=0	//reset # of bounces
		
	end
end

function collision(platform)
									
	if player.y+player.height+position()>platform.y
				and player.y+player.height/1.2 //<--increase num to make jump on 
				    +position()<platform.y 		//			platform more forviving but num must be >1
	   and player.x+player.width>=platform.x
			 and player.x<=platform.x+platform_width
			 and air_time>13.3/2 --13.3 is the time it takes to make one complete bounce-- 
			 then
		
		air_time=0
		platform.tb+=1
		
	 if platform.t == 2 then
	 	if platform.tb>1 then
	 	 platform.y=cam_y+129
	 	 sfx(2)
	 	end
	 end
	
		if platform.t == 3 then
		 player.bounce=-30
		 sfx(1)
		else
		 player.bounce=-20
		 sfx(0)
		end
		--reset player pos to current platform
		player.y=platform.y-player.height  
	
	end
end
-->8
--------enemies/obstacles-------
//id is for functions to recognize
//different objects

rock={x=player.x+10,
      y=player.y-150,
      width=5,
      height=5,
      speed=5,id=1}



function spawn_enemy(e)
 
 if e.id==1 then
  rock_fall(e)
 end
	
	hit(e)
	
	//boundary for collision
	
	//e.x=rnd(128-platform_width)
	//e.y=player.y-180
	
end

function rock_fall(e)
	if e.y<cam_y+128 then
	 e.y+=0.2
	 if e.y+e.height<cam_y then
 	 spr(48,e.x,cam_y) //warning sprite
  else
  	spr(33,e.x,e.y)
  	
  	//boundary for collision
	  rect(e.x+2,e.y+2,
	     e.x+e.width,e.y+e.height,7)


  end 
 
 end
end

function hit(e)
--[[ 
 if player.x>e.x+e.width
 and player.x+player.width<e.x
 and player.y+position()>e.y+e.height
 and player.y+player.height+posision()<e.y then
]]
 	if player.y+player.height+position()>=e.y+2
				and player.y+1+position()<=e.y+e.height
	   and player.x+1+player.width>=e.x+2
			 and player.x<=e.x+e.width then
 gameover=true
 sfx(3)
 end 
	
end
-->8
------sound/music library------
--[[

--general
sfx(0) --> jump 
sfx(1) --> super jump
sfx(2) --> platform breaking

--game over
sfx(3) --> hit (enemy/obstacle)
sfx(4) --> fall off screen

]]
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000022220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000002ffff2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000002ffffff200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000028f8fffff20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007002f8f8f2fff22000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000002fffff2f2f2f200200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000efffff2f2fff22200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000effffffffffff2200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000002ffffffffffff2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000002ffffffffffff2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000002fffffffffff20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000002fffffffffff20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000022fff222fff200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000022f2022ff2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000022000220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0060060600499f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000044449f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000444444990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000444444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000444444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000444444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000044444900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000004449000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00088000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00088000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100001f0501f0501f0502105022050230502305024050250502805028050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0002000026550245502355023550295502c55030550315502e5002e5002d5002b5000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
000200002465017650116500d6500b65009650076500565000000000002ae002ae000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00030000212501b250182500025001250002500125000250002000120000200002000020016200002000020029200002000020000200002000020000200002000020000200002000020000200002000020000200
000d00003f0403e0403d0403c0303b0303a020390203801037010360103501034010330103201031010300102f0102e0100060000600006000060000600006000060000600006000062000620006200060000600
