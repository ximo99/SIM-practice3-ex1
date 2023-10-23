// Authors:
// Julian Rodriguez
// Ximo Casanova

// Description of the problem:
// French billiards (velocity-based collision model)

// Display values:
final boolean FULL_SCREEN = false;
final int DRAW_FREQ = 50;    // Draw frequency (Hz or Frame-per-second)
int DISPLAY_SIZE_X = 1450;   // Display width (pixels)
int DISPLAY_SIZE_Y = 500;    // Display height (pixels)

// Parameters of the numerical integration:
final float SIM_STEP = 0.01;   // Simulation time-step (s)
float simTime = 0.0;   // Simulated time (s)

// Draw values:
final int [] BACKGROUND_COLOR = {200, 200, 255};
final int [] REFERENCE_COLOR = {0, 255, 0};
final int [] OBJECTS_COLOR = {255, 0, 0};
final float OBJECTS_SIZE = 1.0;   // Size of the objects (m)
final float PIXELS_PER_METER = 300.0;   // Display length that corresponds with 1 meter (pixels)
final PVector DISPLAY_CENTER = new PVector(0.0, 0.0);   // World position that corresponds with the center of the display (m)

// Variables
final float Kd = 0.1;   // Friction constant
float cp1 = -1.0;       // Ball-plane energy loss constant
float cp2 = 1.0;        // Ball-ball energy loss constant
float mass = 0.215;     // Mass of the balls
float radius = 0.031;   // Radius of the balls

// Classes:
ParticleSystem system;   // Particle system
ArrayList<PlaneSection> planes;    // Planes representing the limits
ArrayList< PVector> corners;  // Planes corners

// Problem variables:
boolean planeCollision = true;
boolean attraction = false;

// Impress values:
PrintWriter output;
String file = "datos.txt";

// Converts distances from world length to pixel length
float worldToPixels(float dist)
{ //<>//
  return dist*PIXELS_PER_METER;
}

// Converts distances from pixel length to world length
float pixelsToWorld(float dist)
{
  return dist/PIXELS_PER_METER;
}

// Converts a point from world coordinates to screen coordinates
void worldToScreen(PVector worldPos, PVector screenPos)
{
  screenPos.x = 0.5*DISPLAY_SIZE_X + (worldPos.x - DISPLAY_CENTER.x)*PIXELS_PER_METER;
  screenPos.y = 0.5*DISPLAY_SIZE_Y - (worldPos.y - DISPLAY_CENTER.y)*PIXELS_PER_METER;
}

// Converts a point from screen coordinates to world coordinates
void screenToWorld(PVector screenPos, PVector worldPos)
{
  worldPos.x = ((screenPos.x - 0.5*DISPLAY_SIZE_X)/PIXELS_PER_METER) + DISPLAY_CENTER.x;
  worldPos.y = ((0.5*DISPLAY_SIZE_Y - screenPos.y)/PIXELS_PER_METER) + DISPLAY_CENTER.y;
}

void settings()
{
  size(DISPLAY_SIZE_X, DISPLAY_SIZE_Y);
}

void setup()
{
  
  initSimulation();
}

void initSimulation()
{
  system = new ParticleSystem();
  planes = new ArrayList<PlaneSection>();
  
  // 4 point definition
  PVector topL = new PVector(100, 100);
  PVector botL = new PVector(100, worldToPixels(1.42));
  PVector topR = new PVector(worldToPixels(2.84), 100);
  PVector botR = new PVector(worldToPixels(2.84), worldToPixels(1.42));
  
  // Definition of 4 planes from the 6 previous points
  PlaneSection top     = new PlaneSection(topL.x, topL.y, topR.x, topR.y, true);
  PlaneSection bottom  = new PlaneSection(botL.x, botL.y, botR.x, botR.y, false);
  PlaneSection left    = new PlaneSection(topL.x, topL.y, botL.x, botL.y, false);
  PlaneSection right   = new PlaneSection(topR.x, topR.y, botR.x, botR.y, true);
  
  // Add planes  
  planes.add(top);
  planes.add(bottom);
  planes.add(left);
  planes.add(right);
}

void drawStaticEnvironment()
{
  background(165, 165, 165);
  
  fill(0);
  textSize(20);
  
  // Information displayed on the screen
  // Number of total particles and other variables
  text("Número de bolas: "+ system.getNumParticles(), worldToPixels(2.84) + 50, 100);
  text("Colisiones: "+ planeCollision, worldToPixels(2.84) + 50, 140);
  text("Atracción: " + attraction, worldToPixels(2.84) + 50, 180);
  
  // Keys to press to modify the simulation
  text("Pulse M para activar las bolas. ", worldToPixels(2.84) + 50, 260);
  text("Pulse R para reiniciar el sistema. ", worldToPixels(2.84) + 50, 300);
  text("Pulse C para activar o desactivar las colisiones. ", worldToPixels(2.84) + 50, 340);
  text("Pulse A para activar o desactivar la atracción ", worldToPixels(2.84) + 50, 380);
  text("(atracción diseñada a la esquina inferior derecha). ", worldToPixels(2.84) + 50, 410);
  
  fill(5, 163, 6);
  rect(100, 100, worldToPixels(2.84) - 100, worldToPixels(1.42) - 100);
  
  // Drawing from the plans
  for(int i = 0; i < planes.size(); i++)
  {
      PlaneSection p = planes.get(i);
      p.draw();
  }
}

void draw() 
{
  drawStaticEnvironment();
  
  system.run();
  system.computeCollisions(planes, planeCollision);
  system.display();
  
  simTime += SIM_STEP;
}

// Reactivate the balls with the M key
void active() 
{
  PVector v = new PVector();
  
  for(int i = 0; i < system.getNumParticles(); i++)
  {
    Particle p = system.particles.get(i);
    
    v.set(random(-1000, 1000), random(-1000, 1000));
    p.setVelocity(v);
  }
}

// Modify the simulation by pressing the indicated keys
void keyPressed()
{
  switch(key)
  {
    case 'm':
    case 'M':
      active();
    break;
    
    case 'r':
    case 'R':
      reset();
    break;
      
    case 'a':
    case 'A':
      attraction = !attraction;
    break;
    
    case 'c':
    case 'C':
      planeCollision = !planeCollision;
    break;
      
    default:
      break;
  }
}

// System reset
void reset()
{
  system.particles.clear();
  system = new ParticleSystem();
  simTime = 0.0;
  
  attraction = false;
  planeCollision = true;
}

// Stop system
void stop()
{
  output.flush();
  output.close();
  exit();
}
