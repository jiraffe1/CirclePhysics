class node {
  PVector pos;
  PVector vel;
  ArrayList<node> links;
  FloatList linkDists;
  boolean isKinematic;
  float size;
  float bounciness;

  node(PVector pos_, boolean isKinematic_) {
    this.linkDists = new FloatList();
    this.pos = pos_;
    this.vel = new PVector(0, 0);
    this.links = new ArrayList<node>();
    this.isKinematic = isKinematic_;
    this.size = settings.defaultSize+random(-5, 5);
    this.bounciness = settings.defaultBounciness;
  }

  void display() {
    if(!this.isKinematic) {
      stroke(255, 0, 0);
    }
    else {
      stroke(100, 100, 100);
    }
    fill(255, 0, 0);
    strokeWeight(this.size);
    point(this.pos.x, this.pos.y);
    stroke(0);
    strokeWeight(3);

    if(mousePressed && dist(mouseX, mouseY, this.pos.x, this.pos.y) < 9 && this.isKinematic == false && drag == null) drag = this;
    else if(!mousePressed) drag = null;
    
    if(drag == this) {
      this.pos.set(mouseX, mouseY);
    }
    this.physics();
  }

  void physics() {
    this.vel.limit(settings.defaultMaxVel);

    if (!this.isKinematic) {
      for (int i = world.size() - 1; i >= 0; i--) {
        node n = world.get(i);

        if (n != this) {
          if (PVector.dist(this.pos, n.pos) < this.size/2+n.size/2) {
            this.repelNode(n);
          }
        }
      }

      this.vel.y += settings.gravity;
      this.pos.add(this.vel);
      for (int i = this.links.size()-1; i >= 0; i--) {
        node n = this.links.get(i);
        PVector p = n.pos;
        if (!this.isKinematic)this.effectLink(n);
        line(this.pos.x, this.pos.y, p.x, p.y);
      }
    }
  }

  void repelNode(node n) {
    PVector a = new PVector(this.pos.x, this.pos.y);
    PVector b = new PVector(n.pos.x, n.pos.y);

    PVector c = a.sub(b);

    c.setMag(this.bounciness*3);
    c.mult(-1);    
    this.vel.sub(c);
    this.vel.mult(this.bounciness);
  }

  void addLink(node node) {
    this.links.add(node);
    this.linkDists.append(PVector.dist(this.pos, node.pos));
  }

  void effectLink(node node) {
    float dst = 0;

    for (int i = this.links.size() - 1; i >= 0; i--) {
      if (this.links.get(i) == node) {
        dst = this.linkDists.get(i);
        break;
      }
    }
    float actualDist = PVector.dist(this.pos, node.pos);

    PVector a = new PVector(this.pos.x, this.pos.y);
    PVector b = new PVector(node.pos.x, node.pos.y);
    PVector c = b.sub(a);

    if (actualDist > dst) {
      c.setMag(settings.defaultSpringiness);
      this.vel.add(c);
    } else {
      c.setMag(-settings.defaultSpringiness);
      this.vel.add(c);
    }
  }
}
