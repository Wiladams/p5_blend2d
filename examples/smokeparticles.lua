
-- texture for the particle
local particle_texture = nil;

-- variable holding our particle system
local ps = nil;

function preload()
  particle_texture = loadImage("assets/particle_texture.png");
end

function setup()
  --set the canvas size
  createCanvas(640, 360);

  --initialize our particle system
  ps = ParticleSystem(0, P5Vector(width / 2, height - 60), particle_texture);
end

function draw()
  background(0);

  local dx = map(mouseX, 0, width, -0.2, 0.2);
  local wind = P5Vector(dx, 0);

  ps:applyForce(wind);
  ps:run();
  for (i = 0, 1) do
    ps:addParticle();
  end

  -- Draw an arrow representing the wind force
  drawVector(wind, P5Vector(width / 2, 50, 0), 500);
end

--[[*
 *  This function draws an arrow showing the direction our "wind" is blowing.
 --]]
function drawVector(v, loc, scale)
  push();
  local arrowsize = 4;
  translate(loc.x, loc.y);
  stroke(255);
  rotate(v.heading());

  let len = v.mag() * scale;
  line(0, 0, len,0);
  line(len, 0, len-arrowsize, +arrowsize / 2);
  line(len, 0, len-arrowsize, -arrowsize / 2);
  pop();
end

--========= PARTICLE SYSTEM ===========

--[[*
 * A basic particle system class
 * @param num the number of particles
 * @param v the origin of the particle system
 * @param img_ a texture for each particle in the system
 * @constructor
 --]]
let ParticleSystem = function(num, v, img_) {

  this.particles = [];
  this.origin = v.copy(); -- we make sure to copy the vector value in case we accidentally mutate the original by accident
  this.img = img_
  for(let i = 0; i < num; ++i){
    this.particles.push(new Particle(this.origin, this.img));
  }
};

--[[*
 * This function runs the entire particle system.
 --]]
ParticleSystem.prototype.run = function() {

  -- cache length of the array we're going to loop into a variable
  -- You may see <variable>.length in a for loop, from time to time but
  -- we cache it here because otherwise the length is re-calculated for each iteration of a loop
  let len = this.particles.length;

  --loop through and run particles
  for (let i = len - 1; i >= 0; i--) {
    let particle = this.particles[i];
    particle.run();

    -- if the particle is dead, we remove it.
    -- javascript arrays don't have a "remove" function but "splice" works just as well.
    -- we feed it an index to start at, then how many numbers from that point to remove.
    if (particle.isDead()) {
      this.particles.splice(i, 1);
    }
  }
}

--[[*
 * Method to add a force vector to all particles currently in the system
 * @param dir a p5.Vector describing the direction of the force.
 --]]
ParticleSystem.prototype.applyForce = function(dir) {
  let len = this.particles.length;
  for(let i = 0; i < len; ++i){
    this.particles[i].applyForce(dir);
  }
}

--[[*
 * Adds a new particle to the system at the origin of the system and with
 * the originally set texture.
 --]]
ParticleSystem.prototype.addParticle = function() {
    this.particles.push(new Particle(this.origin, this.img));
}

--========= PARTICLE  ===========
--[[*
 *  A simple Particle class, renders the particle as an image
 --]]
function Particle.create(self, pos, img_)
  obj.loc = pos:copy();

  local vx = randomGaussian() * 0.3;
  local vy = randomGaussian() * 0.3 - 1.0;

  obj.vel = P5Vector(vx, vy);
  obj.acc = P5Vector();
  obj.lifespan = 100.0;
  obj.texture = img_;

  return obj;
}

--[[*
 *  Simulataneously updates and displays a particle.
 --]]
function Particle.run(self)
  self:update();
  self:render();
}

--[[
   A function to display a particle
 --]]
function Particle.render(self)
  imageMode(CENTER);
  tint(255, self.lifespan);
  image(self.texture, self.loc.x, self.loc.y);
end

--[[*
 *  A method to apply a force vector to a particle.
 --]]
function Particle.applyForce(self, f)
  self.acc.add(f);
end

--[[*
 *  This method checks to see if the particle has reached the end of it's lifespan,
 *  if it has, return true, otherwise return false.
 --]]
function Particle.isDead = function (self)
  if (self.lifespan <= 0.0)  then
    return true;
  else
      return false;
  end
end

--[[*
 *  This method updates the position of the particle.
 --]]
function Particle.update(self)
  self.vel.add(this.acc);
  self.loc.add(this.vel);
  self.lifespan -= 2.5;
  self.acc.mult(0);
end
