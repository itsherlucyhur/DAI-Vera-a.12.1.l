function [FFR, VA, VB, shearStressA, shearStressB, pLEInmmHg, pLFInmmHg, Re, pB, f, Vs1, Vs2, Vs3, pLCInmmHg, pLSInmmHg, FA, FB] = calculateFFR(aucA, aucB, preQ, postQ, hB, L, rA, rB, sbp, roughness, fMethod, isStenosis, aucEntry, aucExit, rs1, rs2, rs3, entryQ, exitQ, numberOfStenosis)

    % constants:
    global g;                           
    global rho;                         
    global mu;                          
    
    DiaA = rA * 2;
    DiaB = rB * 2;
    hA = 0;
    g = 980;                            % Unit: cm/s^2
    rho = 1.05;                         % Unit: gm/cm^3
    mu = 0.03;                          % Unit: gm/cm.s
    maxVs2 = 300;                       % Unit: cm/s
    
    
    % step 1:
    % Unit for F is mL/s
    FA = preQ/aucA;
    FB = postQ/aucB;

    % step 2:
    % Unit for V is cm/s
    VA = FA / (pi * rA * rA);
    VB = FB / (pi * rB * rB);
    Vavg = (VA + VB) / 2;
    
    Vs1 = 0;
    Vs2 = 0;
    Vs3 = 0;
    pLC = 0;
    pLS = 0;
    pLSStepWise = 0;
    
    if (isStenosis == 1)
        % Calculating Vs1, Vs2 and Vs3
        for s = 1:numberOfStenosis
            Fs1(s) = entryQ(s) / aucEntry(s);
            Fs3(s) = exitQ(s) / aucExit(s);
            Vs1(s) = Fs1(s) / (pi * rs1(s) * rs1(s));
            Vs2(s) = Vs1(s) * ((rs1(s) / rs2(s))^2);
            if (Vs2(s) > maxVs2)
                Vs2(s) = maxVs2;
            end
            Vs3(s) = Fs3(s) / (pi * rs3(s) * rs3(s));
        end
    end

    % calculate pL:
    % Unit of pLF is gm/cm/s^2.
    [pLF, Re, f] = getPLF(L, DiaB, Vavg, rho, mu, fMethod, roughness); 
    if (isStenosis == 1)
        if (numberOfStenosis == 0)
            pLE = 0;                                        % Unit: gm/cm/s^2 
            pLC = 0;                                        % Unit: gm/cm/s^2 
            pLS = pLC + pLE;                                % Unit: gm/cm/s^2 
        else
            for s = 1:numberOfStenosis
                pLE(s) = ((Vs2(s) - Vs3(s))^2 / (2 * g)) * (rho * g);       % Unit: gm/cm/s^2 
                pLC(s) = (0.5 * ((Vs2(s) * Vs2(s)) / (2 * g))) * (rho * g);   % Unit: gm/cm/s^2 
                pLSStepWise(s) = pLC(s) + pLE(s);                                  % Unit: gm/cm/s^2 
            end
            pLS = sum(pLC) + sum(pLE);                                  % Unit: gm/cm/s^2 
        end
        pL = pLF + pLS;                                     % Unit: gm/cm/s^2
    else
        pLE = 0;                                            % Unit: gm/cm/s^2 
        pL = pLF + pLE;
    end

%     fprintf('sbp (mmHg), %.6f\n', sbp);
%     fprintf('aucA (mg/mLs), %.6f\n', aucA);
%     fprintf('aucB (mg/mLs), %.6f\n', aucB);
%     fprintf('preQ (mg), %.6f\n', preQ);
%     fprintf('postQ (mg), %.6f\n', postQ);
%     fprintf('FA (mL/s), %.6f\n', FA);
%     fprintf('FB (mL/s), %.6f\n', FB);
%     fprintf('rA (cm), %.6f\n', rA);
%     fprintf('rB (cm), %.6f\n', rB);
%     fprintf('VA (cm/s), %.6f\n', VA);
%     fprintf('VB (cm/s), %.6f\n', VB);
%     fprintf('VAvg (cm/s), %.6f\n', Vavg);
%     fprintf('aucEntry (mg/mLs), %.6f\n', aucEntry);
%     fprintf('aucExit (mg/mLs), %.6f\n', aucExit);
%     fprintf('entryQ (mg), %.6f\n', entryQ);
%     fprintf('exitQ (mg), %.6f\n', exitQ);
%     fprintf('rs1 (cm), %.6f\n', rs1);
%     fprintf('rs2 (cm), %.6f\n', rs2);
%     fprintf('rs3 (cm), %.6f\n', rs3);
%     fprintf('Fs1 (mL/s), %.6f\n', Fs1);
%     fprintf('Fs3 (mL/s), %.6f\n', Fs3);
%     fprintf('Vs1 (cm/s), %.6f\n', Vs1);
%     fprintf('Vs2 (cm/s), %.6f\n', Vs2);
%     fprintf('Vs3 (cm/s), %.6f\n', Vs3);
%     fprintf('pLF (gm/cm/s^2), %.6f\n', pLF);
%     fprintf('pLE (gm/cm/s^2), %.6f\n', pLE);
%     fprintf('pLC (gm/cm/s^2), %.6f\n', pLC);
%     fprintf('pLS (gm/cm/s^2), %.6f\n', pLS);
%     fprintf('pL (gm/cm/s^2), %.6f\n', pL);
    
    
    
    % Calculate deltaP (Unit is in g/cm/s^2)
    deltaP = (0.5 * rho * (VA*VA - VB*VB)) + (rho * g * (hA - hB)) - pL;
%     fprintf('deltaP (gm/cm/s^2) = %.6f\n', deltaP);
    % Converting from g/cm/s^2 to Pascal 
    deltaP = deltaP / 10;       
%     fprintf('deltaP (Pa) = %.6f\n', deltaP);
    % Converting from Pascal to mmHg
    deltaP = deltaP * 0.0075;
%     fprintf('deltaP (mmHg) = %.6f\n', deltaP);

    % step 3:
    % Both deltaP and sbp are in mmHg
    FFR = (deltaP + sbp) / sbp;
%      fprintf('FFR, %.6f\n', FFR);
    
    % Shear Stress for A:
    gammaA = FA / (pi * rA^3);
    shearStressA = gammaA * mu;
    
    % Shear Stress for B:
    gammaB = FB / (pi * rB^3);
    shearStressB = gammaB * mu;

    % Calculate pB:
    pB = deltaP + sbp;
    
    % Converting PLE and PLF back to mmHg from gm/cm/s^2 for including them in interim
    % excel sheet.
    pLFInmmHg = pLF / 10 * 0.0075;
    pLEInmmHg = pLE / 10 * 0.0075;
    pLCInmmHg = pLC / 10 * 0.0075;
    pLSInmmHg = pLSStepWise / 10 * 0.0075;
%     fprintf('pLF (mmHg), %.6f\n', pLFInmmHg);
%     fprintf('pLE (mmHg), %.6f\n', pLEInmmHg);
%     fprintf('pLC (mmHg), %.6f\n', pLCInmmHg);
%     fprintf('pLS (mmHg), %.6f\n', pLSInmmHg);
%     fprintf('pB (mmHg), %.6f\n', pB);
%     fprintf('====================================\n');
end

function [pLF, Re, f] = getPLF(L, Dia, V, rho, mu, fMethod, roughness)
    if (fMethod == 'Churchill')
        [f, Re] = getfByChurchil(rho, Dia, V, mu);
    end
    
    if (fMethod == 'Colebrook')
        [f, Re] = getfByColebrook(rho, Dia, V, mu, roughness);
    end
    pLF = f * (L/Dia) * (rho * V*V / 2); 
end

function [f, Re] = getfByChurchil(rho, Dia, V, mu)
    Re = getRe(rho, Dia, V, mu);
    C = getC(Re, Dia);
    D = getD(Re);
    
    f = 8 * ((8/Re)^12 + 1/((C+D)^1.5))^(1/12);
end

function [f, Re] = getfByColebrook(rho, Dia, V, mu, roughness)
    Re = getRe(rho, Dia, V, mu);
    
    if (Re > 4000)
        % Turbulant
        e = roughness;
        r = Dia / 2;
        f = getDarcyFrictionFactor(Re, r, e);
    elseif (Re < 2000)
        % Laminar
        f = 64/Re;
    else
        choice = questdlg('Re Between 2000 and 4000. Please Choose Flow Type', ...
	                'Manual Flow Type', ...
	                'Turbulent','Laminar','Laminar');
        switch choice
            case 'Turbulent'
                e = roughness;
                r = Dia / 2;
                f = getDarcyFrictionFactor(Re, r, e);
            case 'Laminar'
                f = 64/Re;
        end
    end
end

function Re = getRe(rho, Dia, V, mu)
    Re = rho * Dia * V / mu;
end

function D = getD(Re)
    D = (37530/Re)^16;
end

function C = getC(Re, Dia)
    epsilon = 0;
    fractionRe = (7/Re)^0.9;
    fractionD = 0.27 * (epsilon/Dia);
    fraction = 1 / (fractionRe + fractionD);
    
    C = (2.457 * log(fraction))^16;
end

function f = getDarcyFrictionFactor(Re, r, e)
    startingGuess = 0.005;
    endingGuess = 0.5;
    stepSize = 0.0001;

    counter = 1;
    for f = startingGuess:stepSize:endingGuess
        % -Inf if f = 0
        value = 1.74 - 2 * log10(e/r + 18.7/Re*1/sqrt(f)) - 1/sqrt(f);
        allValues(counter) = value;
        frictionFactors(counter) = f;
        counter = counter + 1;
    end

    [~, minIdx] = min(abs(allValues));
    f = frictionFactors(minIdx);
end