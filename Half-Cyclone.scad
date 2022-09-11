DU=2;
DC=5*DU;
DO=DU;
both=3*DU;
I=27.9*DU;
L=2/3*DC;
Cyl_ht=20*DU;
Cyl_rad=15*DU;
Threaded_ht = Cyl_ht+0.01;
thickness= 5*DU;
washer_ht=5*DU;
washer_rad=7.5*DU;
funnel_ht=20*DU;
Di=DU;
base_x=3*Cyl_rad+I+3*L;
width_y=2.7*Cyl_rad;
height_z= Cyl_ht;
resolution = 50;

module hydrocyclone(outer,base_x,width_y,height_z,inner){

// This is the module for outer structure 
module outer(Cyl_ht,Cyl_rad,Threaded_ht,thickness,washer_ht,washer_rad,funnel_ht,Di){
    translate([-0.5*L-DO,0.6*DC+DO,0]){
difference(){
cylinder(h=Cyl_ht,r1=Cyl_rad,r2=Cyl_rad,center=true,$fn=resolution);
cylinder(h=Threaded_ht, r1=Cyl_rad-thickness,r2=Cyl_rad-thickness, center=true, $fn=resolution);
}
// Draw washer piece
translate([0,0,-0.5*(Cyl_ht+washer_ht)])
difference(){
cylinder(h=washer_ht,r1=Cyl_rad,r2=Cyl_rad,center=true,$fn=resolution);
cylinder(h=washer_ht,r1=washer_rad,r2=washer_rad, center=true, $fn=resolution);
}

//Draw funnel piece
translate([0,0,-0.5*(Cyl_ht+washer_ht)])
difference(){
cylinder(h=funnel_ht,r1=Cyl_rad,r2=Cyl_rad,center=true,$fn=resolution);
cylinder(h=funnel_ht,r1=Di, r2=washer_rad,center=true, $fn=resolution);
}
}
//Draw rectangular base
//base specs
base_x=3*Cyl_rad+I+3*L;
width_y=2.7*Cyl_rad;
height_z= Cyl_ht;
rotate([0,0,180]){
translate([(0.5*base_x)-Cyl_rad, 0,-0.5*(Cyl_ht+washer_ht)-0.5*funnel_ht-0.5*height_z])
cube ([base_x,width_y,height_z],center=true);
}
}







// This is the module for interior structure
module inner(DC,DO,both,I,L){
translate([0,0,-0.5*both]){
cylinder (h=both, r=DO, center=true, $fn=resolution);
}
cylinder(h=I, r1=DO,r2=DC,$fn=resolution);
translate([0,0,I+L/2]){
    // The part for spinning beam head
difference(){
cylinder(h=L,r=DC,center=true,$fn=resolution);
cylinder(h=L*1.1,r=3/5*DC,center=true,$fn=resolution);
}
}
translate([0,0,I+L/2]){
cylinder(h=L*2,r=DO,center=true,$fn=resolution);
}
// The fluid inlet 
translate([0,DC*4/5,I+L-DO]){
rotate([0,-90,0])
    cylinder(h=0.5*Cyl_ht-0.5*DC,r=DO,$fn=resolution);
}
// Parts of upper connections
translate([0,0,I+L]){
cylinder(h=2*L,r1=DO,r2=DC,$fn=resolution);
}
translate([0,0,I+3*L]){
    union(){
    cylinder(h=L,r=DC,$fn=resolution);
    translate([0,0,L]){
    sphere(DC,$fn=resolution);
    }
    }
}
// Parts of bottom connections
translate([0,0,-1*both-2*L]){
cylinder(h=2*L,r1=DC,r2=DO,$fn=resolution);
}
translate([0,0,-1*both-3*L]){
    union(){
    cylinder(h=L,r=DC,$fn=resolution);
    translate([0,0,0]){
    sphere(DC,$fn=10);
    }
    }
}
}



// Cut the interior structure out of the body 
difference(){
    rotate([180,0,180]){
    translate([I+L*1.5,0,DC*10-Cyl_ht])
outer(Cyl_ht,Cyl_rad,Threaded_ht,thickness,washer_ht,washer_rad,funnel_ht,Di);
   translate([-1.5*both-2*L,0,0]){
       rotate([0,-90,0]){
   cylinder(r=1.5*DC,h=DC*13,$fn=resolution);
   }
   }
   translate([I+3.5*L,0,]){
       rotate([0,90,0]){
cylinder(r=1.5*DC,h=DC*10,$fn=resolution);
       }
}
}

rotate([0,-90,0]){

inner(DC,DO,both,I,L);
}
translate([1.5*both+2*L,0,0]){
    rotate([0,90,0]){
cylinder(r=DC,h=DC*13,$fn=resolution);
}
}
translate([-I-3.5*L,0,0]){
    rotate([0,-90,0]){
cylinder(r=DC,h=DC*10,$fn=resolution);
}
}
}
}

difference(){
     hydrocyclone(outer,base_x,width_y,height_z,inner);
translate([-270,-1.35*Cyl_rad+50,-Cyl_ht-70]){
cube([Cyl_ht+funnel_ht,Cyl_ht+funnel_ht,Cyl_ht+funnel_ht+40], center=true);}
rotate([180,0,0]){
translate([-1000,-0,-2700]){
cube(3000);}
}
}

//difference(){
//  hydrocyclone(outer,base_x,width_y,height_z,inner);
//rotate([180,0,0]){
//translate([-1000,-0,-2700]){
//cube(3000);}
//}

// }

//hydrocyclone(outer,base_x,width_y,height_z,inner);