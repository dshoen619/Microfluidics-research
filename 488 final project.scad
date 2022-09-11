//Extruding Piece specs
Cyl_ht=4;
Cyl_rad=3;
Threaded_ht = Cyl_ht+0.001;
thickness= 1;
washer_ht=1;
washer_rad=1.5;
funnel_ht=2;
Di=0.1;


//Draw Extruding Piece

difference(){
    cylinder(h=Cyl_ht,r1=Cyl_rad,r2=Cyl_rad,center=true,$fn=100);
    cylinder(h=Threaded_ht, r1=Cyl_rad-thickness,r2=Cyl_rad-thickness, center=true, $fn=100);
}

// Draw washer piece
translate([0,0,-0.5*(Cyl_ht+washer_ht)])
difference(){
    cylinder(h=washer_ht,r1=Cyl_rad,r2=Cyl_rad,center=true,$fn=100);
    cylinder(h=washer_ht,r1=washer_rad,r2=washer_rad, center=true, $fn=100);
}
    
//Draw funnel piece


translate([0,0,-0.5*(Cyl_ht+washer_ht)])
difference(){
    cylinder(h=funnel_ht,r1=Cyl_rad,r2=Cyl_rad,center=true,$fn=100);
   cylinder(h=funnel_ht,r1=Di, r2=washer_rad,center=true, $fn=100);
}

//Draw rectangular base

//base specs
base_x=2*Cyl_rad+8;
width_y=2.5*Cyl_rad;
height_z= Cyl_ht;

translate([(0.5*base_x)-Cyl_rad, 0,0.5*(Cyl_ht+washer_ht+funnel_ht)]
cube ([base_x,width_y,height_z],center=true);
