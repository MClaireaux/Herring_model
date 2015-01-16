close all;
clear all;

%% DEFINE PARAMETERS
%Resolution of model
LengthMin = 16.; LengthMax = 200.; LengthStep = 2.;
RiskMin = 0.; RiskMax = 2.; RiskStep = 0.05;
AllocationStep = 0.05;
AgeMin = round(1); AgeMax = round(30);
StepsWithinYear = 4;  %High resolution: 24
NumberOfSexes = 1; %1: Only females, 2: Males too

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
ParameterSet = 'Flatfish';  %Optional: Specify here which parameter set from below to use; if string is empty parameters from above are used
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

%Array dimensions
LMax = (LengthMax-LengthMin)/LengthStep+1;
RMax = (RiskMax-RiskMin)/RiskStep+1;
AMax = 1/AllocationStep+1;

%% DECLARE VARIABLES
%(to save computing time)
%Fitness and strategy matrices
F(1:LMax,AgeMin:AgeMax) = 0.;
Strategy(1:2,1:LMax,AgeMin:AgeMax) = 0.;
Fitness(1:AMax,1:RMax) = 0.;

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

%Calculating foraging risk and allocation matrices for array-based
%optimization
ForagingRisk(1:AMax,1:RMax) = 0.;
for A = 1:AMax;
 ForagingRisk(A,1:RMax)=RiskMin:RiskStep:RiskMax;
end
Allocation(1:AMax,1:RMax) = 0.;
for R = 1:RMax
 Allocation(1:AMax,R)=0:AllocationStep:1;
end

ForagingRate(:,:) = RiskAsymptote .* ForagingRisk./(RiskHalfSat + ForagingRisk);  %Annual foraging rate coefficient
 
%% BACKWARD SIMULATION

for Age = AgeMax-1:-1:AgeMin %%%
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
     Survival(:,:) = exp(-SizeM(:,:) - ForagingM(:,:) - FishingM(:,:) - SizeIndependentM - GonadM(:,:) - SpawningM(:,:));
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
   
  
