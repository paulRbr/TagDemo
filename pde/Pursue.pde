import java.lang.System;

/*
* The Pursue Steering Behaviour
*/
class Pursue extends Steering {

  // Target
  Agent target;
  
  // Initialisation
  Pursue(Agent h, Agent p) {
      super(h);
      this.target = p;
  }
  
  PVector calculateRawForce() {

      // Check that agent's centre is not over target
      if (PVector.dist(agent.position, target.position) > target.radius) {
        // Time to target formula for the look-ahead time
        PVector distV = PVector.sub(agent.position, target.position);
        float distance = distV.mag();
        float tpred = distance / this.agent.velocity.mag();
        float tlim = 5;
        // Calculate min (tpred, tlim)
        float min = min(tpred, tlim);
        PVector qpred = PVector.mult(this.target.velocity, min);
        qpred.add(target.position);
        // We have qpred, now we do Seek(qpred)
        PVector pursue = PVector.sub(qpred, agent.position);
 	// - fix without boundaries -
	if (!TagDemo.boundaries
	    && (agent.position.dist(qpred)
		!= TagDemo.myDist(agent.position, qpred, width, height))) {
	    pursue = PVector.sub(agent.position, qpred);
	}
	// --------------------------
        pursue.normalize();
        pursue.mult(agent.maxSpeed);
        pursue.sub(agent.velocity);
        return pursue;
      } else  {
        // If agent's centre is over target then the hunter caught the prey
        return new PVector(0,0);
      }   
  }
  
  // Draw the target
  void draw() {
     pushStyle();
     fill(204, 153, 0);
     ellipse(target.position.x, target.position.y, target.radius, target.radius);
     popStyle();
  }

  void setTarget(Agent target) {
      this.target = target;
  }
}
