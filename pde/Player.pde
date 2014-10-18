/*
* A Player Agent for game of tag which can use Arrive or Flee steering behaviour.
*/
class Player extends Agent {
   
    // Who's 'it'?
    Player it;
    // Useful when he's 'it'
    Player nearest;

    String name = "";

    // Distance after which the agent wander (instead of fleeing from 'it')
    final static float WANDER_DIST = 300;

    public Player(float m, float r, PVector p, Player _it, String _name) {
        super(m, r, p);
	it = _it;
	nearest = null;
	name = _name;
    }

    // No it specified, so i'm 'it'
    public Player(float m, float r, PVector p, String _name) {
        super(m, r, p);
	it = this;
	nearest = null;
	name = _name;
    }

    // I have been touched
    // by it?
    // Update It both ways
    boolean touchedByIt(Player a) {
	boolean res = false;

	if (this == it) {
	    // I'm not 'it' anymore, let's flee away
	    it = a;
	    a.it = a;
	    res = true;
	} else if (a == it) {
	    // I've been touched by 'it', now I'm 'it'!
	    it = this;
	    a.it = this;
	    res = true;
	}
	
	return res;
    }

    // Detect Collision and report if 'it' has touched someone
    boolean collisionDetection(ArrayList<Player> others) {
	boolean itTouched = false;
	for (Player player : others) {
	    // detect collision with other players than me
	    float d = position.dist(player.position);
	    // COLLISION
	    if (d < radius+player.radius) {
		itTouched = touchedByIt(player);
		if (itTouched) {
		    // 'It' has changed
		    // Start as 'it' with a slight disadvantage
		    // i.e. no speed		   
		    if (it == this) {
			velocity.set(0, 0, 0);
		    } else {
			player.velocity.set(0, 0, 0);
		    }
		}
		
		// Dead stop on collision
		// velocity = new PVector(0,0);
		// player.velocity = new PVector(0,0);
			
		// opposite directions when two player touched
		velocity.set(PVector.sub(position, player.position));
		velocity.normalize();
		player.velocity.set(PVector.sub(player.position, position));
		player.velocity.normalize();	
	    }
	}

	return itTouched;
    }

    // Change Steering Behaviour
    void changeBehaviour(Steering behaviour) {
	behaviours.clear();
	behaviours.add(behaviour);
    }
    
    void broadcastNewIt(ArrayList<Player> all) {
	for (Player p : all) {
	    if (p != it) {
		p.it = it;
		changeBehaviour(new Flee(p, it));
	    }
	}
    }

    // To-Do: Depending on boundaries present or not
    // Change the calculation of nearest!
    void updateNearestToMe(ArrayList<Player> all) {
	Player newNearest = null;
	float minDist = Number.POSITIVE_INFINITY;
	for(Player p : all) {
	    if (p != this) {
		float d = 0;
		if (TagDemo.boundaries) {
		    d = position.dist(p.position);
		} else {
		    d = TagDemo.myDist(position, p.position, width, height);
		}
		if (d < minDist) {
		    minDist = d;
		    newNearest = p;
		}
	    }
	}
	// DEBUG
	// if (name.equals("A")) 
	//     System.out.println(newNearest.name + ": myDist="+minDist+"; dist="+position.dist(newNearest.position));
	// END DEBUG
	if (newNearest != nearest) {
	    nearest = newNearest;
	    changeBehaviour(new Seek(this, nearest));
	}
    }
    
    void update(ArrayList<Player> remainings, ArrayList<Player> all) {
	// CollisionDetection with all the remaining players
	boolean itHasTouched = collisionDetection(remainings);
	if (itHasTouched) {
	    // 'It' has touched
	    broadcastNewIt(all);
	}

	// If I'm 'it' check where is the nearest player
	if (it == this) {
	    updateNearestToMe(all);
	} else {
	    // Wander around if we are far from 'it'
	    if (it.position.dist(position) > WANDER_DIST) {
		changeBehaviour(new Wander(this, 30, 60, 100));
	    } else {
		changeBehaviour(new Flee(this, it));
	    }
	}

	//System.out.println(name+" : it = "+it.name);

	super.update();
    }

    void draw() {
	if (this == it) {
	    // Red coloring for 'it'
	    fill(210,20,20);
	} else {
	    fill(255);
	}
	super.draw();
	pushStyle(); // Push current drawing style onto stack
	fill(0);
	text(name, position.x-5, position.y+5);
	popStyle();
    }
}
