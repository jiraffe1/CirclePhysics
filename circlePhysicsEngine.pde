ArrayList<node> world;
node drag = null;

void setup() {
  world = new ArrayList<node>();
  size(800, 600);
  addEdges();
}

void draw() {
  background(255);

  for (int i = world.size()-1; i >= 0; i--) {
    node n = world.get(i);
    n.display();
  }
    stroke(0);
  fill(0);
  text(floor(frameRate), 30, 30);
}

void keyPressed() {
  switch(key) {
  case 'q':
    float mx = mouseX;
    float my = mouseY;

    node newNode = new node(new PVector(mx, my), false);
    world.add(newNode);
    break;
  case 'w':
    float nx = mouseX;
    float ny = mouseY;

    node newNodeA = new node(new PVector(nx, ny), true);
    world.add(newNodeA);
    break;
  case 'o':
    newAddSquare(mouseX, mouseY, false, 3, 3, 30);
    break;
  case 'p':
    addSquare(mouseX, mouseY, true);
    break;
  }
}

void addEdges() {
  //bottom edge
  for (int i = 0; i < width/4; i++) {
    float x = i*5;
    float y = height;

    node n = new node(new PVector(x, y), true);
    world.add(n);
  }
}

void addSquare(float x, float y, boolean isKinematic) {

  node topR = new node(new PVector(x+50, y), isKinematic);
  node topL = new node(new PVector(x, y), isKinematic);
  node bottomR = new node(new PVector(x+50, y+50), isKinematic);
  node bottomL = new node(new PVector(x, y+50), isKinematic);

  topR.addLink(topL);
  topR.addLink(bottomL);
  topR.addLink(bottomR);

  topL.addLink(topR);
  topL.addLink(bottomL);
  topL.addLink(bottomR);

  bottomR.addLink(topR);
  bottomR.addLink(topL);
  bottomR.addLink(bottomL);

  bottomL.addLink(bottomR);
  bottomL.addLink(topR);
  bottomL.addLink(topL);

  world.add(topR);
  world.add(topL);
  world.add(bottomR);
  world.add(bottomL);
}

void newAddSquare(float x, float y, boolean isKinematic, int w, int h, float scale) {
  node[][] newSquare = new node[w][h];

  for (int i = 0; i < w; i++) {
    for (int j = 0; j < h; j++) {
      float nx = x+(i*scale);
      float ny = y+(j*scale);
      
      if(i == 0 || i == w-1 || j == 0 || j == h-1) {
        node n = new node(new PVector(nx, ny), isKinematic);
        newSquare[i][j] = n;
        world.add(n);
      }
    }
  }

  for (int i1 = 0; i1 < w; i1++) {
    for (int j1 = 0; j1 < h; j1++) {
      node n = newSquare[i1][j1];
      for(int i2 = 0; i2 < w; i2++) {
        for(int j2 = 0; j2 < h; j2++) {
          if(newSquare[i2][j2] != null && n != null) {
            n.addLink(newSquare[i2][j2]);
          }
        }
      }
    }
  }
}
