% INITIAL STRESS FIELD FOR IN PLANE, 2D SIMULATION OF A STRIKE-SLIP FAULT
% by Louise Jeandet Ribes, Sept. 2022
% after Jeandet Ribes et. al, 2022 (in prep)

% This code checks if an initial stress field actually
% corresponds to a strike-slip context in 3D, taking into account the out-of-plane stress tensor

clc;clear;close all

%% INPUTS - change only this section

% In-plane stresses
Sxx = -6.7263e+07;
Syy = -8.4336e+07;
Sxy = 2.3455e+07;

% Poisson ratio
nu = 0.2749; 

%% Compute principal stresses

Szz = nu*(Sxx+Syy); % out-of-plane stress
S = [Sxx Sxy 0;Sxy Syy 0;0 0 Szz]; % stress tensor
PS = eig(S); % principal stresses

if find(Szz==PS)==2
    disp('this is a stress field for strike-slip faulting')
elseif find(Szz==PS)==3
    disp('this is a stress field for reverse faulting')
end

gamma_test = Sxx/Syy;
f0_test = -Sxy/Syy;

%% Plot stress field

% PLOT CRITERION 
gamma = [0:0.01:5];f0 = [0:0.001:1];
gamma2 = repmat(gamma,numel(f0),1);f02 = repmat(f0',1,numel(gamma));
Psi_2D = 0.5*atan2d(2.*f02,(gamma2-1));

f1 =  sqrt((gamma2-1).^2./(gamma2+1).^2 + 4*f02.^2./(gamma2+1).^2);

Psi_2D(1-2*nu > f1) = NaN; % Condition for S3 > S2 (convention : positive in tension)
Psi_2D(f1 > 1) = NaN; % Condition for compressive stresses

figure(1);
clf
[C,h] = contourf(gamma,f0,Psi_2D,0:5:90,'-k');
colormap([0.9 0.9 0.9]);hold on
clabel(C,h,[5,10,20,30,40,50,70],'LabelSpacing',300,'FontSize',16,'Color','k');
drawnow();
txt = get(h,'TextPrims');
v = str2double(get(txt,'String'));

% label axis and name areas 
ylabel('$f_0  = -\sigma^o_{xy} / \sigma^o_{yy}$ ','Interpreter','latex','FOntSize',26)
xlabel('$\gamma = \sigma^o_{xx} / \sigma^o_{yy}$ ','Interpreter','latex','FOntSize',26)
text(1,0.12,{'forbidden'},'FOntSize',20,...
     'HorizontalAlignment','Left','Interpreter','latex')
text(1,0.06,{'regime'},'FOntSize',20,...
     'HorizontalAlignment','Left','Interpreter','latex')
text(0.25,0.7,{'tensile'},'FOntSize',20,...
     'Rotation',60,'Interpreter','latex')

grid off
set(gca,'layer','top')
set(gca,'TickLabelInterpreter','latex')
set(gcf,'Color','w')
ax = gca;
ax.GridColor = [0 0 1]; 
h.Annotation.LegendInformation.IconDisplayStyle='off';

% PLOT YOUR PARAMETERS
figure(1);
plot(gamma_test,f0_test,'r.','markersize',20,'linewidth',2)

% fix labels
set(txt(1),'String',sprintf('%s',[num2str(v(1)),'°' ]))
for ii=2:length(v)
    set(txt(ii),'String',sprintf('%s',[num2str(v(ii)),'°' ]))
end