//Define design parameters
//Du=2; //asked not to use Du as basis, HC design itself is already changed from this scaling
//I=80;
//width_x = 20*Du;
//length_y = 48.6*Du+I;
//height_z= 40.5*Du;
//channel_length=3000;
//w=0.05*channel_length; // length of narrowing piece in y direction
//s_channel=20;// thickness of channel in x direction
//l=s_channel;
//h=height_z;
//channel_height=10;
//height_spacing=10;// distance between top of holder and top of narrowing section
//r1=80;
//h_dot= channel_height;

//*****edit based on David's code*****
//hydrocyclone holder dimensions
width_x = 60;
length_y = 250;
height_z = 60;

//hydrocyclone parameters
n=36;
DU=4;
DO=4;
DC=5*DU;
theta=9;
cyc_h=0.75*DC;
l=(DC/2)/tan(theta/2);
vortex_h=1.25*DC;
exit_l=(length_y-(l+cyc_h))/2;

//trapezoidal deformation
wdiff = 20; //percent, width difference
//inlet branch dimensions
width_in = 60;
length_in = 60;
ypos_in = exit_l+l+cyc_h-DU/2-0.5*width_in; 
//ypos_in = -25+length_y-0.5*width_in;
//narrow (transition from holder to channel) and channel parameters
width_chan = 40;
height_chan = 40;
length_chan = 2000;
offset1 = 0; //height gap from top of the holder to the top of the narrow, for overflow and underflow outlets
offset2 = 0; //height gap, for inlet part
height_nar1 = (height_z - height_chan - offset1);
length_nar1 = (height_z - height_chan - offset1); //45 deg slope
height_nar2 = (height_z - height_chan - offset2);
length_nar2 = (height_z - height_chan - offset2); 
//adhesive channel variables
offset3 = 20; //safe distance from the boundary of holder to prevent adhesive leaking
h_gap = 10; //additional height to allow adhesive flow thru over and under the holder
//adhesive channel - polyhedron coordinate 
xpos1 = -(length_in-offset3);
xpos2 = width_x*wdiff/200; //to weld on the top of trapezoid
xpos3 = xpos1 - 50;
ypos1 = offset3;
ypos2 = ypos_in+width_in*wdiff/200;
zpos1 = height_z + h_gap;

xpos4 = width_x*(1-wdiff/200);
xpos5 = xpos4 + 100;
ypos3 = length_y - offset3;
l_grooved=length_y/25;

length_groove = 2;


t_groove= 5;

height_groove=height_z-t_groove;
width_x_groove=0.75*width_x;

module channel_mold(){
    module prism(x,y,z){
        polyhedron(
            points=[[0,0,z],[x,0,z], [x,y,z], [0,y,z], [0,y,0], [x,y,0]],
            faces = [
                [0,1,2,3], //top
                [5,4,3,2], // back
                [0,4,5,1], //diagonal plane
                [0,3,4],[5,2,1] // sidewalls
            ]
        );
    }
    
    module cornercut(w,l,h){
        rotate([0,0,90])
        translate([0,-w*wdiff/200,0])
        prism(l,w*wdiff/200,h);
        
        rotate([0,0,90])
        translate([l,-w*(1-wdiff/200),0])
        prism(-l,-w*wdiff/200,h);
    }
    
    module trapezoid(w,l,h){
        difference(){
            cube(size=[w,l,h]);
            cornercut(w,l,h);
        }
    }
    
    //hydrocyclone holder, overflow-to-underflow part
    trapezoid(width_x,length_y+2*l_grooved,height_z);
    //hydrocyclone holder, inlet branch part 
    rotate([0,0,90])
    translate([ypos_in+l_grooved,-width_x*wdiff/200,0])
    trapezoid(width_in,l_grooved+length_in+width_x*wdiff/200,height_z);//w*wdiff/200 is offset to union inlet part to the rest of holder without leaving any gap caused by corner cut          

    //long channels for fluidic interfacing
    module narrow(x,y,z){
        polyhedron(
            points=[[0,0,0],[x,0,0],[x,y,0],[0,y,0],[0,y,z],[x,y,z]],
            faces=[
                [0,1,2,3], //bottom
                [5,4,3,2], //back
                [0,4,5,1], //slide
                [0,3,4],[5,2,1] //side walls
            ]
        );
    }
    //narrow: transition part from holder to long channel
    //narrow for underflow outlet
    translate([0.5*(width_x-width_chan),-length_nar1,height_chan])
    narrow(width_chan,length_nar1,height_nar1);
    //narrow for overflow outlet
    rotate([0,0,180])
    translate([-0.5*(width_chan+width_x),-(length_y+length_nar1+2*l_grooved),height_chan])
    narrow(width_chan,length_nar1,height_nar1);
    //narrow for inlet
    rotate([0,0,-90])
    translate([-(ypos_in+0.5*(width_in+width_chan)+l_grooved),-(length_nar2+length_in)-l_grooved,height_chan])
    narrow(width_chan,length_nar2,height_nar2);
    
    //long channel - underflow
    translate([0.5*(width_x-width_chan),-length_chan,0])
    cube(size=[width_chan,length_chan,height_chan]);
    //long channel - overflow
    translate([0.5*(width_x-width_chan),length_y,0])
    cube(size=[width_chan,length_chan,height_chan]);
    //long channel - inlet
    rotate([0,0,90])
    translate([(ypos_in-0.5*(width_chan-width_in)+l_grooved),length_in,0])
    cube(size=[width_chan,length_chan,height_chan]);

    //marks at the end of each channels
    translate([0,-length_chan,0.5*height_chan])
    cube(size=[0.5*length_chan,2*width_chan,height_chan], center=true);
    translate([0,length_chan+length_y,0.5*height_chan])
    cube(size=[0.5*length_chan,2*width_chan,height_chan], center=true);
    rotate([0,0,90])
    translate([ypos_in,length_chan+length_in,0.5*height_chan])
    cube(size=[0.5*length_chan,2*width_chan,height_chan], center=true);
    

  
}






//channel_mold();

module prism(x,y,z){
        polyhedron(
            points=[[0,0,z],[x,0,z], [x,y,z], [0,y,z], [0,y,0], [x,y,0]],
            faces = [
                [0,1,2,3], //top
                [5,4,3,2], // back
                [0,4,5,1], //diagonal plane
                [0,3,4],[5,2,1] // sidewalls
            ]
        );
    }
    
    module cornercut(w,l,h){
        rotate([0,0,90])
        translate([0,-w*wdiff/200,0])
        prism(l,w*wdiff/200,h);
        
        rotate([0,0,90])
        translate([l,-w*(1-wdiff/200),0])
        prism(-l,-w*wdiff/200,h);
    }
    
    module trapezoid(w,l,h){
        difference(){
            cube(size=[w,l,h]);
            cornercut(w,l,h);
        }
    }
module grooves() { 
 
    module single_groove(){
        
        difference(){
     trapezoid(width_x,length_groove,height_z);
    
    translate([0.5*(width_x-width_x_groove), 0,0])
    trapezoid(width_x_groove,length_groove,height_groove);
        }
    }
    
   module single_groove_in(){
     difference(){
     trapezoid(1.05*width_in,length_groove,height_z);
    
    translate([0.5*(width_in-width_x_groove), 0,0])
    trapezoid((width_in/width_x)*width_x_groove,length_groove,height_groove);
       
     }
 }
 
translate([0,0.25*l_grooved,0]) 
  single_groove();
    

translate([0,0.75*l_grooved,0])    
single_groove();


translate([0,length_y+1.5*l_grooved,0])
single_groove();

translate([0,length_y+l_grooved,0])
single_groove();
  
translate([-length_in-0.25*l_grooved,length_y-(width_in-width_x_groove),0])  

//translate([-length_in-0.25*l_grooved,length_y+0.5*(width_in-width_x_groove),0]) try with length_y=200   
rotate([0,0,270]) 
single_groove_in();    

translate([-length_in-0.75*l_grooved,length_y-(width_in-width_x_groove),0])   
rotate([0,0,270]) 
single_groove_in(); 



}



difference(){
channel_mold();
    
grooves();
}




//Adhesive path - holder part
module adhesive_mold(){    
    module adbox1(){
        polyhedron(
            points=[
                [xpos3,ypos1,0],[xpos2,ypos1,0],[xpos2,ypos2,0],[xpos1,ypos2,0], //4 bottom face points
                [xpos1,ypos2,zpos1],[xpos2,ypos2,zpos1],[xpos2,ypos1,zpos1]], //3 points at holder top
            faces=[
                [0,1,2,3], [5,4,3,2],[6,5,2,1],[5,6,4],[4,6,0],[0,3,4],[0,6,1]]
            );
    }
    module adbox2(){
        polyhedron(
            points=[
                [xpos4,ypos1,0],[xpos5,ypos3,0],[xpos4,ypos3,0], //3 bottom face points
                [xpos4,ypos3,zpos1],[xpos4,ypos1,zpos1]],
            faces=[
                [0,1,2],[2,3,4,0],[0,4,1],[3,2,1],[1,4,3]]
            );
    }
    module adbox3(){
        polyhedron(
            points=[
                [xpos2, ypos1, height_z],[xpos4,ypos1,height_z],[xpos4,ypos3,height_z],[xpos1,ypos2,height_z], //4 bottom poinst @ holder top
                [xpos1, ypos2, zpos1],[xpos2,ypos1,zpos1],[xpos4,ypos1,zpos1],[xpos4,ypos3,zpos1]],
            faces=[
                [0,1,2,3],[4,3,2,7],[0,3,4,5],[2,1,6,7],[1,0,5,6],[7,6,5,4]]
            );
    }
    
    translate([0,l_grooved,0])
    adbox1();
    translate([0,l_grooved,0])
    adbox2();
    translate([0,l_grooved,0])
    adbox3();

    //Adhesive path - channel
    //rough positioning to submerge channel into adbox
    translate([0.5*(xpos3+width_chan),0.5*(ypos2-width_chan+2*l_grooved),0])
    rotate([0,0,135])
    cube(size=[width_chan,length_chan,height_chan]);
    translate([0.5*(xpos5-width_chan),0.55*(ypos3+width_chan+2*l_grooved),0])
    rotate([0,0,-45])
    cube(size=[width_chan,length_chan,height_chan]);
    //marks at the end of each channels
    translate([length_chan/sqrt(2),length_chan/sqrt(2),0.5*height_chan])
    rotate([0,0,-45])
    cube(size=[0.5*length_chan,2*width_chan,height_chan], center=true);
    translate([-length_chan/sqrt(2),-length_chan/sqrt(2),0.5*height_chan])
    rotate([0,0,-45])
    cube(size=[0.5*length_chan,2*width_chan,height_chan], center=true);
    
}
color("blue",0.75)
adhesive_mold();
