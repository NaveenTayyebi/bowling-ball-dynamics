%% Setup
m = 4.53592; 
g = 9.81;
D = 0.2183;
x0 = 0; 
y0 = 0.3; 
z0 = -D/2;
xdot0 = -8;
ydot0 = -0.5; 
zdot0 = 0; 
s0 = 0; 
t0 = 0; 
p0 = 0; 
sdot0 = 0; 
tdot0 = -5; 
pdot0 = 4; 
tspan = 0:0.05:14; 
options = odeset('RelTol',1e-12);
ini_conds0 = [s0 t0 p0 sdot0 tdot0 pdot0 x0 y0 z0 xdot0 ydot0 zdot0];
[t,x] = ode113(@(t,x) solver(t,x,m,D),tspan,ini_conds0,options);
XS = []; 
for l = 1:1:length(x)
    if ((abs(x(l,8)) > 0.5318) || (abs(x(l,7)) > 18.288) || (x(l,10) > 0.5))
        XS = x(1:l,:);
        x = XS; 
        break; 
    end 
end 
%% Animation 
origin = [0 0 0]; 
n1_n = [1 ; 0 ; 0];
n2_n = [0 ; 1 ; 0];
n3_n = [0 ; 0 ; 1];
b1_b = [1 ; 0 ; 0];
b2_b = [0 ; 1 ; 0];
b3_b = [0 ; 0 ; 1];
[F,V,N] = stlread("Bowling_ball.stl");
points_Vector = F.Points/(10^(3));
points_Vector = [points_Vector(:,1), points_Vector(:,2), points_Vector(:,3)];
connect_Vector = F.ConnectivityList;
temp_Vector_initial = zeros(size(points_Vector));
figure(6)
grid on 
hold on
scs = 1.05;
plot3([origin(1) n1_n(1)],[origin(2) n1_n(2)], [origin(3) n1_n(3)],'Linewidth',2,'Color','b');
hold on 
plot3([origin(1) n2_n(1)],[origin(2) n2_n(2)], [origin(3) n2_n(3)],'Linewidth',2,'Color','b');
hold on 
plot3([origin(1) n3_n(1)],[origin(2) n3_n(2)], [origin(3) n3_n(3)],'Linewidth',2,'Color','b');
hold on 
text(scs*n1_n(1),scs*n1_n(2),scs*n1_n(3),'n1','color','b');
hold on 
text(scs*n2_n(1),scs*n2_n(2),scs*n2_n(3),'n2','color','b');
hold on 
text(scs*n3_n(1),scs*n3_n(2),scs*n3_n(3),'n3','color','b');
h1 = plot3([0 0],[0 0],[0 0]);
h2 = plot3([0 0],[0 0],[0 0]);
h3 = plot3([0 0],[0 0],[0 0]);
h4 = text(n1_n(1),n1_n(2),n1_n(3),'b1','color','r');
h5 = text(n2_n(1),n2_n(2),n2_n(3),'b2','color','r');
h6 = text(n3_n(1),n3_n(2),n3_n(3),'b3','color','r');
h7 = plot3([0 0],[0 0],[0 0]);
h8 = plot3([0 0],[0 0],[0 0]);
h9 = plot3([0 0],[0 0],[0 0]);
h10 = plot3([0 0],[0 0],[0 0]); 
h11 = plot3([0 0],[0 0],[0 0]);
h12 = plot3([0 0],[0 0],[0 0]); 
h13 = plot3([0 0],[0 0],[0 0]); 
h14 = plot3([0 0],[0 0],[0 0]); 
h27 = plot3([0 0],[0 0],[0 0]); 
set(gca,'ZDir','reverse');
set(gca,'YDir','reverse');
for i = 1:1:length(x)
    view([0.1 0.2 0.2]);
    % Delete Old Images 
    delete(h1)
    delete(h2)
    delete(h3) 
    delete(h4) 
    delete(h5) 
    delete(h6)
    delete(h7)
    delete(h8)
    delete(h9)
    delete(h10)
    delete(h11)
    delete(h12)
    delete(h13)
    delete(h14)
    delete(h27)
    % Transformations of axes and rigid body 
    aRn = [cos(x(i,1)) sin(x(i,1)) 0 ; -sin(x(i,1)) cos(x(i,1)) 0 ; 0 0 1]; 
    gRa = [cos(x(i,2)) 0 -sin(x(i,2)) ; 0 1 0 ; sin(x(i,2)) 0 cos(x(i,2))]; 
    bRg = [1 0 0 ; 0 cos(x(i,3)) sin(x(i,3)) ; 0 -sin(x(i,3)) cos(x(i,3))]; 
    bRn = bRg*gRa*aRn;
    % inv(bRn)* is the same as bRn\
    b1_n = bRn\b1_b + [x(i,7) ; x(i,8) ; x(i,9)];
    b2_n = bRn\b2_b + [x(i,7) ; x(i,8) ; x(i,9)];
    b3_n = bRn\b3_b + [x(i,7) ; x(i,8) ; x(i,9)];
    for j =1:length(F.Points)
        temp_Vector(j,:) = (bRn\(points_Vector(j,:))')';
    end
    for k = 1:length(F.Points)
        temp_Vector(k,:) = temp_Vector(k,:) + [x(i,7) x(i,8) x(i,9)];
    end
    stl_refresh = triangulation(connect_Vector,temp_Vector); 
    h10 = trimesh(stl_refresh,'FaceColor',[0.4667 0.533 0.66],'EdgeColor',[0.2314 0.2667 0.2941]);
    % Angular Velocity Vector
    w1 = x(i,6)-x(4)*sin(x(i,2));
    w2 = x(i,4)*cos(x(i,2))*sin(x(i,3))+x(i,5)*cos(x(i,3));
    w3 = x(i,4).*cos(x(i,2))*cos(x(i,3))-x(i,5)*sin(x(i,3));
    Omega = [w1 ; w2 ; w3]
    % Friction Vector
    NvBcm = [x(i,10) ; x(i,11) ; x(i,12)];
    BcmpC = [0 ; 0 ; D/2];
    NvCprime = bRn\(bRn*NvBcm + cross(Omega,bRn*BcmpC))
    NvCprime_unit_slip = (NvCprime)/norm(NvCprime)*heaviside(norm(NvCprime)-0.01);
    mu_slip = 0.04; 
    mu_slip2 = 0.2; 
    M = bRn*cross(BcmpC,-mu_slip*m*g*NvCprime_unit_slip)*heaviside(x(7)+12)+bRn*cross(BcmpC,-mu_slip2*m*g*NvCprime_unit_slip)*heaviside(-x(7)-12.001);
    % Plotting Axes
    hold on 
    h1 = plot3([x(i,7) b1_n(1)],[x(i,8) b1_n(2)], [x(i,9) b1_n(3)],'Linewidth',2,'Color','r');
    hold on 
    h2 = plot3([x(i,7) b2_n(1)],[x(i,8) b2_n(2)], [x(i,9) b2_n(3)],'Linewidth',2,'Color','cyan');
    hold on
    h3 = plot3([x(i,7) b3_n(1)],[x(i,8) b3_n(2)], [x(i,9) b3_n(3)],'Linewidth',2,'Color','m');
    hold on 
    h4 = text(scs*b1_n(1),scs*b1_n(2),scs*b1_n(3),'b1','color','r');
    hold on 
    h5 = text(scs*b2_n(1),scs*b2_n(2),scs*b2_n(3),'b2','color','cyan');
    hold on 
    h6 = text(scs*b3_n(1),scs*b3_n(2),scs*b3_n(3),'b3','color','m');
    hold on 
    h11 = plot3([-18.288 0],[-0.5318 -0.5318], [0 0],'Linewidth',2,'Color','k');
    hold on 
    h12 = plot3([-18.288 0],[0.5318 0.5318], [0 0],'Linewidth',2,'Color','k');
    hold on
    h13 = plot3(x(1:i,7),x(1:i,8),x(1:i,9),'Linewidth',1,'Color','r');
    hold on 
    h14 = quiver3(x(i,7),x(i,8),0,-NvCprime_unit_slip(1),-NvCprime_unit_slip(2)...
            ,0,'color','b','linewidth',1);
    hold on 
    % Plot Settings
    h27 = text(-6,-5,append('Time = ',num2str(tspan(i)),'s'));
    axis([-18.288 2 -1 1 -1 0]);
    axis vis3d
    Q = gca;
    set(Q,'dataaspectratiomode','manual');
    set(Q,'dataaspectratio',[1 1 1]);
    xlabel('x');
    ylabel('y');
    zlabel('z');
    grid on 
    set(gcf, 'Position',  [300, 300, 600, 600])
    set(figure(6),'color','white');
end 
%% Solver
function dXdt = solver(t,x,m,D)
    % inv(bRn)* is the same as bRn\
    sympref('HeavisideAtOrigin',0);
    I11 = 2/5*m*(D/2)^2; 
    I22 = 2/5*m*(D/2)^2; 
    I33 = 2/5*m*(D/2)^2;
    g = 9.81; 
    mu_slip = 0.04;
    mu_slip2 = 0.2;
    w1 = x(6)-x(4)*sin(x(2)); 
    w2 = x(4)*cos(x(2))*sin(x(3))+x(5)*cos(x(3));  
    w3 = x(4).*cos(x(2))*cos(x(3))-x(5)*sin(x(3));
    Omega = [w1 ; w2 ; w3];
    bRn = [                          cos(x(1))*cos(x(2)),                           cos(x(2))*sin(x(1)),        -sin(x(2)) ; ...
        cos(x(1))*sin(x(2))*sin(x(3)) - cos(x(3))*sin(x(1)), cos(x(1))*cos(x(3)) + sin(x(1))*sin(x(2))*sin(x(3)), cos(x(2))*sin(x(3)) ;...
         sin(x(1))*sin(x(3)) + cos(x(1))*cos(x(3))*sin(x(2)), cos(x(3))*sin(x(1))*sin(x(2)) - cos(x(1))*sin(x(3)), cos(x(2))*cos(x(3))];
    NvBcm = [x(10) ; x(11) ; x(12)]; 
    BcmpC = [0 ; 0 ; D/2];
    NvCprime = bRn\(bRn*NvBcm + cross(Omega,bRn*BcmpC)); 
    NvCprime_unit_slip = (NvCprime)/norm(NvCprime)*heaviside(norm(NvCprime)-0.01);
    M = bRn*cross(BcmpC,-mu_slip*m*g*NvCprime_unit_slip)*heaviside(x(7)+12)+bRn*cross(BcmpC,-mu_slip2*m*g*NvCprime_unit_slip)*heaviside(-x(7)-12.001);
    M1 = M(1); 
    M2 = M(2); 
    M3 = M(3); 
    dXdt(1) = x(4); 
    dXdt(2) = x(5); 
    dXdt(3) = x(6);
    dXdt(4) = (sin(x(2))*x(5)*(cos(x(3))^2)*(I22^2)*x(4) - x(6)*x(5)*(cos(x(3))^2)*(I22^2) + sin(x(2))*x(5)*(cos(x(3))^2)*I22*I33*x(4) + x(6)*x(5)*(cos(x(3))^2)*I22*I33 - I11*sin(x(2))*x(5)*(cos(x(3))^2)*I22*x(4) + I11*x(6)*x(5)*(cos(x(3))^2)*I22 + cos(x(2))*sin(x(2))*cos(x(3))*(I22^2)*sin(x(3))*x(4)^2 - cos(x(2))*x(6)*cos(x(3))*(I22^2)*sin(x(3))*x(4) - cos(x(2))*I11*sin(x(2))*cos(x(3))*I22*sin(x(3))*x(4)^2 + cos(x(2))*I11*x(6)*cos(x(3))*I22*sin(x(3))*x(4) + M3*cos(x(3))*I22 - cos(x(2))*sin(x(2))*cos(x(3))*(I33^2)*sin(x(3))*x(4)^2 + cos(x(2))*x(6)*cos(x(3))*(I33^2)*sin(x(3))*x(4) + cos(x(2))*I11*sin(x(2))*cos(x(3))*I33*sin(x(3))*x(4)^2 - cos(x(2))*I11*x(6)*cos(x(3))*I33*sin(x(3))*x(4) + sin(x(2))*x(5)*I22*I33*(sin(x(3))^2)*x(4) + x(6)*x(5)*I22*I33*(sin(x(3))^2) + sin(x(2))*x(5)*(I33^2)*(sin(x(3))^2)*x(4) - x(6)*x(5)*(I33^2)*(sin(x(3))^2) - I11*sin(x(2))*x(5)*I33*(sin(x(3))^2)*x(4) + I11*x(6)*x(5)*I33*(sin(x(3))^2) + M2*I33*sin(x(3)))/(cos(x(2))*I22*I33*((cos(x(3))^2) + (sin(x(3))^2)));
    dXdt(5) = -(cos(x(2))*x(6)*(cos(x(3))^2)*I22*I33*x(4) + cos(x(2))*sin(x(2))*(cos(x(3))^2)*(I33^2)*x(4)^2 - cos(x(2))*x(6)*(cos(x(3))^2)*(I33^2)*x(4) - cos(x(2))*I11*sin(x(2))*(cos(x(3))^2)*I33*x(4)^2 + cos(x(2))*I11*x(6)*(cos(x(3))^2)*I33*x(4) + sin(x(2))*x(5)*cos(x(3))*(I22^2)*sin(x(3))*x(4) - x(6)*x(5)*cos(x(3))*(I22^2)*sin(x(3)) - I11*sin(x(2))*x(5)*cos(x(3))*I22*sin(x(3))*x(4) + I11*x(6)*x(5)*cos(x(3))*I22*sin(x(3)) - sin(x(2))*x(5)*cos(x(3))*(I33^2)*sin(x(3))*x(4) + x(6)*x(5)*cos(x(3))*(I33^2)*sin(x(3)) + I11*sin(x(2))*x(5)*cos(x(3))*I33*sin(x(3))*x(4) - I11*x(6)*x(5)*cos(x(3))*I33*sin(x(3)) - M2*cos(x(3))*I33 + cos(x(2))*sin(x(2))*(I22^2)*(sin(x(3))^2)*x(4)^2 - cos(x(2))*x(6)*(I22^2)*(sin(x(3))^2)*x(4) + cos(x(2))*x(6)*I22*I33*(sin(x(3))^2)*x(4) - cos(x(2))*I11*sin(x(2))*I22*(sin(x(3))^2)*x(4)^2 + cos(x(2))*I11*x(6)*I22*(sin(x(3))^2)*x(4) + M3*I22*sin(x(3)))/(I22*I33*((cos(x(3))^2) + (sin(x(3))^2)));
    dXdt(6) =((cos(x(3))^4)*(cos(x(2))^2)*(I22^2)*I33*x(4)*x(5) - (cos(x(3))^4)*(cos(x(2))^2)*I22*(I33^2)*x(4)*x(5) + (cos(x(3))^3)*(cos(x(2))^3)*(I22^2)*I33*sin(x(3))*x(4)^2 - (cos(x(3))^3)*(cos(x(2))^3)*I22*(I33^2)*sin(x(3))*x(4)^2 - (cos(x(3))^3)*cos(x(2))*(I22^2)*I33*sin(x(3))*x(5)^2 + (cos(x(3))^3)*cos(x(2))*I22*(I33^2)*sin(x(3))*x(5)^2 + (cos(x(3))^2)*(cos(x(2))^2)*I11*I22*I33*x(4)*x(5) + M1*(cos(x(3))^2)*cos(x(2))*I22*I33 - (cos(x(3))^2)*(I11^2)*I22*(sin(x(2))^2)*x(4)*x(5) + x(6)*(cos(x(3))^2)*(I11^2)*I22*sin(x(2))*x(5) + (cos(x(3))^2)*I11*(I22^2)*(sin(x(2))^2)*x(4)*x(5) - x(6)*(cos(x(3))^2)*I11*(I22^2)*sin(x(2))*x(5) + (cos(x(3))^2)*I11*I22*I33*(sin(x(2))^2)*x(4)*x(5) + x(6)*(cos(x(3))^2)*I11*I22*I33*sin(x(2))*x(5) + cos(x(3))*(cos(x(2))^3)*(I22^2)*I33*(sin(x(3))^3)*x(4)^2 - cos(x(3))*(cos(x(2))^3)*I22*(I33^2)*(sin(x(3))^3)*x(4)^2 - cos(x(3))*cos(x(2))*(I11^2)*I22*sin(x(3))*(sin(x(2))^2)*x(4)^2 + x(6)*cos(x(3))*cos(x(2))*(I11^2)*I22*sin(x(3))*sin(x(2))*x(4) + cos(x(3))*cos(x(2))*(I11^2)*I33*sin(x(3))*(sin(x(2))^2)*x(4)^2 - x(6)*cos(x(3))*cos(x(2))*(I11^2)*I33*sin(x(3))*sin(x(2))*x(4) + cos(x(3))*cos(x(2))*I11*(I22^2)*sin(x(3))*(sin(x(2))^2)*x(4)^2 - x(6)*cos(x(3))*cos(x(2))*I11*(I22^2)*sin(x(3))*sin(x(2))*x(4) - cos(x(3))*cos(x(2))*I11*(I33^2)*sin(x(3))*(sin(x(2))^2)*x(4)^2 + x(6)*cos(x(3))*cos(x(2))*I11*(I33^2)*sin(x(3))*sin(x(2))*x(4) - cos(x(3))*cos(x(2))*(I22^2)*I33*(sin(x(3))^3)*x(5)^2 + cos(x(3))*cos(x(2))*I22*(I33^2)*(sin(x(3))^3)*x(5)^2 + M3*cos(x(3))*I11*I22*sin(x(2)) + (cos(x(2))^2)*I11*I22*I33*(sin(x(3))^2)*x(4)*x(5) - (cos(x(2))^2)*(I22^2)*I33*(sin(x(3))^4)*x(4)*x(5) + (cos(x(2))^2)*I22*(I33^2)*(sin(x(3))^4)*x(4)*x(5) + M1*cos(x(2))*I22*I33*(sin(x(3))^2) - (I11^2)*I33*(sin(x(3))^2)*(sin(x(2))^2)*x(4)*x(5) + x(6)*(I11^2)*I33*(sin(x(3))^2)*sin(x(2))*x(5) + I11*I22*I33*(sin(x(3))^2)*(sin(x(2))^2)*x(4)*x(5) + x(6)*I11*I22*I33*(sin(x(3))^2)*sin(x(2))*x(5) + I11*(I33^2)*(sin(x(3))^2)*(sin(x(2))^2)*x(4)*x(5) - x(6)*I11*(I33^2)*(sin(x(3))^2)*sin(x(2))*x(5) + M2*I11*I33*sin(x(3))*sin(x(2)))/(cos(x(2))*I11*I22*I33*((cos(x(3))^2) + (sin(x(3))^2)));
    dXdt(7) = x(10);
    dXdt(8) = x(11); 
    dXdt(9) = x(12);
    dXdt(10) = -mu_slip*m*g*NvCprime_unit_slip(1)*heaviside(x(7)+12)-mu_slip2*m*g*NvCprime_unit_slip(1)*heaviside(-x(7)-12.001); 
    dXdt(11) = -mu_slip*m*g*NvCprime_unit_slip(2)*heaviside(x(7)+12)-mu_slip2*m*g*NvCprime_unit_slip(2)*heaviside(-x(7)-12.001);
    dXdt(12) = 0; 
    dXdt = dXdt';
end 





