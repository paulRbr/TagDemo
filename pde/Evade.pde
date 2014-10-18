/*
 * The Evade Steering Behaviour
 */
class Evade extends Steering {

    Agent target;

    public Evade(Agent p, Agent h) {
       super(p);
       this.target = h;
    }

    PVector calculateRawForce() {
        // Check that agent's centre is not over target
        if (PVector.dist(agent.position, target.position) > target.radius) {
            // Time to target formula for the look-ahead time
            PVector distV = PVector.sub(target.position, agent.position);
            float distance = distV.mag();
            float tpred = distance / target.velocity.mag();
            float tlim = distance;
            // Calculate min (tpred, tlim)
            float min = min(tpred, tlim);
            PVector qpred = PVector.mult(target.velocity, min);
            qpred.add(target.position);
            // We have qpred, now we do Flee(qpred)
            PVector evade = PVector.sub(agent.position, qpred);
	    // - fix without boundaries -
	    if (!TagDemo.boundaries
		&& agent.position.dist(qpred)
		> TagDemo.myDist(agent.position, qpred, width, height)) {
		evade = PVector.sub(qpred, agent.position);
	    }
	    // --------------------------
            evade.normalize();
            evade.mult(agent.maxSpeed);
            evade.sub(agent.velocity);
            return evade;
        } else  {
            // If agent's centre is over target stop pursuing, the hunter caught the prey
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
