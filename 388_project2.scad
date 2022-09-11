platewidth=50;
platelength=platewidth;
t_plate= 3;
baselength=90;
R = 4;
arclength=100;
t_base=2;




cube([platewidth, platelength, t_plate], center=true);// electrode 1

translate([platelength+baselength+2,platewidth+2,0])
cube([platewidth, platelength, t_plate], center=true);// electrode 2

translate([0.5*platewidth-2, 0.5*platewidth +2, -0.5*t_plate])
cube([94,50,t_base]);




translate([0.5*platelength, -0.5*platelength,-0.5*t_plate])
rotate([90,0,90])
linear_extrude(height=baselength,convexity=10)
square([platewidth,t_plate]);

module beams(arclength){
    for( i =[0:1:4]){
     
       
        R=500-100*i;
        theta= 57.296*arclength/R;
     
        translate([-R-0.5*t_plate,0.5*platewidth,0.5*platewidth+20*i])
        
        rotate_extrude(angle=theta, $fn=100)
        {
            translate([R,0,0])
            square([1,10]);
            
            
        }
    }
        
}

rotate([90,90,90])
beams(arclength);