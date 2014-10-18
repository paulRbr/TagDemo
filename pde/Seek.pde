/*
 * The Seek Steering Behaviour
 */
class Seek extends Steering {
  
  // Target
  Agent prey;
  
  // Initialisation
  Seek(Agent a, Agent prey) {
      super(a);
      this.prey = prey;
  }
  
  PVector calculateRawForce() {
      // Check that agent's centre is not over target
      if (PVector.dist(prey.position, agent.position) > prey.radius) {
        // Calculate Seek Force
	PVector seek = PVector.sub(prey.position, agent.position);
 	// - fix without boundaries -
 	float d = agent.position.dist(prey.position);
	float nd = TagDemo.myDist(agent.position, prey.position, width, height); 
	if (!TagDemo.boundaries
	    && (abs(d - nd) > 0.2)) {
	    seek = PVector.sub(agent.position, prey.position);
	}
	// --------------------------
        seek.normalize();
        seek.mult(agent.maxSpeed);
        seek.sub(agent.velocity);
        return seek;
      } else  {
        // If agent's centre is over target stop seeking, the hunter caught the prey
        return new PVector(0,0);
      }   
  }
  
  // Draw the target
  void draw() {
     pushStyle();
     fill(204, 153, 0);
     ellipse(prey.position.x, prey.position.y, prey.radius, prey.radius);
     popStyle();
  }

  void setTarget(Agent target) {
      this.prey = target;
  }
}
