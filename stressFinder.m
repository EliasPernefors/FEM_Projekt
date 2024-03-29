function stress = stressFinder(Ex,Ey,nelm,nedof,t,D_cu,D_nyl,th,u,deltaT,alpha_cu,alpha_nyl)
% This function finds the stress in every element using plants and returns
% a nelm x 6 matrix which gives the different directions of the stress.

stress = zeros(nelm,6);
ep = [2 th]; % 2 is for plane strain

edStress = zeros(nelm, 6);
% The values for all the nodes which correspond to each element are placed
% into the edStress matrix using u(nedof(i,2:7))
for i = 1:nelm
    edStress(i,:) = u(nedof(i,2:7));
end    
for el = 1:nelm
    deltaTelement = (deltaT(t(1,el))+deltaT(t(2,el))+deltaT(t(3,el)))/3;
    deltaTvec = [1;1;0;0;0;0]*deltaTelement;
    if t(4,el) == 1
        [~,et] = plants(Ex(el,:), Ey(el,:), ep, D_cu, edStress(el,:));  
        etd=et'-deltaTvec.*alpha_cu;
        es = D_cu*etd;
    else 
        [~,et] = plants(Ex(el,:), Ey(el,:), ep, D_nyl, edStress(el,:));
        etd = et'-deltaTvec.*alpha_nyl;
        es = D_nyl*etd;
    end
    stress(el,:)=es;
end
end