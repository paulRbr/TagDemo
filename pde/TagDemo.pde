/*
 *
 * The TagDemo sketch
 *
 */

// Agents playing the game of tag
ArrayList<Player> agents;

// Are we paused?
boolean pause;
// Is this information panel being displayed?
boolean showInfo;

static class TagDemo {
    // Boundaries or torus map?
    static boolean boundaries = false;

    // Number of players in the game (>1)
    static int nbrPlayers = 10;

    // Name generator
    static char playerName = 'A';

    // Utils
    // Different distance calculation when torus map
    static float myDist(PVector p1, PVector p2, float w, float h) {
        float f = 0;
        return sqrt(
                    pow(min((p1.x-p2.x+w)%w,(p2.x-p1.x+w)%w),2)
                    +pow(min((p1.y-p2.y+h)%h,(p2.y-p1.y+h)%h),2)
                    );
    }
}

// Initialisation
void setup() {
  size(1000,600); // Large display window
  pause = false;
  showInfo = true;
    
  if (TagDemo.nbrPlayers < 2) {
      System.out.println("Should have at least 2 players!");
      exit();
  } else {
      // Initialise players and game
      // Create the agents and Add behaviours to each of them
      agents = new ArrayList<Player>();
      // Add agents to list of agents
      Player p = new Player(10, 10, randomPoint(), TagDemo.playerName+"");
      Steering behaviour = new Wander(p, 30, 60, 100);
      p.behaviours.add(behaviour);
      agents.add(p);
      
      for (int i = TagDemo.nbrPlayers-1; i>0; i--) {
	  addPlayer(p);
      }

      smooth(); // Anti-aliasing on
  }
}

void addPlayer(Player it) {
    TagDemo.playerName++;
    Player p = new Player(10, 10, randomPoint(), it, TagDemo.playerName+"");
    Steering behaviour = new Wander(p, 30, 60, 100);
    p.behaviours.add(behaviour);
    agents.add(p);
}

void removePlayer() {
    int i = 0;
    boolean ok = false;
    if (agents.size()>3) {
	while (!ok) {
	    Player p = agents.get(i);
	    if (p.it != p) {
		ok = true;
		agents.remove(i);
	}
	    i++;
	}
    }
}

// Pick a random point in the display window
PVector randomPoint() {
  return new PVector(random(width), random(height));
}

// The draw loop
void draw() {
  // Clear the display
  background(255); 

  ArrayList<Player> remainings = (ArrayList<Player>) agents.clone();
  int offSet = 0;
  while (!remainings.isEmpty()) {
      Player player = remainings.remove(0);
      if (!pause) {
	  player.update(remainings, agents);
      }
      
      // Draw the agents
      player.draw();      
  }
  
  // Draw the information panel
  if (showInfo) drawInfoPanel();

  // Draw Walls
  if (TagDemo.boundaries) drawBoundaries();
}

// Draw the information panel!
void drawInfoPanel() {
  pushStyle(); // Push current drawing style onto stack
  fill(0);
  ArrayList<String> infoPanel = buildInfoPanel();
  int yOffset= 0;
  for (String entry : infoPanel) {
     text(entry, 10, 20+yOffset);
     yOffset += 15; // Shift y position to display entries of the info panel
  }
  popStyle(); // Retrieve previous drawing style
}

// Build the information panel
ArrayList<String> buildInfoPanel() {
  ArrayList<String> res = new ArrayList<String>();
  res.add("1 - toggle display");
  res.add("2 - toggle annotation");
  res.add("3 - toggle boundaries (torus map or not)");
  res.add("+/- - add/remove a player");
  char c = 'A';
  for (Player player : agents) {
      res.add((c+"").toLowerCase()+"/"+c+" - inc/dec maxSpeed of player "+c+" ("+player.maxSpeed+")");
      c++;
  }
  return res;
}

//Draw boundaries
void drawBoundaries() {
  pushStyle();
  stroke(200, 20, 20);
  strokeWeight(4);
  line(0,0, width, 0);
  line(0,0, 0, height);
  line(width-1,0, width-1, height-1);
  line(0,height-1, width-1, height-1);
  popStyle();
}

/*
 * Input handlers
 */

// Key pressed
void keyPressed() {
    if (key == ' ') {
	togglePause();	
    } else if (key == '1' || key == '!') {
	toggleInfo();     
    } else if (key == '2' || key == '"') {
	for (Player player : agents) player.toggleAnnotate();
    } else if (key == '3' || key == '£') {
	toggleBoundaries();
    } else if (key == '+') {
	addPlayer(agents.get(0).it);
    } else if (key == '-') {
	removePlayer();
    }
    
   char c = 'A';
   for (Player player : agents) {
       if (key == (c+"").toLowerCase()) {
	   player.incMaxSpeed();
       } else if (key == c) {
	   player.decMaxSpeed();
       }
       c += 1; // Next player, new key
   }
}

// Toggle boundaries
void toggleBoundaries() {
    if (TagDemo.boundaries) {
	TagDemo.boundaries = false;
    } else {
	TagDemo.boundaries = true;
    } 
}

// Toggle the pause state
void togglePause() {
     if (pause) {
       pause = false; 
     } else {
       pause = true;
     }
}

// Toggle the display of the information panel
void toggleInfo() {
     if (showInfo) {
       showInfo = false; 
     } else {
       showInfo = true;
     }
}
