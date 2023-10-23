class PlaneSection
{
  PVector pos1;
  PVector pos2;
  PVector normal;
  
  float[] coefs = new float[4];
  
  // Constructor to make a plane from two points (assuming Z = 0)
  // The two points define the edges of the finite plane section
  PlaneSection(float x1, float y1, float x2, float y2, boolean invert) 
  {
    pos1 = new PVector(x1, y1);
    pos2 = new PVector(x2, y2);
    
    setCoefficients();
    calculateNormal(invert);
  } 
  
  PVector getPoint1()
  {
    return pos1;
  }
 
  PVector getPoint2()
  {
    return pos2;
  }
  
  void setCoefficients()
  {
    PVector v = new PVector(pos2.x - pos1.x, pos2.y - pos1.y, 0.0);
    PVector z = new PVector(pos2.x - pos1.x, pos2.y - pos1.y, 1.0);
    
    coefs[0] = v.y * z.z - z.y * v.z;
    coefs[1] = - (v.x * z.z - z.x * v.z);
    coefs[2] = v.x * z.y - z.x * v.y;
    coefs[3] = - coefs[0] * pos1.x - coefs[1] * pos1.y - coefs[2] * pos1.z;
  }
  
  void calculateNormal(boolean inverted)
  {
    normal = new PVector(coefs[0], coefs[1], coefs[2]);
    normal.normalize();
    
    if (inverted)
      normal.mult(-1);
  }
  
  float getDistance(PVector p)
  {
    float d = (coefs[0]*p.x + coefs[1]*p.y + coefs[2]*p.z + coefs[3]) / (sqrt(coefs[0]*coefs[0] + coefs[1]*coefs[1] + coefs[2]*coefs[2]));
    return abs(d);
  }
  
  PVector getNormal()
  {
    return normal;
  }
  
  void draw() 
  {
    stroke(0, 0, 0);
    strokeWeight(5);
    
    // Plane representation:
    line(pos1.x, pos1.y, pos2.x, pos2.y); 
    
    float cx = pos1.x*0.5 + pos2.x*0.5;
    float cy = pos1.y*0.5 + pos2.y*0.5;
    
    // Normal vector representation:
    line(cx, cy, cx + 5.0*normal.x, cy + 5.0*normal.y);    
  }
} 
