class ParticleSystem
{
  ArrayList<Particle> particles;
  int n = 5;  // Number of balls
  
  ParticleSystem()
  {
    particles = new ArrayList<Particle>();
    
    for (int i = 0; i < n; i++)
    {
      // Output speed (random)
      PVector initVel = new PVector(random(-200, 400), random(-200, 400));
      
      // Start position (random)
      PVector initPos = new PVector(random(100, worldToPixels(2.85)), random(100, worldToPixels(1.42)));
      
      // The particle is added
      addParticle(i, initPos, initVel, mass, worldToPixels(radius));
    }
  }
  
  void addParticle(int id, PVector initPos, PVector initVel, float m, float r) 
  { 
    particles.add(new Particle(this, id, initPos, initVel, m, r));
  }
  
  void restart()
  {
  }
  
  int getNumParticles()
  {
    return n;
  }
  
  ArrayList<Particle> getParticleArray()
  {
    return particles;
  }
  
  void run() 
  {
    for (int i = 0; i < n; i++) 
    {
      Particle p = particles.get(i);
      p.update();
    }
  }
  
  void computeCollisions(ArrayList<PlaneSection> planes, boolean planeCollision) 
  {
    for (int i = 0; i < n; i++)
    {
      Particle p = particles.get(i);
      p.planeCollision(planes);
      
      if (planeCollision) 
        p.particleCollisionVelocityModel();
     }
  }
  
  void display() 
  {
    for (int i = n - 1; i >= 0; i--) 
    {
      Particle p = particles.get(i);      
      p.display();
    }
  }
}
