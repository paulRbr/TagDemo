/*
 * The Arrive Steering Behaviour
 */
class Arrive extends Steering {
  
  // Position/size of target
  Agent target;
  
  // Stopping distance
  float dstop;
  
  // Initialisation
  Arrive(Agent a, Agent t, float d) {
      super(a);
      target = t;
      dstop = d;
  }
  
  PVector calculateRawForce() {
      PVector origin = new PVector(0,0);
    
      // Check that agent's centre is not over target
      if (PVector.dist(target.position, agent.position) > target.radius) {
        // Calculate arrive Force
        PVector arrive = PVector.sub(target.position, agent.position);
 	// - fix without boundaries -
	if (!TagDemo.boundaries
	    && agent.position.dist(target.position)
	    > TagDemo.myDist(agent.position, target.position, width, height)) {
	    arrive = PVector.sub(agent.position, target.position);
	}
	// --------------------------

        float doff = arrive.dist(origin);
        arrive.normalize();
        float sigma = agent.maxSpeed;
        if (doff <= dstop)
          sigma *= doff/dstop;
        arrive.mult(sigma);
        arrive.sub(agent.velocity);
        return arrive;
        
      } else  {
        // If agent's centre is over target stop seeking
        return origin; 
      }   
  }
  
  // Vary stopping distance
  void incDstop() {    
    dstop++;
  }
  
  void decDstop() {    
    dstop--;
    if (dstop < 1) dstop = 1;
  }
  
  void setTarget(Agent newTarget) {
    target = newTarget;
  }
  

  // Draw the target
  void draw() {
     pushStyle();
     fill(204, 153, 0);
     ellipse(target.position.x, target.position.y, target.radius, target.radius);
     popStyle();
  }
}
