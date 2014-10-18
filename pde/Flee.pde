/*
 * The Flee Steering Behaviour
 */
class Flee extends Steering {
  
  // Target
  Agent hunter;

    // Initialisation
  Flee(Agent a, Agent hunter) {
      super(a);
      this.hunter = hunter;
  }

  PVector calculateRawForce() {
      // Check that agent's centre is not over target
      if (PVector.dist(hunter.position, agent.position) > hunter.radius) {
        // Calculate Flee Force
	PVector flee = PVector.sub(agent.position, hunter.position);
	// - fix without boundaries -
 	float d = agent.position.dist(hunter.position);
	float nd = TagDemo.myDist(agent.position, hunter.position, width, height); 
	if (!TagDemo.boundaries
	    && (abs(d - nd) > 0.2)) {
	    flee = PVector.sub(hunter.position, agent.position);
	}
	// --------------------------
        flee.normalize();
        flee.mult(agent.maxSpeed);
        flee.sub(agent.velocity);
        return flee;
      } else  {
        // If agent's centre is over target stop fleeing
        return new PVector(0,0); 
      }   
  }
  
  // Draw the target
  void draw() {
     pushStyle();
     fill(204, 153, 0);
     ellipse(hunter.position.x, hunter.position.y, hunter.radius, hunter.radius);
     popStyle();
  }

  void setTarget(Agent target) {
      this.hunter = target;
  }

}
