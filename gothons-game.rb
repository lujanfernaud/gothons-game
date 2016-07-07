# gothons-game.rb - Gothons from Planet Percal #25
# Learn Ruby The Hard Way - Exercise 43
# http://learnrubythehardway.org/book/ex43.html
# Initial code and text by Zed Shaw

class Scene
	def enter
		puts "This scene is not yet configured. Subclass it and implement enter."
		exit(1)
	end

  # Puts available actions if the user asks for them.
  def if_actions
    if @action == 'actions'
    	i = 0

    	@actions.each do |action|
    		i += 1
    		puts "#{i}. #{action}"
    	end

    	puts "\n"
    	print "> "
    	@action = $stdin.gets.chomp
    	puts "\n"
    end
  end
end

class Engine

	def initialize(scene_map)
		@scene_map = scene_map
	end

	def play
		# Sets the opening scene to current_scene.
		current_scene = @scene_map.opening_scene
		# Sets the 'finished' scene as last_scene.
		last_scene = @scene_map.next_scene('finished')

		# While current_scene is different than last_scene, enter the current scene
		# and save it in next_scene_name. Then use next_scene_name as current_scene
		# and check again.
		while current_scene != last_scene
			next_scene_name = current_scene.enter
			current_scene = @scene_map.next_scene(next_scene_name)
		end

		# Be sure to print out the last scene. This is going to be for 'finished',
		# the very last scene.
		current_scene.enter
	end
end

class Death < Scene
	# Create class variable @@quips, so it can be accesible in every Scene (check this).
	@@quips = [
					    "You died. You kinda suck at this.",
					    "You died. Such a luser.",
					    "I have a small puppy that's better at this."
					]

	def enter
		puts @@quips[rand(0..(@@quips.length - 1))]
		exit(1)
	end
end

class CentralCorridor < Scene
	
	def enter
		puts "\n"
    puts "The Gothons of Planet Percal #25 have invaded your ship and destroyed"
    puts "your entire crew.  You are the last surviving member and your last"
    puts "mission is to get the neutron destruct bomb from the Weapons Armory,"
    puts "put it in the bridge, and blow the ship up after getting into an "
    puts "escape pod."
    puts "\n"
    puts "You're running down the central corridor to the Weapons Armory when"
    puts "a Gothon jumps out, red scaly skin, dark grimy teeth, and evil clown costume"
    puts "flowing around his hate filled body.  He's blocking the door to the"
    puts "Armory and about to pull a weapon to blast you."
    puts "\n"
    puts "To see available actions type: actions"
    puts "\n"
    print "> "

    @actions = ["shoot!", "dodge!", "tell a joke"]
    @action = $stdin.gets.chomp
    puts "\n"

    # Jump to next scene (for testing purposes).
    if @action == "next!"
      return 'laser_weapon_armory'
    end

    # Check if the user wrote 'actions'.
	  if_actions

    case @action
		  when "shoot!"
		  	puts "Quick on the draw you yank out your blaster and fire it at the Gothon."
		    puts "His clown costume is flowing and moving around his body, which throws"
		    puts "off your aim. Your laser hits his costume but misses him entirely. This"
		    puts "completely ruins his brand new costume his mother bought him, which"
		    puts "makes him fly into an insane rage and blast you repeatedly in the face until"
		    puts "you are dead. Then he eats you."
        puts "\n"
		    'death'
		  when "dodge!"
		    puts "Like a world class boxer you dodge, weave, slip and slide right"
		    puts "as the Gothon's blaster cranks a laser past your head."
		    puts "In the middle of your artful dodge your foot slips and you"
		    puts "bang your head on the metal wall and pass out."
		    puts "You wake up shortly after only to die as the Gothon stomps on"
		    puts "your head and eats you."
        puts "\n"
		    'death'
		  when "tell a joke"
		   	puts "Lucky for you they made you learn Gothon insults in the academy."
        puts "\n"
		    puts "You tell the one Gothon joke you know:"
		    puts "Lbhe zbgure vf fb sng, jura fur fvgf nebhaq gur ubhfr, fur fvgf nebhaq gur ubhfr."
		    puts "\n"
        puts "The Gothon stops, tries not to laugh, then busts out laughing and can't move."
		    puts "While he's laughing you run up and shoot him square in the head"
		    puts "putting him down, then jump through the Weapon Armory door."
        puts "\n"
		    'laser_weapon_armory'
		  else
		  	puts "DOES NOT COMPUTE!"
		  	'central_corridor'
    end
  end
end

class LaserWeaponArmory < Scene
	
	def enter
    puts "You do a dive roll into the Weapon Armory, crouch and scan the room"
    puts "for more Gothons that might be hiding. It's dead quiet, too quiet."
    puts "You stand up and run to the far side of the room and find the"
    puts "neutron bomb in its container."
    puts "\n"
    puts "There's a keypad lock on the box and you need the code to get the bomb out."
    puts "If you get the code wrong 6 times then the lock closes forever"
    puts "and you can't get the bomb."
    puts "\n"
    puts "The code is 3 digits."
    puts "\n"
    puts "To get a hint type: help (only 1 chance)"

    code = "#{rand(1..9)}#{rand(1..9)}#{rand(1..9)}"
    puts "\n"
    print "[keypad]> "
    guess = $stdin.gets.chomp
    puts "\n"
    guesses = 0

    # Jump to next scene (for testing purposes).
    if guess == "next!"
      return 'the_bridge'
    end

    # Gives a hint when the user writes 'help'.
    if guess == "help"
    	asterisk = rand(0..1)
      # We want to know which round we are in in the loop.
      # If we are in round 3 and we have asterisk = 0 (the previous character is a number),
      # then we put another number. Otherwise we would have two asterisks and it would be
      # too difficult to guess the number.
      round = 0

    	hint = code.split("").collect do |n|
        round += 1
    		# If there's an asterisk (asterisk = 1), it puts a number and sets asterisks to 0,
    		# else it puts an asterisk and sets asterisk to 1. This way we alternate them.
    		if asterisk == 1
    			asterisk = 0
    			n
        elsif asterisk == 0 && round == 3
          n
    		else
    			asterisk = 1
    			'*'
    		end
    	end
    	puts "Hint: #{hint.join}"
    	puts "\n"
    	print "[keypad]> "
    	guess = $stdin.gets.chomp
    	puts "\n"
  	end

		while guess != code && guesses < 6
    	puts "BZZZZEDDD!"
    	guesses += 1
    	puts "\n"
    	print "[keypad]> "
    	guess = $stdin.gets.chomp
    	puts "\n"
    end

    if guess == code
        puts "CLICK!"
        puts "\n"
    	  puts "The container clicks open and the seal breaks, letting gas out."
        puts "\n"
        puts "You grab the neutron bomb and run as fast as you can to the"
        puts "bridge where you must place it in the right spot."
        puts "\n"
        'the_bridge'
    else
    	  puts "The lock buzzes one last time and then you hear a sickening"
        puts "melting sound as the mechanism is fused together."
        puts "You decide to sit there, and finally the Gothons blow up the"
        puts "ship from their ship and you die."
        puts "\n"
        'death'
    end
	end
end

class TheBridge < Scene

	def enter
    puts "You burst onto the Bridge with the netron destruct bomb"
    puts "under your arm and surprise 5 Gothons who are trying to"
    puts "take control of the ship. Each of them has an even uglier"
    puts "clown costume than the last. They haven't pulled their"
    puts "weapons out yet, as they see the active bomb under your"
    puts "arm and don't want to set it off."
    puts "\n"
    puts "To see available actions type: actions"
    puts "\n"

    print "> "
    @actions = ["throw the bomb", "slowly place the bomb"]
    @action = $stdin.gets.chomp
    puts "\n"

    # Jump to next scene (for testing purposes).
    if @action == "next!"
      return 'escape_pod'
    end

    # Check if the user wrote 'actions'.
    if_actions

    case @action
	    when "throw the bomb"
	    	puts "In a panic you throw the bomb at the group of Gothons"
	      puts "and make a leap for the door. Right as you drop it a"
	      puts "Gothon shoots you right in the back killing you."
        puts "\n"
	      puts "As you die you see how another Gothon frantically try to disarm"
	      puts "the bomb. You die knowing they will probably blow up when"
	      puts "it goes off."
        puts "\n"
	      'death'
	    when "slowly place the bomb"     	 
	    	puts "You point your blaster at the bomb under your arm"
	      puts "and the Gothons put their hands up and start to sweat."
	      puts "You inch backward to the door, open it, and then carefully"
	      puts "place the bomb on the floor, pointing your blaster at it."
	      puts "You then jump back through the door, punch the close button"
	      puts "and blast the lock so the Gothons can't get out."
	      puts "Now that the bomb is placed you run to the escape pod to"
	      puts "get off this tin can."
        puts "\n"
	      'escape_pod'
	    else
	    	puts "DOES NOT COMPUTE!"
        puts "\n"
	    	'the_bridge'
    end
	end
end

class EscapePod < Scene

	def enter
		puts "You rush through the ship desperately trying to make it to"
    puts "the escape pod before the whole ship explodes. It seems like"
    puts "hardly any Gothons are on the ship, so your run is clear of"
    puts "interference. You get to the chamber with the escape pods, and"
    puts "now need to pick one to take. Some of them could be damaged"
    puts "but you don't have time to look."
    puts "\n"
    puts "There are 5 pods, which one do you take?"
    puts "\n"
    puts "To get a hint type: help (only 1 chance)"
    puts "\n"

    @good_pod = rand(1..5).to_s
    print "[pod #]> "
    guess = $stdin.gets.chomp
    puts "\n"

    # Give a hint of 3 numbers when the user ask for help.
    if guess == 'help'
      def give_hint
        # Put the number in @good_pod into an array.
        good_pod_number = [@good_pod.to_i]
        # Create an array with numbers 1 to 5. 
        one_to_five = [*1..5]
        # Take the good pod number out of the one_to_five array and
        # store the resulting array in 'hint'.
        hint = one_to_five - good_pod_number
        # Randomly generate 0 or 1 (true or false).
        num = rand(0..1)
        # Delete the first or last element of the 'hint' array.
        if num == 0
          hint.shift
        else
          hint.pop
        end

        # Convert hint array to string.
        hint.join(", ")
      end
      
      puts "Hint: A number that is not: #{give_hint}"
      puts "\n"
      print "[pod #]> "
      guess = $stdin.gets.chomp
      puts "\n"
    end

    if guess != @good_pod
    	puts "You jump into pod %s and hit the eject button." % guess
      puts "\n"
      puts "The pod escapes out into the void of space, then"
      puts "implodes as the hull ruptures, crushing your body"
      puts "into jam jelly."
      puts "\n"
      'death'
    else
    	puts "You jump into pod %s and hit the eject button." % guess
      puts "\n"
      puts "The pod easily slides out into space heading to"
      puts "the planet below. As it flies to the planet, you look"
      puts "back and see your ship implode then explode like a"
      puts "bright star, taking out the Gothon ship at the same"
      puts "time."
      puts "\n"
      'finished'
    end
	end
end

class Finished < Scene
  
	def enter
		puts "YOU WON! Good job!"
	end
end

class Map
	@@scene = {
		'central_corridor' => CentralCorridor.new,
		'laser_weapon_armory' => LaserWeaponArmory.new,
		'the_bridge' => TheBridge.new,
		'escape_pod' => EscapePod.new,
		'death' => Death.new,
		'finished' => Finished.new
	}

	def initialize(start_scene)
		@start_scene = start_scene
	end

	def next_scene(scene_name)
		val = @@scene[scene_name]
		val
	end

	def opening_scene
		next_scene(@start_scene)
	end
end

a_map = Map.new('central_corridor')
a_game = Engine.new(a_map)
a_game.play