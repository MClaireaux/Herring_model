close all;
clear all;

% DEFINE PARAMETERS
%Resolution of model
LengthMin = 16.; LengthMax = 200.; LengthStep = 2.;
RiskMin = 0.; RiskMax = 2.; RiskStep = 0.05;
qMin = 0.; qMax = 1.; qSlope =0.5; qstep = (RiskMax-RiskMin)/RiskStep; 
% Introduction of the q parameter, depends on ForgaingRisk 
%Value of qSlope is specific to one species (here : cod)
AllocationStep = 0.05;
AgeMin = round(1); AgeMax = round(30);
StepsWithinYear = 4;  %High resolution: 24
NumberOfSexes = 1; %1: Only females, 2: Males too

% To test SENSITIVITY to a parameter - add new natural mortality values
TestParameter = 1;     % 1: SizeIndependentM
% 2: RiskHalfSat
% 3: GSImax
% 4: SpawningMFactor_value(1)- for females
% 5: SpawningMFactor_value(2) - for males
% 6: SizeMCoeff
% 7: Fishing
Parameters = 1;

%FIGURES to plot - If i want to add sensitivity plots put a 1 in plot
PlotStrategies = 1;
PlotForward = 0;
PlotSensitivity = 1;
PlotPaper = 0;

PlotFig2 = 1;  %Assumptions
PlotFig3 = 0;  %Fishing in plaice
PlotFig4 = 0;  %Natural mortality components



%Net intake function and physiology
IntakeExponent = 0.70;  %[g body mass laid down per g^0.7]
RiskAsymptote = 6.; RiskHalfSat = 1; % RiskAsymptote/10.;  %Feeding-mortality trade-off
K = 0.95;  % Fulton's condition factor

%Fisheries selectivity
UseSelectivity = round(0);  %1: Use size selectivity function, otherwise max selectivity for all sizes
Slope = 0.0; L50 = 30.;  %Fishing mortality and size-selectivity

%Mortalities
Fishing = 0.0;  %Annual mortality rate from fishing
SizeMCoeff = 2.5 ; SizeMExp = -0.75;  % Natural mortality
SpawningMFactor_value(1) = 0.5; SpawningMFactor_value(2) = 1*SpawningMFactor_value(1); %Factor to multiply size-dependent mortality with if spawning that year, for 1=females and 2=males.
SizeIndependentM = 0.03; % Baseline mortality

%Other physiological and ecological parameters
CostOfGonadTissue = 2; GSImax = 0.15; GonadExp=2.; % A CostOfGonadTissue larger than one means gonads are more expensive to build than other tissue
MaleFitnessHalfSat = 50.; MaleGonadThreshold = 0.01;  % Diminishing returns for males, Gonadthreshold given in terms of GSI

%Other parameter combinations
ParameterSet = 'Cod';  %Optional: Specify here which parameter set from below to use; if string is empty parameters from above are used
if strcmp(ParameterSet,'Cod');
 LengthMin = 16.; LengthMax = 200; LengthStep = 2.;
 RiskMin = 0.; RiskMax = 2.; RiskStep = 0.05; AllocationStep = 0.02;
 AgeMin = round(1); AgeMax = round(30);
 IntakeExponent = 0.70; RiskAsymptote = 3.5; RiskHalfSat = 0.5 ; K = 0.9;
 Fishing = 0.0; UseSelectivity = round(0); Slope = 0.1; L50 = 30.;
 SizeMCoeff= 2.0; SizeMExp = -0.75; SizeIndependentM = 0.067;
 SpawningMFactor_value(1) = 0.; SpawningMFactor_value(2) = 0.0;
 CostOfGonadTissue = 1.; GSImax = 0.10; GonadExp=2.;
 MaleFitnessHalfSat = 50.; MaleGonadThreshold = 0.01;
elseif strcmp(ParameterSet,'CodTest');
 LengthMin = 16.; LengthMax = 200; LengthStep = 2.;
 RiskMin = 0.; RiskMax = 2.; RiskStep = 0.05; AllocationStep = 0.02;
 AgeMin = round(1); AgeMax = round(30);
 IntakeExponent = 0.72; RiskAsymptote = 3.7; RiskHalfSat = 0.6 ; K = 0.9;
 Fishing = 0.0; UseSelectivity = round(0); Slope = 0.1; L50 = 30.;
 SizeMCoeff= 1.5; SizeMExp = -0.75; SizeIndependentM = 0.09;
 SpawningMFactor_value(1) = 1; SpawningMFactor_value(2) = 0.0;
 CostOfGonadTissue = 1.; GSImax = 0.15; GonadExp=2.;
 MaleFitnessHalfSat = 50.; MaleGonadThreshold = 0.01;
elseif strcmp(ParameterSet,'Cod2');
 LengthMin = 16.; LengthMax = 200; LengthStep = 2.;
 RiskMin = 0.; RiskMax = 2.; RiskStep = 0.05; AllocationStep = 0.02;
 AgeMin = round(1); AgeMax = round(30);
 IntakeExponent = 0.70; RiskAsymptote = 4.5; RiskHalfSat = 0.5 ; K = 0.9;
 Fishing = 0.0; UseSelectivity = round(0); Slope = 0.1; L50 = 30.;
 SizeMCoeff= 2.0; SizeMExp = -0.75; SizeIndependentM = 0.067;
 SpawningMFactor_value(1) = 0.2; SpawningMFactor_value(2) = 0.0;
 CostOfGonadTissue = 1.; GSImax = 0.20; GonadExp=2.;
 MaleFitnessHalfSat = 50.; MaleGonadThreshold = 0.01;
elseif strcmp(ParameterSet,'2010Paper');
 LengthMin = 16.; LengthMax = 200; LengthStep = 2.;
 RiskMin = 0.; RiskMax = 2.; RiskStep = 0.05; AllocationStep = 0.02;
 AgeMin = round(1); AgeMax = round(30);
 IntakeExponent = 0.70; RiskAsymptote = 5.5; RiskHalfSat = 0.55 ; K = 0.9;
 Fishing = 0.0; UseSelectivity = round(0); Slope = 0.1; L50 = 30.;
 SizeMCoeff= 2.0 ; SizeMExp = -0.75; SizeIndependentM = 0.067;
 SpawningMFactor_value(1) = 0.0; SpawningMFactor_value(2) = 0.0;
 CostOfGonadTissue = 1.; GSImax = 0.25; GonadExp=2.;
 MaleFitnessHalfSat = 50.; MaleGonadThreshold = 0.01;
elseif strcmp(ParameterSet,'Flatfish');                                   %Flatfish parameters similar to plaice.
 LengthMin = 16.; LengthMax = 150; LengthStep = 1.;                       %F=0: Max size observed 100cm 7kg.
 RiskMin = 0; RiskMax = 2; RiskStep = 0.01; AllocationStep = 0.01;      %F=0.13: size at age similar to mean from ICES report 1957-2010
 AgeMin = round(1); AgeMax = round(30);
 IntakeExponent = 0.70; RiskAsymptote = 6; RiskHalfSat = 1 ; K = 0.95;
 Fishing = 0.13; UseSelectivity = round(0); Slope = 0.1; L50 = 30.;
 SizeMCoeff= 2.5 ; SizeMExp = -0.75; SizeIndependentM = 0.03;
 SpawningMFactor_value(1) = 0.5; SpawningMFactor_value(2) = 2*SpawningMFactor_value(1);
 CostOfGonadTissue = 2.; GSImax = 0.15; GonadExp=2.;
 MaleFitnessHalfSat = 50.; MaleGonadThreshold = 0.01;
elseif strcmp(ParameterSet,'Flatfish2');                                   %Flatfish parameters similar to plaice.
 LengthMin = 16.; LengthMax = 150; LengthStep = 2.;                       %F=0: Max size observed 100cm 7kg.
 RiskMin = 0.; RiskMax = 3.; RiskStep = 0.05; AllocationStep = 0.05;      %F=0.13: size at age similar to mean from ICES report 1957-2010
 AgeMin = round(1); AgeMax = round(30);
 IntakeExponent = 0.70; RiskAsymptote = 7.5; RiskHalfSat = 3 ; K = 0.95;
 Fishing = 0.13; UseSelectivity = round(0); Slope = 0.1; L50 = 30.;
 SizeMCoeff= 1.25 ; SizeMExp = -0.75; SizeIndependentM = 0.04;
 SpawningMFactor_value(1) = 1; SpawningMFactor_value(2) = 2*SpawningMFactor_value(1);
 CostOfGonadTissue = 1.; GSImax = 0.075; GonadExp=2.;
 MaleFitnessHalfSat = 50.; MaleGonadThreshold = 0.01;
elseif strcmp(ParameterSet,'Flatfish3');                                   %Flatfish parameters similar to plaice.
 LengthMin = 16.; LengthMax = 150; LengthStep = 2.;                       %F=0: Max size observed 100cm 7kg.
 RiskMin = 0.; RiskMax = 2.; RiskStep = 0.05; AllocationStep = 0.05;      %F=0.13: size at age similar to mean from ICES report 1957-2010
 AgeMin = round(1); AgeMax = round(30);
 IntakeExponent = 0.70; RiskAsymptote = 6; RiskHalfSat = 1 ; K = 0.95;
 Fishing = 0.0; UseSelectivity = round(0); Slope = 0.1; L50 = 30.;
 SizeMCoeff= 3 ; SizeMExp = -0.75; SizeIndependentM = 0.01;
 SpawningMFactor_value(1) = 0.5; SpawningMFactor_value(2) = 2*SpawningMFactor_value(1);
 CostOfGonadTissue = 2.; GSImax = 0.15; GonadExp=2.;
 MaleFitnessHalfSat = 50.; MaleGonadThreshold = 0.01;
elseif strcmp(ParameterSet,'Mackerel');
 LengthMin = 9.; LengthMax = 66; LengthStep = 1;
 RiskMin = 0.; RiskMax = 2.; RiskStep = 0.05; AllocationStep = 0.05;
 AgeMin = round(1); AgeMax = round(30);
 IntakeExponent = 0.70; RiskAsymptote = 4.5; RiskHalfSat = 0.5 ; K = 0.85;
 Fishing = 0.13; UseSelectivity = round(0); Slope = 0.1; L50 = 30.;
 SizeMCoeff= 1.6; SizeMExp = -0.75; SizeIndependentM = 0.06;
 SpawningMFactor_value(1) = 0.2; SpawningMFactor_value(2) = 0.0;
 CostOfGonadTissue = 1.; GSImax = 0.20; GonadExp=2.;
end

%LengthMin = 16.; LengthMax = 150; LengthStep = 2.;  %Use this resolution for faster execution, e.g. when testing / for FLATFISH
%RiskMin = 0.5; RiskMax = 1.5; RiskStep = 0.1; AllocationStep = 0.1;

%Fishing = 0;

FontName = 'Arial';
TickLabelWeight = 'normal';
AxisLabelWeight = 'bold';
TextWeight = 'normal';
TitleWeight = 'bold';
FontSize = 11;
TextLabelFontSize = 11;
PanelLabelFontSize = 11;
AxisLabelFontSize = 11;
PanelLabel = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t'};


if PlotFig2 == 1;
 FigRows = 1; FigCols = 3;
 figX = 6; figY = 6; distX = 1.8; distY = 1; marginB = 0.; marginT = 0.05; marginL = -0.3; marginR = 0.25;
 for row = 1:FigRows;
  posX(:,row) = (0:1:FigCols-1)'.*(distX+figX)+distX;  %#ok<SAGROW>
 end
 for col = 1:FigCols;
  posY(col,:) = (FigRows-1:-1:0).*(distY+figY)+distY; %#ok<SAGROW>
 end
 posX = posX+marginL; posX = reshape(posX,1,[]); squeeze(posX); posY = posY + marginB;  posY = reshape(posY,1,[]); squeeze(posY);
 width = FigCols*(distX+figX) + marginL + marginR;
 height = FigRows*(distY+figY) + marginB + marginT;
 h2 = figure(102);
 hFig2(1:FigRows*FigCols) = 0;  %Handle for panels
 set(h2,'Name','Longevity','Units','centimeters','OuterPosition',[1 1 width height+1.95]);
 set(h2,'PaperPositionMode','auto','PaperUnits','centimeters','PaperSize',[width height+1.95]);
 for panel = 1:FigRows*FigCols
  hFig2(panel) = subplot(FigRows,FigCols,panel);
  set(hFig2(panel),'Units','centimeters','Position',[posX(panel) posY(panel) figX figY],'FontSize',FontSize);
  hold on;
  if panel == 1;
   minx = 0; maxx = 155; miny = 0; maxy = 1.05;
   plot(minx:maxx,SizeMCoeff.*(minx:maxx).^SizeMExp,'-k','LineWidth',2);
   xlabel('Body length {\itL} (cm)','FontName',FontName,'FontSize',AxisLabelFontSize,'FontWeight',AxisLabelWeight);
   ylabel('Predation rate {\itM}{\fontsize{9}_{predation}} (year^{-1})','FontName',FontName,'FontSize',AxisLabelFontSize,'FontWeight',AxisLabelWeight);
  elseif panel == 2;
   minx = 0; maxx = 2.1; miny = 0; maxy = 4.5;
   plot(minx:0.01:maxx, RiskAsymptote.*(minx:0.01:maxx)./(RiskHalfSat+(minx:0.01:maxx)),'-k','LineWidth',2);
   plot([RiskHalfSat RiskHalfSat],[0 RiskAsymptote/2],'--k','LineWidth',2);
   plot([0 RiskHalfSat],[RiskAsymptote/2 RiskAsymptote/2],'--k','LineWidth',2);
   text(RiskHalfSat+0.04,0.25,'{\ith}_{1/2}','FontName',FontName,'FontWeight',TextWeight,'FontSize',FontSize);
   text(0.04,RiskAsymptote/2+0.25,'0.5\cdot{\ith}_{max}','FontName',FontName,'FontWeight',TextWeight,'FontSize',FontSize);
   xlabel('Growth strategy \it\fontname{Symbol}\fontsize{12}j','FontName',FontName,'FontSize',AxisLabelFontSize,'FontWeight',AxisLabelWeight);
   ylabel('Resource coefficient \itH   ','FontName',FontName,'FontSize',AxisLabelFontSize,'FontWeight',AxisLabelWeight);
  elseif panel == 3;
   minx = 0; maxx = 0.23; miny = 0; maxy = 270;
   plot(minx:0.01:maxx, 100.*((minx:0.01:maxx)./(GSImax)).^GonadExp,'-k','LineWidth',2);
   plot([GSImax GSImax],[0 100],'--k','LineWidth',2);
   plot([0 GSImax],[100 100],'--k','LineWidth',2);
   text(GSImax+0.005,15,'{\itQ}_{ref}','FontName',FontName,'FontWeight',TextWeight,'FontSize',FontSize);
   xlabel('Gonado-somatic index {\itQ} (%)','FontName',FontName,'FontSize',AxisLabelFontSize,'FontWeight',AxisLabelWeight);
   set(hFig2(panel),'Xtick',0:0.1:0.3,'XTickLabel',0:10:30,'Ytick',0:50:300,'FontName',FontName,'FontWeight',TickLabelWeight,'FontSize',FontSize);
   ylabel({'Extra mortality (% of {\itM}{\fontsize{9}_{predation}})'},'FontName',FontName,'FontSize',AxisLabelFontSize,'FontWeight',AxisLabelWeight);
  end
  axis([minx maxx miny maxy]);
  text(minx + 0.92*(maxx-minx),miny+0.94*(maxy-miny),PanelLabel(panel),'FontName',FontName,'FontSize',PanelLabelFontSize,'FontWeight','bold','Color','k');
  %axis square;
  grid off;
  box on;
  view(0,90);
  hold off;
 end
 print(h2,'-djpeg','-r300','fig2');%Export
 print(h2,'-depsc2','fig2');%Export
end

%Array dimensions
LMax = (LengthMax-LengthMin)/LengthStep+1;
RMax = (RiskMax-RiskMin)/RiskStep+1;
AMax = 1/AllocationStep+1;

% DECLARE VARIABLES
%(to save computing time)
%Fitness and strategy matrices
F(1:LMax,AgeMin:AgeMax) = 0.;
Strategy(1:2,1:LMax,AgeMin:AgeMax) = 0.;
Fitness(1:AMax,1:RMax) = 0.;
q(1:AMax,1:RMax) =0.;

%Other variables
Age=round(0); L=round(0); R=round(0); A=round(0); Harvest=round(0); Sex=round(0); Step=round(0); %Loop counters Age, Length, Risk, Allocation, Harvest, Sex, Step (within year)
Length(1:AMax,1:RMax)=0.; intL(1:AMax,1:RMax)=round(0); dL(1:AMax,1:RMax)=0.; NewL(1:AMax,1:RMax)=0.;
Weight(1:AMax,1:RMax)=0.; NewW(1:AMax,1:RMax)=0.; Gonads(1:AMax,1:RMax)=0.; GSI = 0.;
SizeM(1:AMax,1:RMax)=0.; SizeM_step(1:AMax,1:RMax)=0.; SizeMFactor(1:AMax,1:RMax)=0.;
GonadM(1:AMax,1:RMax)=0.; ForagingM(1:AMax,1:RMax)=0.;  SpawningM(1:AMax,1:RMax)=0.; SpawningMFactor(1:AMax,1:RMax)=0.;
FishingM(1:AMax,1:RMax)=0.; Selectivity(1:AMax,1:RMax) = 0.;
Survival(1:AMax,1:RMax)=0.; Intake(1:AMax,1:RMax)=0.;
Strat1(1:LMax,1:AgeMax-1) = 0.; Strat2(1:LMax,1:AgeMax-1) = 0.;
Cycles = 1.;
%Forward simulation
Ind(1:14,AgeMin:AgeMax,1:2) = 0.;  %Table of individual growth trajectory from forward simulation
iLength = 0.; iintL = round(0); idL = 0.;
iWeight = 0.; iGonads = 0.; iGSI = 0.;
iAllocation = 0.; iForagingRisk = 0.; iForagingRate = 0.; iIntake = 0.;
iSizeM = 0.; iSizeM_step = 0.; iForagingM = 0.; iGonadM = 0.; iSpawningM = 0.; iSurvival = 0.;
iFishingM = 0.; iSelectivity = 0.;

%FIGURE handles etc
hStrat = 1; hStrat1(1:2) = 0.; hStrat1surf(1:2) = 0.; hStrat2(1:2) = 0.; hStrat2surf(1:2) = 0.;
hForward = 2;
hSensitivity = 3;
hPaper = 4;
hFitness = 301.;

%Plaice data from ICES report WGNSSK 2011
%PlaiceWeight = [0.046555556	0.119685185	0.20812963	0.310814815	0.394037037	0.477296296	0.557037037	0.628074074	0.709685185	0.920259259];  %From ICES report, average 1957-2010
%PlaiceLength = [16.34335661	22.40872333	26.97863552	30.82971088	33.41234351	35.63051126	37.50484723	39.02735787	40.66656438	44.29091624]; %Calculated from length assuming K=1.05
PlaiceWeight = [0.046774194	0.118548387	0.211258065	0.313129032	0.394258065	0.46616129	0.534	0.610870968	0.687645161	0.861741935];
PlaiceLength = [16.4227611	22.38064984	27.14016609	30.89930058	33.41931085	35.34139854	36.97638228	38.6818666	40.24917661	43.34320242]; %Years 1980-2010

%Calculating foraging risk and allocation matrices for array-based
%optimization
ForagingRisk(1:AMax,1:RMax) = 0.;
for A = 1:AMax;
 ForagingRisk(A,1:RMax)=RiskMin:RiskStep:RiskMax;
end
Allocation(1:AMax,1:RMax) = 0.;
for R = 1:RMax
 Allocation(1:AMax,R)=0:AllocationStep:1;
 q(:,R)=qSlope.*ForagingRisk(:,R)+1;
 
end

if PlotFig3 == 1;
 Cycles = 1;
 FigRows = 1; FigCols = 3;
elseif PlotFig4 == 1;
 Cycles = 5;
 CalcThisParameter = [1 6 2 4 3];
 FigRows = 5; FigCols = 3;
 ParameterTitle = {'{\itM}_{fixed}';
                   '\itc';
                   '{\ith}_{1/2}'
                   '{\itu}'
                   '{\itq}_{ref}'};
end

for Cycle = 1:Cycles;
 if PlotFig3 ==1;
  TestParameter = 7;
 elseif PlotFig4 == 1;
  TestParameter = CalcThisParameter(Cycle);
  %Reset parameter
  if Cycle == 2;
   SizeIndependentM = OldValue;
  elseif Cycle == 3;
   SizeMCoeff = OldValue;
  elseif Cycle == 4;
   RiskHalfSat = OldValue;
  elseif Cycle == 5;
   SpawningMFactor_value(1) = OldValue;
  end
 end
 
 
 %LOOPS OVER PARAMETERS - Add New Values here - Factors below can use 0.5&2
 if TestParameter > 0;
  Parameters = 5;   %Don't change
 end
 if TestParameter == 1;
  OldValue = SizeIndependentM;
  ParameterValue = [0 0.015 0.03 0.06 0.09];
 elseif TestParameter == 2;
  OldValue = RiskHalfSat;
 elseif TestParameter == 3;
  OldValue = GSImax;
 elseif TestParameter == 4;
  OldValue = SpawningMFactor_value(1);
  %ParameterValue = [0 0.25 0.5 1 2];  %I changed this to vary it more, so we can discuss males and females from the same figure.   ****
 elseif TestParameter == 5;
  OldValue = SpawningMFactor_value(2);
 elseif TestParameter == 6;
  OldValue = SizeMCoeff;
 elseif TestParameter == 7;
  ParameterValue = [0 0.05 0.13 0.2 0.4];
 end
 Factor = [0.5 0.75 1 1.5 2];
 
 for Parameter = 1:Parameters;   %For looping over several parameter values - Add New Values natural mortality here
  if TestParameter == 1;
   SizeIndependentM = OldValue*Factor(Parameter);
   SizeIndependentM = ParameterValue(Parameter);
  elseif TestParameter == 2;
   RiskHalfSat = OldValue*Factor(Parameter);
  elseif TestParameter == 3;
   GSImax = OldValue*Factor(Parameter);
  elseif TestParameter == 4;
   SpawningMFactor_value(1) = OldValue*Factor(Parameter);
   %SpawningMFactor_value(1) = ParameterValue(Parameter);
  elseif TestParameter == 5;
   SpawningMFactor_value(2)= OldValue*Factor(Parameter);
  elseif TestParameter == 6;
   SizeMCoeff= OldValue*Factor(Parameter);
  elseif TestParameter == 7;
   Fishing = ParameterValue(Parameter);
  end
  ForagingRate(:,:) = RiskAsymptote .* ForagingRisk./(RiskHalfSat + ForagingRisk);  %Annual foraging rate coefficient
  for Sex = 1:NumberOfSexes;  % 1 is FEMALE, 2 is MALE
   F(:,:) = 0.;
   Strategy(:,:,:) = 0.;
   SpawningMFactor(:,:) = SpawningMFactor_value(Sex);
   SpawningMFactor(1,:) = 0.; %No spawning mortality if there is no allocation to reproduction
   if PlotStrategies == 1;
    figure(hStrat);                                                           % "
    hStrat1(Sex) = subplot(2,2,(Sex-1)*2+1);                                  % "
    [X,Y] = meshgrid(AgeMin:AgeMax-1,LengthMin:LengthStep:LengthMax);                    %Plots strategy figure
    hStrat1surf(Sex) = surf(X,Y,Strat1);                                      % "
    set(hStrat1surf(Sex),'ZDataSource','Strat1');                             % "
    xlabel('Age (years)');                                                    % "
    ylabel('Length (cm)');                                                    % "
    if Sex ==1;                                                               % "
     title('Allocation FEMALES');                                             % "
    else                                                                      % "
     title('Allocation MALES');                                               % "
    end                                                                       % "
    axis([AgeMin AgeMax-1 LengthMin LengthMax 0 1]); axis square; caxis([0 1]);          % "
    hStrat2(Sex) = subplot(2,2,(Sex-1)*2+2);                                  % "
    hStrat2surf(Sex) = surf(X,Y,Strat2);                                      % "
    set(hStrat2surf(Sex),'ZDataSource','Strat2');                             % "
    xlabel('Age (years)');                                                    % "
    ylabel('Length (cm)');                                                    % "
    if Sex ==1;                                                               % "
     title('Foraging risk FEMALES');                                          % "
    else                                                                      % "
     title('Foraging risk MALES');                                            % "
    end                                                                       % "
    axis([AgeMin AgeMax-1 LengthMin LengthMax 0 2]); axis square; caxis([0 2]);          % "
   end
   for Age = AgeMax-1:-1:AgeMin %%% Backward iteration
    for L = 1:LMax;
     Length(:,:) = LengthMin + (L-1)*LengthStep;  %cm
     Weight(:,:) = (K./100).*(Length.^3);
     Gonads(:,:) = 0.;
     SizeM(:,:) = 0.;
     FishingM(:,:)=0.;
     GonadM(:,:) = 0.;
     for Step=1:StepsWithinYear;
      SizeM_step(:,:) = (1./StepsWithinYear).*SizeMCoeff .* (Length(:,:).^SizeMExp);
      SizeM(:,:) = SizeM + SizeM_step;
      if UseSelectivity == 1;
       Selectivity(:,:) = 1./(1+exp(-Slope.*(Length(:,:)-L50)));
      else
       Selectivity(:,:) = 1.;
      end
      FishingM(:,:) = FishingM + (1./StepsWithinYear).*Fishing.*Selectivity;
      Intake(:,:) = (1./StepsWithinYear).*ForagingRate.*(Weight.^IntakeExponent);
      Weight(:,:) = Weight + (1-Allocation).*Intake;
      Gonads(:,:) = Gonads+max(0,(1/CostOfGonadTissue) .* Allocation .* Intake);
      GonadM(:,:) = GonadM + SizeM_step.*(((Gonads./(Weight+Gonads))./GSImax).^GonadExp);
      Length = min(((100./K).*Weight).^(1/3), LengthMax);
     end %Steps within year
     ForagingM(:,:) = ForagingRisk.*SizeM(:,:);
     SpawningM(:,:) = SpawningMFactor(:,:).*SizeM(:,:);
     Survival(:,:) = exp(-SizeM(:,:) - ForagingM(:,:) - (FishingM(:,:).*q(:,:)) - SizeIndependentM - GonadM(:,:) - SpawningM(:,:));
     intL(:,:) = max(1, min(floor((Length-LengthMin)./LengthStep)+1, LMax-1)); %%%% ??
     dL(:,:) = (Length-LengthMin)./LengthStep+1-intL; %%%% ??
     %GSI = Gonads ./ (Weight + Gonads);
     for A = 1:AMax;
      for R = 1:RMax;
       Fitness(A,R) = dL(A,R)*F(intL(A,R)+1,Age+1) + (1-dL(A,R))*F(intL(A,R),Age+1);  %Residual reproductive value = future fitness %%%Manque +1 ?
      end
     end 
     if Sex == 1;
      Fitness(:,:) = Survival .* (Fitness + Gonads);  %Reprod. at end of year, gonads added to residual fitness, everything discounted by survival
     elseif Sex == 2;
      Fitness(:,:) = Survival .* (Fitness + max(0,(Gonads-MaleGonadThreshold.*Weight)./(MaleFitnessHalfSat + Gonads)));
      %Fitness(:,:) = Survival .* (Fitness + Gonads*(Age/10));
     end
     [OptAFitness,OptA] = max(Fitness);  %First find optimal A (for each R)- matlab stores optimal fitness and index of optimal fitness in the two arrays %%% ????(making)
     [OptFitness,OptR] = max(OptAFitness,[],2);  %Then find optimal R as maximum of the many values from previous line.
     F(L,Age) = OptFitness; %%% OptAFitness =Valeur max de chaque colonne / OpA = Numéro de ligne ou se trouve OptAFitness
     Strategy(1,L,Age) = (OptA(OptR)-1)*AllocationStep;
     Strategy(2,L,Age) = RiskMin+(OptR-1)*RiskStep;
     %    surf(hFitness,Fitness);
     %    set(hFitness,'Xlim',[1 RMax],'Ylim',[1 AMax],'Zlim',[0 10000]);
     %    drawnow;
    end  %Length
    %if PlotStrategies == 1;
     %Strat1 = reshape(Strategy(1,:,AgeMin:AgeMax-1),LMax,[]);
     %Strat2 = reshape(Strategy(2,:,AgeMin:AgeMax-1),LMax,[]);
     %refreshdata(hStrat1surf(Sex));
     %refreshdata(hStrat2surf(Sex));
     %drawnow;
    %end
   end  %Age
   
   
   %FORWARD SIMULATION
   %Initiate first cohort
   %%%Création d'une matrice comprenant toutes les valeurs ci-dessous.
   %AgeMin = round(1) ; AgeMax=round(30)            -> ??round()
   iLength = LengthMin;
   iWeight = (K/100)*LengthMin^3;
   iSurvival = 1.;  %Survival until age
   Ind( 1,AgeMin,Sex) = iLength;            % 1: Length at age
   Ind( 2,AgeMin,Sex) = iWeight;            % 2. Weight at age
   Ind( 3,AgeMin,Sex) = 1.;                 % 3. Survival until age
   Ind( 4,AgeMin,Sex) = 0.;                 % 4. Gonads at end of age
   Ind( 5,AgeMin,Sex) = 0.;                 % 5. GSI
   Ind( 6,AgeMin,Sex) = 0.;                 % 6. Allcoation value
   Ind( 7,AgeMin,Sex) = 0.;                 % 7. Risk taken
   Ind( 8,AgeMin,Sex) = 0.;                 % 8. Intake
   Ind( 9,AgeMin,Sex) = 0.;                 % 9. Fitness at age
   Ind(10,AgeMin,Sex) = 0.;                 %10. Size-dependent predation mortality
   Ind(11,AgeMin,Sex) = 0.;                 %11. Fishing mortality
   Ind(12,AgeMin,Sex) = 0.;                 %12. Foraging mortality
   Ind(13,AgeMin,Sex) = 0.;                 %13. Gonad mortality
   Ind(14,AgeMin,Sex) = 0.;                 %14. Total mortality rate
   
   for Age = AgeMin:AgeMax-1;
    %Look up optimal strategy for each age
    iintL = max(1, min(floor((iLength-LengthMin)./LengthStep)+1, LMax-1));  %%% Valeurs discrètes de Longueur ?
    idL = (iLength-LengthMin)./LengthStep+1-iintL;                             %%% Gain de Longueur au temps i ?
    iAllocation   = idL*Strategy(1,iintL+1,Age) + (1.-idL)*Strategy(1,iintL,Age);
    iForagingRisk = idL*Strategy(2,iintL+1,Age) + (1.-idL)*Strategy(2,iintL,Age);
    iAllocation = max(0., min(iAllocation, 1.));        %%%Why ?
    iForagingRate = RiskAsymptote * iForagingRisk/(RiskHalfSat + iForagingRisk);  %Annual foraging rate
    iSizeM = 0.;
    iFishingM=0.;
    iGonads = 0.;
    iGonadM = 0.;
    iSpawningM = 0.;
    for Step=1:StepsWithinYear;
     iSizeM_step = (1/StepsWithinYear)*SizeMCoeff * (iLength^SizeMExp);
     iSizeM = iSizeM + iSizeM_step;
     if UseSelectivity == 1;
      iSelectivity = 1/(1+exp(-Slope*(iLength-L50)));
     else
      iSelectivity = 1;
     end
     iFishingM = iFishingM + (1/StepsWithinYear)*Fishing*iSelectivity;
     iIntake = (1/StepsWithinYear)*iForagingRate*(iWeight^IntakeExponent);
     iWeight = iWeight + (1-iAllocation)*iIntake;
     iGonads = iGonads+max(0,(1/CostOfGonadTissue) * iAllocation * iIntake);
     iGonadM = iGonadM + iSizeM_step*(((iGonads/(iWeight+iGonads))/GSImax)^GonadExp);
     iLength = min(((100/K)*iWeight)^(1/3), LengthMax);
    end %Steps within year
    iForagingM = iForagingRisk*iSizeM;
    if iAllocation > 1.e-10;
     iSpawningM = SpawningMFactor_value(Sex)*iSizeM;
    end
    iSurvival = iSurvival * exp(-iSizeM - iForagingM - iFishingM - SizeIndependentM - iGonadM - iSpawningM);
    iGSI = iGonads / (iWeight + iGonads);
    Ind( 1,Age+1,Sex) = iLength;                      %Individual states at beginning of next year (spawning takes place at beginning of year)
    Ind( 2,Age+1,Sex) = iWeight+iGonads;
    Ind( 3,Age+1,Sex) = iSurvival;
    Ind( 4,Age+1,Sex) = iGonads;
    Ind( 5,Age+1,Sex) = iGSI;
    Ind( 6,Age  ,Sex) = iAllocation;                  %Strategy for how they got there
    Ind( 7,Age  ,Sex) = iForagingRisk;
    Ind( 8,Age  ,Sex) = iForagingRate;                 %Foraging
    if Sex == 1;                                     %Fitness at age
     Ind(9,Age,Sex) = iGonads;
    elseif Sex == 2;
     Ind(9,Age,Sex) = max(0.,(iGonads-MaleGonadThreshold*iWeight)/(MaleFitnessHalfSat + iGonads));
    end
    Ind(10,Age  ,Sex) = iSizeM;            %Consequences for mortality
    Ind(11,Age  ,Sex) = iFishingM;
    Ind(12,Age  ,Sex) = iForagingM;
    Ind(13,Age  ,Sex) = iGonadM;
    Ind(14,Age  ,Sex) = iForagingM+iSizeM+iFishingM+SizeIndependentM;
   end  %Age
  end  %Sex
  
  if PlotForward == 1;
   figure(hForward);
   LineColor(1:3,10) = [0 0 0]; LineColor(1:3,2) = [0.6 0.6 0.6];  %Line colors for females and males
   for Sex = 1:NumberOfSexes;
    for Plot = 1:8;
     subplot(4,2,Plot);
     hold on;
     if Plot == 1;
      plot(Ind(1,:,Sex),'Color',LineColor(1:3,Sex),'LineWidth',0.5+3*((Parameter-1)/Parameters));
      if Parameter == 1;
       plot(PlaiceLength, 'ok');
      end
      ylabel('Length (cm)');
     elseif Plot == 2;
      plot(Ind(2,:,Sex)/1000,'Color',LineColor(1:3,Sex),'LineWidth',0.5+3*((Parameter-1)/Parameters));
      if Parameter == 1;
       plot(PlaiceWeight, 'ok');
      end
      ylabel('Weight (kg)');
     elseif Plot == 3;
      plot(Ind(4,:,Sex)/1000,'Color',LineColor(1:3,Sex),'LineWidth',0.5+3*((Parameter-1)/Parameters));
      ylabel('Gonads (kg)');
     elseif Plot == 4;
      plot(Ind(5,:,Sex)*100,'Color',LineColor(1:3,Sex),'LineWidth',0.5+3*((Parameter-1)/Parameters));
      ylabel('GSI (%)');
      set(gca,'YLim',[0 55]);
     elseif Plot == 5;
      plot(Ind(6,:,Sex),'Color',LineColor(1:3,Sex),'LineWidth',0.5+3*((Parameter-1)/Parameters));
      ylabel('Allocation');
      set(gca,'YLim',[0 1.05]);
     elseif Plot == 6;
      plot(Ind(7,:,Sex),'Color',LineColor(1:3,Sex),'LineWidth',0.5+3*((Parameter-1)/Parameters));
      ylabel('Foraging risk');
      set(gca,'YLim',[0 2.05]);
     elseif Plot == 7;
      plot(Ind(11,:,Sex),'Color',LineColor(1:3,Sex),'LineWidth',0.5+3*((Parameter-1)/Parameters));
      ylabel('Fishing mortality (year^{ -1})');
      set(gca,'YLim',[0 0.55]);
     elseif Plot == 8;
      plot(Ind(14,:,Sex),'Color',LineColor(1:3,Sex),'LineWidth',0.5+3*((Parameter-1)/Parameters));
      ylabel('Total mortality (year^{ -1})');
      set(gca,'YLim',[0 1.0]);
     end
     set(gca,'XLim',[0 25]);
    end  %Plot
   end   %Sex
   text(-6,-0.8,'Age (years)');
  end
  
  if PlotSensitivity == 1;
   figure(hSensitivity);
   LineColor(1:3,1) = [1 0.33 0]; LineColor(1:3,2) = LineColor(1:3,1);  %Line colors for decreased, ...
   LineColor(1:3,3) = [0 0 0];                                          %... normal, ...
   LineColor(1:3,4) = [0 0.6 0];  LineColor(1:3,5) = LineColor(1:3,4);  %... and increased parameter values.
   LineWidth = [2 1 2 1 2];
   for Plot = 1:8;
    subplot(4,2,Plot);
    hold on;
    if Plot == 1;
     plot(Ind(1,:,Sex),'Color',LineColor(1:3,Parameter),'LineWidth',LineWidth(Parameter));
     if Parameter == 1;
      plot(PlaiceLength, 'ok');
     end
     ylabel('Length (cm)');
    elseif Plot == 2;
     plot(Ind(2,:,Sex)/1000,'Color',LineColor(1:3,Parameter),'LineWidth',LineWidth(Parameter));
     if Parameter == 1;
      plot(PlaiceWeight, 'ok');
     end
     ylabel('Weight (kg)');
    elseif Plot == 3;
     plot(Ind(4,:,Sex)/1000,'Color',LineColor(1:3,Parameter),'LineWidth',LineWidth(Parameter));
     ylabel('Gonads (kg)');
    elseif Plot == 4;
     plot(Ind(5,:,Sex)*100,'Color',LineColor(1:3,Parameter),'LineWidth',LineWidth(Parameter));
     ylabel('GSI (%)');
     set(gca,'YLim',[0 55]);
    elseif Plot == 5;
     plot(Ind(6,:,Sex),'Color',LineColor(1:3,Parameter),'LineWidth',LineWidth(Parameter));
     ylabel('Allocation');
     set(gca,'YLim',[0 1.05]);
    elseif Plot == 6;
     plot(Ind(7,:,Sex),'Color',LineColor(1:3,Parameter),'LineWidth',LineWidth(Parameter));
     ylabel('Foraging risk');
     set(gca,'YLim',[0 2.05]);
    elseif Plot == 7;
     plot(Ind(11,:,Sex),'Color',LineColor(1:3,Parameter),'LineWidth',LineWidth(Parameter));
     ylabel('Fishing mortality (year^{ -1})');
     set(gca,'YLim',[0 0.55]);
    elseif Plot == 8;
     plot(Ind(14,:,Sex),'Color',LineColor(1:3,Parameter),'LineWidth',LineWidth(Parameter));
     ylabel('Total mortality (year^{ -1})');
     set(gca,'YLim',[0 1.0]);
    end
    set(gca,'XLim',[0 25]);
   end  %Plot
   text(-6,-0.8,'Age (years)');
  end
  if PlotPaper == 1;
   LineColor(1:3,1) = [1 0.33 0]; LineColor(1:3,2) = LineColor(1:3,1);  %Line colors for dereased, ...
   LineColor(1:3,3) = [0 0 0];                                          %... normal, ...
   LineColor(1:3,4) = [0 0.6 0];  LineColor(1:3,5) = LineColor(1:3,4);  %... and increased parameter values.
   LineWidth = [2 1 2 1 2];
   figure(hPaper);
   for Plot = 1:4;
    subplot(2,2,Plot);
    hold on;
    if Plot == 1;
     plot(Ind(1,:,Sex),'Color',LineColor(1:3,Parameter),'LineWidth',LineWidth(Parameter));
     if Parameter == 1;
      plot(PlaiceLength, 'ok');
     end
     ylabel('Length (cm)');
    elseif Plot == 2;
     plot(Ind(5,:,Sex)*100,'Color',LineColor(1:3,Parameter),'LineWidth',LineWidth(Parameter));
     ylabel('GSI (%)');
     set(gca,'YLim',[0 55]);
    elseif Plot == 3;
     plot(Ind(7,:,Sex),'Color',LineColor(1:3,Parameter),'LineWidth',LineWidth(Parameter));
     ylabel('Foraging risk');
     set(gca,'YLim',[0 3.05]);
    elseif Plot == 4;
     plot(Ind(14,:,Sex),'Color',LineColor(1:3,Parameter),'LineWidth',LineWidth(Parameter));
     ylabel('Total mortality (year^{ -1})');
     set(gca,'YLim',[0 1.0]);
    end
    set(gca,'XLim',[0 25]);
   end  %Plot
   text(-6,-0.8,'Age (years)');
  end
  CycleData(:,:,:,Parameter,Cycle) = Ind; %#ok<SAGROW>
 end % Parameters
end %Cycles


FigTitle = ['Fig1_SizeIndependentM.jpg       ';
 'Fig2_RiskHalfSat.jpg            ';
 'Fig3__GSImax.jpg                ';
 'Fig4_SpawningMFactor_females.jpg';
 'Fig5_SpawningMFactor_males.jpg  ';
 'Fig6_SizeMCoeff.jpg             ';
 'Fig7_Fishing.jpg                '];
if PlotSensitivity == 1;
 print(hSensitivity, 'Cod_SizeIndependentM_NoFishing.jpg', '-djpeg', '-r300'); %Code for saving image as jpeg and resolution (r300)
elseif PlotPaper == 1;
 print(hPaper,'Mackerel.jpg','-djpeg', '-r300');%Code for saving image as jpeg and resolution (r300)
end



%% Figure 3
if PlotFig3 == 1;
 FigRows = 1; FigCols = 4;
 figX = 6; figY = 6; distX = 1.5; distY = 1; marginB = 0.; marginT = 0.1; marginL = -0.1; marginR = 0.25;
 clear posX; clear posY;
 for row = 1:FigRows;
  posX(:,row) = (0:1:FigCols-1)'.*(distX+figX)+distX;  %#ok<SAGROW>
 end
 for col = 1:FigCols;
  posY(col,:) = (FigRows-1:-1:0).*(distY+figY)+distY; %#ok<SAGROW>
 end
 posX = posX+marginL; posX = reshape(posX,1,[]); squeeze(posX); posY = posY + marginB;  posY = reshape(posY,1,[]); squeeze(posY);
 width = FigCols*(distX+figX) + marginL + marginR;
 height = FigRows*(distY+figY) + marginB + marginT;
 h3 = figure(103);
 hFig3(1:FigRows*FigCols) = 0;  %Handle for panels
 set(h3,'Name','Longevity','Units','centimeters','OuterPosition',[1 1 width height+1.95]);
 set(h3,'PaperPositionMode','auto','PaperUnits','centimeters','PaperSize',[width height+1.95]);
 LineColor(1:3,1) = [0 0 0]; LineColor(1:3,2) = LineColor(1:3,1);  %Line colors for decreased, ...
 LineColor(1:3,3) = [0.7 0.7 0.7];                                          %... normal, ...
 LineColor(1:3,4) = [0 0 0];  LineColor(1:3,5) = LineColor(1:3,4);  %... and increased parameter values.
 LineWidth = [2 1 2 1 2];
 panel = 0;
 for row = 1:FigRows;
  for col = 1:FigCols;
   panel = panel +1;
   hFig3(panel) = subplot(FigRows,FigCols,panel);
   set(hFig3(panel),'Units','centimeters','Position',[posX(panel) posY(panel) figX figY],'FontSize',FontSize);
   hold on;
   if panel == 1;
    minx = 0; maxx = 21; miny = 0; maxy = 115;
    plot(PlaiceLength, 'ok');
    for Parameter = 1:Parameters;
     if Parameter > 2;
      plot(CycleData(1,:,1,Parameter),'Color',LineColor(1:3,Parameter),'LineWidth',LineWidth(Parameter),'LineStyle','-');
     else
      plot(CycleData(1,:,1,Parameter),'Color',LineColor(1:3,Parameter),'LineWidth',LineWidth(Parameter),'LineStyle','--');
     end
    end
    ylabel('Body length {\itL} (cm)','FontName',FontName,'FontSize',AxisLabelFontSize,'FontWeight',AxisLabelWeight);
   elseif panel == 2;
    maxy = 0.27;
    for Parameter = 1:Parameters;
     LastZeroAge = 0;
     for Age = AgeMin:AgeMax;
      if CycleData(5,Age,1,Parameter) == 0; LastZeroAge = min(Age,AgeMax-1); end
     end
     if Parameter > 2;
      plot(LastZeroAge+1:AgeMax,CycleData(5,LastZeroAge+1:AgeMax,1,Parameter),'Color',LineColor(1:3,Parameter),'LineWidth',LineWidth(Parameter),'LineStyle','-');
     else
      plot(LastZeroAge+1:AgeMax,CycleData(5,LastZeroAge+1:AgeMax,1,Parameter),'Color',LineColor(1:3,Parameter),'LineWidth',LineWidth(Parameter),'LineStyle','--');
     end
    end
    set(hFig3(panel),'Ytick',0:0.05:0.3,'YTickLabel',0:5:30,'FontName',FontName,'FontWeight',TickLabelWeight,'FontSize',FontSize);
    ylabel('GSI {\itQ} (%)','FontName',FontName,'FontSize',AxisLabelFontSize,'FontWeight',AxisLabelWeight);
   elseif panel == 3;
    miny = 0.85; maxy = 1.25;
    for Parameter = 1:Parameters;
     if Parameter > 2;
      plot(CycleData(7,:,1,Parameter),'Color',LineColor(1:3,Parameter),'LineWidth',LineWidth(Parameter),'LineStyle','-');
     else
      plot(CycleData(7,:,1,Parameter),'Color',LineColor(1:3,Parameter),'LineWidth',LineWidth(Parameter),'LineStyle','--');
     end
    end
    set(hFig3(panel),'Ytick',0:0.1:2,'FontName',FontName,'FontWeight',TickLabelWeight,'FontSize',FontSize);
    ylabel('Growth strategy \it\fontname{Symbol}\fontsize{12}j','FontName',FontName,'FontSize',AxisLabelFontSize,'FontWeight',AxisLabelWeight);
   elseif panel == 4;  %mortality
    miny = 0; maxy = 1.1999;
    for Parameter = 1:Parameters;
     if Parameter > 2;
      plot(CycleData(14,:,1,Parameter,row)-CycleData(11,:,1,Parameter,row),'Color',LineColor(1:3,Parameter),'LineWidth',LineWidth(Parameter),'LineStyle','-');
     else
      plot(CycleData(14,:,1,Parameter,row)-CycleData(11,:,1,Parameter,row),'Color',LineColor(1:3,Parameter),'LineWidth',LineWidth(Parameter),'LineStyle','--');
     end
    end
    ylabel('Natural mortality {\itM} (year^{-1})','FontName',FontName,'FontSize',AxisLabelFontSize,'FontWeight',AxisLabelWeight);
   end
   axis([minx maxx miny maxy]);
   if panel > (FigRows-1)*3; xlabel('Age (years)','FontName',FontName,'FontSize',AxisLabelFontSize,'FontWeight',AxisLabelWeight); end
   text(minx + 0.92*(maxx-minx),miny+0.94*(maxy-miny),PanelLabel(panel),'FontName',FontName,'FontSize',PanelLabelFontSize,'FontWeight','bold','Color','k');
   %axis square;
   grid off;
   box on;
   view(0,90);
   hold off;
  end
 end
 print(h3,'-djpeg','-r300','fig3');%Export
 print(h3,'-depsc2','fig3');%Export
end

%% Figure 4
if PlotFig4 == 1;
 FigRows = 5; FigCols = 4;
 figX = 3; figY = 3; distX = 1.2; distY = 0.7; marginB = 0.15; marginT = 0.05; marginL = -0.1; marginR = 0.25;
 FontSize = 8;
 TextLabelFontSize = 8;
 PanelLabelFontSize = 8;
 AxisLabelFontSize = 8;
 clear posX; clear posY;
 for row = 1:FigRows;
  posX(:,row) = (0:1:FigCols-1)'.*(distX+figX)+distX;  %#ok<SAGROW>
 end
 for col = 1:FigCols;
  posY(col,:) = (FigRows-1:-1:0).*(distY+figY)+distY; %#ok<SAGROW>
 end
 posX = posX+marginL; posX = reshape(posX,1,[]); squeeze(posX); posY = posY + marginB;  posY = reshape(posY,1,[]); squeeze(posY);
 width = FigCols*(distX+figX) + marginL + marginR;
 height = FigRows*(distY+figY) + marginB + marginT;
 h3 = figure(103);
 hFig3(1:FigRows*FigCols) = 0;  %Handle for panels
 set(h3,'Name','Longevity','Units','centimeters','OuterPosition',[1 1 width height+1.95]);
 set(h3,'PaperPositionMode','auto','PaperUnits','centimeters','PaperSize',[width height+1.95]);
 LineColor(1:3,1) = [0 0 0]; LineColor(1:3,2) = LineColor(1:3,1);  %Line colors for decreased, ...
 LineColor(1:3,3) = [0.7 0.7 0.7];                                          %... normal, ...
 LineColor(1:3,4) = [0 0 0];  LineColor(1:3,5) = LineColor(1:3,4);  %... and increased parameter values.
 LineWidth = [2 1 2 1 2];
 panel = 0;
 for row = 1:FigRows;
  for col = 1:FigCols;
   panel = panel +1;
   hFig3(panel) = subplot(FigRows,FigCols,panel);
   set(hFig3(panel),'Units','centimeters','Position',[posX(panel) posY(panel) figX figY],'FontSize',FontSize);
   hold on;
   if col == 1;
    minx = 0; maxx = 21; miny = 0; maxy = 170;
    %plot(PlaiceLength, 'ok');
    for Parameter = 1:Parameters;
     if Parameter > 2;
      plot(CycleData(1,:,1,Parameter,row),'Color',LineColor(1:3,Parameter),'LineWidth',LineWidth(Parameter),'LineStyle','-');
     else
      plot(CycleData(1,:,1,Parameter,row),'Color',LineColor(1:3,Parameter),'LineWidth',LineWidth(Parameter),'LineStyle','--');
     end
    end
    ylabel('Body length {\itL} (cm)','FontName',FontName,'FontSize',AxisLabelFontSize,'FontWeight',AxisLabelWeight);
   elseif col == 2;
    maxy = 0.27;
    for Parameter = 1:Parameters;
     LastZeroAge = 0;
     for Age = AgeMin:AgeMax;
      if CycleData(5,Age,1,Parameter,row) == 0; LastZeroAge = min(Age,AgeMax-1); end
     end
     if Parameter > 2;
      plot(LastZeroAge+1:AgeMax,CycleData(5,LastZeroAge+1:AgeMax,1,Parameter,row),'Color',LineColor(1:3,Parameter),'LineWidth',LineWidth(Parameter),'LineStyle','-');
     else
      plot(LastZeroAge+1:AgeMax,CycleData(5,LastZeroAge+1:AgeMax,1,Parameter,row),'Color',LineColor(1:3,Parameter),'LineWidth',LineWidth(Parameter),'LineStyle','--');
     end
    end
    set(hFig3(panel),'Ytick',0:0.05:0.3,'YTickLabel',0:5:30,'FontName',FontName,'FontWeight',TickLabelWeight,'FontSize',FontSize);
    ylabel('GSI {\itQ} (%)','FontName',FontName,'FontSize',AxisLabelFontSize,'FontWeight',AxisLabelWeight);
   elseif col == 3;  %growth strategy
    miny = 0; maxy = 2.15;
    for Parameter = 1:Parameters;
     if Parameter > 2;
      plot(CycleData(7,:,1,Parameter,row),'Color',LineColor(1:3,Parameter),'LineWidth',LineWidth(Parameter),'LineStyle','-');
     else
      plot(CycleData(7,:,1,Parameter,row),'Color',LineColor(1:3,Parameter),'LineWidth',LineWidth(Parameter),'LineStyle','--');
     end
    end
    ylabel('Growth strategy \it\fontname{Symbol}\fontsize{9}j','FontName',FontName,'FontSize',AxisLabelFontSize,'FontWeight',AxisLabelWeight);
   elseif col == 4;  %mortality
    miny = 0; maxy = 1.2;
    for Parameter = 1:Parameters;
     if Parameter > 2;
      plot(CycleData(14,:,1,Parameter,row)-CycleData(11,:,1,Parameter,row),'Color',LineColor(1:3,Parameter),'LineWidth',LineWidth(Parameter),'LineStyle','-');
     else
      plot(CycleData(14,:,1,Parameter,row)-CycleData(11,:,1,Parameter,row),'Color',LineColor(1:3,Parameter),'LineWidth',LineWidth(Parameter),'LineStyle','--');
     end
    end
    ylabel('Nat. mort. {\itM} (year^{-1})','FontName',FontName,'FontSize',AxisLabelFontSize,'FontWeight',AxisLabelWeight);
   end
   axis([minx maxx miny maxy]);
   if panel > (FigRows-1)*FigCols; xlabel('Age (years)','FontName',FontName,'FontSize',AxisLabelFontSize,'FontWeight',AxisLabelWeight); end
   if col == 1; text(minx + 0.05*(maxx-minx),miny+0.92*(maxy-miny),ParameterTitle(row),'FontName',FontName,'FontSize',PanelLabelFontSize,'FontWeight','normal','Color','k'); end
   text(minx + 0.88*(maxx-minx),miny+0.92*(maxy-miny),PanelLabel(panel),'FontName',FontName,'FontSize',PanelLabelFontSize,'FontWeight','bold','Color','k');
   %axis square;
   grid off;
   box on;
   view(0,90);
   hold off;
  end
 end
 print(h3,'-djpeg','-r300','fig4');%Export
 print(h3,'-depsc2','fig4');%Export
end
