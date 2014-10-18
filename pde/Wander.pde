/*
 * The Wander Wandering Behaviour
 */
class Wander extends Steering {
  
  // Position of "random" target along the wander circle
  PVector target;
  PVector targetOffset;
  float targetJitter;
  
  float wanderRadius;
  float wanderDistance;
  PVector wanderCenter;
  
  // Should we draw the wandering circle?
  boolean annotate;

  // Boundaries or torus map?
  boolean boundaries;
  
  // Initialisation
  Wander(Agent a, float alph, float wRadius, float wDist) {
      super(a);
      targetJitter = alph;
      wanderRadius = wRadius;
      wanderDistance = wDist;
      
      // Initialise first target
      targetOffset = new PVector(0,0); 
      updateTarget(); // Initiate first target: q = pw + c
      
      // Don't draw annotations
      annotate = false;
      // Torus map to start with
      boundaries = false;
  }
  
  PVector calculateRawForce() {
      // each time step we change target and wander circle's center
      updateTarget();

      // Calculate Wander Force
      PVector wander = PVector.sub(target, agent.position);
      wander.normalize();
      wander.mult(agent.maxSpeed);
      wander.sub(agent.velocity);
      return wander;
  }
    
  // Calculate new target q = pw + c
  void updateTarget() {
      updateWanderCenter(); // Update pw
      PVector temp = randomDirection();
      temp.mult(targetJitter);
      targetOffset.add(temp);
      targetOffset.normalize();
      targetOffset.mult(wanderRadius);
      
      target = PVector.add(wanderCenter,targetOffset); // q = pw + c
  }
  
  // Calculate new wander center pw
  void updateWanderCenter() {
      wanderCenter = new PVector(0,0);
      agent.velocity.normalize(wanderCenter);
      wanderCenter.mult(wanderDistance);
      wanderCenter.add(agent.position);
  }
  
  // Random x and y between -1 and 1
  PVector randomDirection() {
      return new PVector(random(-1,1), random(-1,1));
  }
    
  // Vary jitter
  void incTargetJitter() {    
    targetJitter++;
  }
  void decTargetJitter() {    
    targetJitter--;
    if (targetJitter < 1) targetJitter = 1;
  }
  
  // Vary wander radius
  void incWanderRadius() {    
    wanderRadius++;
  }
  void decWanderRadius() {    
    wanderRadius--;
    if (wanderRadius < 1) wanderRadius = 1;
  }
  
  // Vary wander Distance
  void incWanderDistance() {    
    wanderDistance++;
  }
  void decWanderDistance() {    
    wanderDistance--;
    if (wanderDistance < 1) wanderDistance = 1;
  }
  
  // Draw the target
  void draw() {
    // Draw wander circle if required
    if (annotate) {
      pushStyle();
     
      if (boundaries) {
        fill(230, 230, 230);
        ellipse(wanderCenter.x, wanderCenter.y, 2*wanderRadius, 2*wanderRadius);
        fill(204, 153, 0);
        ellipse(target.x, target.y, 2, 2);
      } else {
        float tempWanderX = wanderCenter.x;
        float tempWanderY = wanderCenter.y;
        float tempTargetX = target.x;
        float tempTargetY = target.y;
        if (tempWanderX <= 0) {
          tempWanderX += width;
        } else if (tempWanderX >= width) {
          tempWanderX -= width;
        }
        // horizontal boundaries    
        if (tempWanderY <= 0) {
          tempWanderY += height;
        } else if (tempWanderY >= height) {
          tempWanderY -= height;
        }
        fill(230, 230, 230);
        ellipse(tempWanderX, tempWanderY, 2*wanderRadius, 2*wanderRadius);
        if (tempTargetX <= 0) {
          tempTargetX += width;
        } else if (tempTargetX >= width) {
          tempTargetX -= width;
        }
        // horizontal boundaries    
        if (tempTargetY <= 0) {
          tempTargetY += height;
        } else if (tempTargetY >= height) {
          tempTargetY -= height;
        }
        fill(204, 153, 0);
        ellipse(tempTargetX, tempTargetY, 2, 2);
      }
      popStyle();
    }
  }
  
    // Toggle annotations
  void toggleAnnotate() {
    if (annotate) {
       annotate = false;
    } else {
       annotate = true;
    } 
  }
    // Toggle boundaries
  void toggleBoundaries() {
    if (boundaries) {
       boundaries = false;
    } else {
       boundaries = true;
    } 
  }
  
  // Unused method for this behaviour..
  void setTarget(Agent target) {    
  }
}
