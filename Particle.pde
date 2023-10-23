class Particle //<>//
{
  ParticleSystem ps;
  int id;

  PVector s; // Position
  PVector v; // Velocity
  PVector a; // Accelaration
  PVector f; // Force

  float m;  // Mass
  float r;  // Radius
  color c;  // Color
  
  Particle(ParticleSystem _ps, int _id, PVector initPos, PVector initVel, float mass, float radius) 
  {
    ps = _ps;
    id = _id;

    s = initPos.copy();
    v = initVel.copy();
    a = new PVector(0.0, 0.0);
    f = new PVector(0.0, 0.0);

    m = mass;
    r = radius;
    c = color(random(255), random(255), random(255));
  }
  
  void setVelocity(PVector velocity)
  {
    v = velocity.copy();
  }

  // Update values using Symplectic Euler
  void update() 
  { 
    updateForce();
    PVector Ft = f.copy();
    
    a = PVector.div(Ft, m);
    v.add(PVector.mult(a, SIM_STEP));
    s.add(PVector.mult(v, SIM_STEP));    
  }

  // Calculate all the forces
  void updateForce()
  {
    if(!attraction)
      f = PVector.mult(v, -Kd);
    else
    {
      PVector Froz = PVector.mult(v, -Kd);
      PVector Fg = new PVector(10.0, 10.0);
    
      f = PVector.add(Froz, Fg);
    }
  }

  // Particle-plane collision model
  void planeCollision(ArrayList<PlaneSection> planes)
  { 
    float dC; // Collision distance
    PVector n1 = new PVector(); // Normal 1
    PVector n2 = new PVector(); // Normal 2

    PVector vS = new PVector(); // Output speed
    PVector vN = new PVector(); // Normal speed
    PVector vT = new PVector(); // Tangential speed
    
    PVector Prep = new PVector();
    float nv;
    
    for(int i = 0; i < planes.size(); i++)
    {
      if(planes.get(i).getDistance(s) <= r)
      {
        dC = r - planes.get(i).getDistance(s);
        
        // Repositioning
        n1 = planes.get(i).getNormal();
        n2 = PVector.mult(n1, -1);
        
        Prep = s.add(PVector.mult(n1,dC));
        s = Prep.copy();
        
        // Speed change
        // Get normal speed
        nv = v.dot(n2);
        
        // Speed decomposition (normal and tangential)
        vN = n2.mult(nv);
        vT = v.sub(vN);
        vS = vT.sub(vN);
        v = vS.copy();
      }
    }
  } 
  
  // Velocity collision model
  void particleCollisionVelocityModel()
  {   
    ArrayList<Particle> system = new ArrayList<Particle>(ps.getParticleArray());
    
    PVector vD = new PVector();    // Distance vector
    PVector unitD = new PVector(); //

    float d;    // Magnitude of the distance vector
    float dMin; // Minimum distance to occur the collision
    float rest; // Restitution
    float vrel; // 
    
    float u1, u2;  // 
    float v1, v2;  // Exit velocity of particles 1 and 2
    
    
    for(int i = id + 1; i < ps.getNumParticles(); i++)
    {
      Particle p = system.get(i);
      vD = PVector.sub(p.s, s);
      
      d = vD.mag();
      dMin = p.r + r;
      
      if(d < dMin)
      {
        unitD.set(vD);
        unitD.normalize();
        vD.normalize();
        
        PVector n1 = PVector.mult(unitD, (v.dot(vD)) );
        PVector t1 = PVector.sub(v, n1);
        
        PVector n2 = PVector.mult(unitD, (p.v.dot(vD)) );
        PVector t2 = PVector.sub(p.v, n2);
        
        rest = (r + p.r) - d;
        vrel = PVector.sub(n1, n2).mag();
        
        PVector S1 = PVector.mult(n1,-rest/vrel);
        s.add(S1);
        
        PVector S2 = PVector.mult(n2, -rest/vrel);
        p.s.add(S2);
        
        u1 = n1.dot(vD);
        u2 = n2.dot(vD);
        
        v1 = ((m - p.m) * u1 + 2 * p.m * u2) / (m + p.m);
        n1 = PVector.mult(vD, v1);
        
        v2 = ((p.m - m) * u2 + 2 * m * u1) / (m + p.m);
        n2 = PVector.mult(vD, v2);
        
        v = PVector.add(n1, t1);
        p.v = PVector.add(n2, t2);
      }
    }
  }
  
  
  void display() 
  {
    fill(c);
    stroke(0);
    strokeWeight(1);
    circle(s.x, s.y, 2.0*r);
  }
}
