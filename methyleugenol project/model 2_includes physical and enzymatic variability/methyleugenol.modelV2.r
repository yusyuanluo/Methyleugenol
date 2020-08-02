#------------------------------------------------------------------------------
# methyleugenol.model.R (This file is sourced from mcsim-6.1.0/examples/perc)
# A multi-compartment model of ME.
# Copyright (c) 1993-2008 Free Software Foundation, Inc.
#------------------------------------------------------------------------------
# MW of ME = 178.23 g/mol
# States are quantities of ME and metabolite formed, they can be output

States = {Q_fat,        # Quantity of ME in the fat (micromol)
          Q_rp,         #   ...   in the rapidly-perfused compartment (micromol)
          Q_sp,         #   ...   in the slowly-perfused compartment (micromol)
          Q_liv,        #   ...   in the liver (micromol)
          Q_MEO,        #   ...   quantity of MEO formed (micromol)
          Q_1HME,       #   ...   quantity of 1HME formed (micromol)
          Q_3DMPOH,     #   ...   quantity of 3DMPOH formed (micromol)
          Q_2HDME,      #   ...   quantity of 2HDME formed (micromol)
          Q_3HMA,       #   ...   quantity of 3HMA formed (micromol)
          Q_1EU,        #   ...   quantity of 1EU formed (micromol)
          Q_1HMES,      #   ...   quantity of 1HMES formed (micromol)
         Q_1HMEG,      #   ...   quantity of 1HMEG formed (micromol)
         Q_1OME     #   ...   quantity of 1OME formed (micromol) 
    }; 

Outputs = {C_ME_liv,               # micromol/l in the liver
  C_MEO_liv,                       # MEO micromol/l in the liver
  C_1HME_liv,                      # 1HME micromol/l in the liver 
  C_3DMPOH_liv,                    # 3DMPOH micromol/l in the liver
  C_2HDME_liv,                     # 2HDME micromol/l in the liver
  C_3HMA_liv,                      # 3HMA micromol/l in the liver
  C_1EU_liv,                       # 1EU micromol/l in the liver
  C_1HMES_liv,                     # 1HMES micromol/l in the liver
  C_1HMEG_liv,                     # 1HMEG micromol/l in the liver 
  C_1OME_liv,                      # 1OME micromol/l  in the liver 
  Q_total,
  C_ven};               # ... in the venous blood


Inputs = {PO_dose, R_ing};                #Oral gavage dose (mg/kg) 


# Nominal parameter values
# ========================
# Units:
# Volumes: liter
# Time:    hr
# Vmax:    micromol / hr
# Km:      micromol/L
# Flows:   liter / hr

# Exposure modeling
# -----------------
PO_dose   = 0.019; # #Ingested dose (micromol/ kg)
Oral_dose;
Period   = 1e3; # period of the exposure/no exposure cycle
Tlag = 0.0; # absorption lag time
Ka = 1.0; #absorption rate constant (1/hr)
R_ing = PerExp (Oral_dose, Period, 0.0, Ka);


# Physiological and pharmacokinetic parameters
# --------------------------------------------
#Bodywt= 63.8;     #total body weight (kg)  ##updated ###
Bodywt=63.8;

# Percent mass of tissues with ranges shown  #updated####
Pct_M_fat  = .214;   # % total body mass
Pct_M_liv = .026;   # liver, % of lean body mass
Pct_M_rp  = .05;   # well perfused tissue, % of lean body mass
Pct_M_sp  = .517;   # poorly perfused tissue, % of lean body mass
Pct_M_blood = .079;   #% total body mass

# Percent blood flows to tissues ###updated###
Pct_Flow_fat = .052;
Pct_Flow_liv = .227;
Pct_Flow_rp  = .473; # will be recomputed in scale
Pct_Flow_sp  = .248;

# Tissue/blood partition coeficients #updated###
PC_fat = 103;
PC_liv = 6.2;
PC_rp  = 6.2;
PC_sp  = 3.9;
PC_1HME = 1.4; 

#scaled Vmax to whole liver (micromol/(hr) liver
Vmax_MEO_2B6= .672;
Vmax_MEO_2E1= .324;
Vmax_1HME_1A2=.86;
Vmax_1HME_2C9=1.21;
Vmax_1HME_2C19=.21;
Vmax_1HME_2D6=.055;
Vmax_1HME_3A4=2.089;
Vmax_3DMPOH=.75;
Vmax_2HDME=.19;
Vmax_1EU_1A2=.154;
Vmax_3HMA=.40;
Vmax_1HMEG_1A9= .098;
Vmax_1HMEG_2B7= .292;
Vmax_1OME= 44.441;
Vmax_1HMES=.998;

#sc_Vmax = .0026;     # scaling coeficient of body weight for Vmax
 # Km micromol/L

Km_MEO = 23.7; 
Km_1HME = 404;
Km_3DMPOH=161;
Km_2HDME = 415;
Km_1EU = 13.6;
Km_3HMA = 1097;
Km_1HMEG = 2393;
Km_1OME = 1567; #updated
Km_1HMES = 282;##updated

#total blood flow (L/hr) #updated###
Flow_tot=323;
# Scaled parameters
# -----------------
# The following parameters are calculated from the above values in the Scale 
# section before the start of each simulation.
# They are left uninitialized here.

V_fat;           # Actual volume of tissues
V_liv;
V_rp;
V_sp;

Flow_fat;        # Actual blood flows through tissues
Flow_liv;
Flow_rp;
Flow_sp;
#Flow_alv = 0;        # Alveolar ventilation rate


#---------------------------------------------------------
# Scale
# Scale certain model parameters and resolve dependencies
# between parameters. Generally the scaling involves a
# change of units, or conversion from percentage to actual
# units.
#---------------------------------------------------------

Initialize {
  #calculate oral dose
  Oral_dose = PO_dose * Bodywt;
  # Volumes scaled to actual volumes
  V_fat  = Pct_M_fat  * Bodywt/0.92;        # density of fat = 0.92 g/ml
  V_liv  = Pct_M_liv * Bodywt;
  V_rp   = Pct_M_rp  * Bodywt;
  V_blood = Pct_M_blood *Bodywt;
  V_sp   = (1- Pct_M_fat - Pct_M_liv - Pct_M_rp - Pct_M_blood) * Bodywt; 
  
   # Calculate Flow_alv from total pulmonary flow
  #Flow_alv = Flow_pul * 0.7;
  
  # Calculate total blood flow from the alveolar ventilation rate and 
  # the V/P ratio.
  #Flow_tot = Flow_alv / Vent_Perf;
  
  # Calculate actual blood flows from total flow and percent flows ###updated ###
  Flow_fat = Pct_Flow_fat * Flow_tot;
  Flow_liv = Pct_Flow_liv * Flow_tot;
  Flow_sp  = Pct_Flow_sp  * Flow_tot;
  Flow_rp  = Flow_tot - Flow_fat - Flow_liv - Flow_sp;
  
  # Vmax (mass/time) for Michaelis-Menten metabolism is scaled
  # by multiplication of bdw^0.7 
  #Vmax = sc_Vmax * exp (0.7 * log (LeanBodyWt));
  
} # End of model initialization


#---------------------------------------------------------
# Dynamics
# Define the dynamics of the simulation. This section is
# calculated with each integration step. It includes
# specification of differential equations.
#---------------------------------------------------------

Dynamics {
  
  # Venous blood concentrations at the organ exit ###ok
  Cout_fat = Q_fat / (V_fat * PC_fat);
  Cout_rp  = Q_rp  / (V_rp  * PC_rp);
  Cout_sp  = Q_sp  / (V_sp  * PC_sp);
  Cout_liv = Q_liv / (V_liv * PC_liv);
  # Sum of Flow * Concentration for all compartments  ##ok
  dQ_ven = Flow_fat * Cout_fat + Flow_rp * Cout_rp +
    Flow_sp * Cout_sp + Flow_liv * Cout_liv;

  # Venous blood concentration  #OK
  C_ven =  dQ_ven / Flow_tot;
  
  # Arterial blood concentration
  # Convert input given in ppm to mg/l to match other units
  C_art = dQ_ven / Flow_tot;
  
  # Alveolar air concentration
  #C_alv = C_art / PC_art;
  
  # Exhaled air concentration
  #C_exh = 0.7 * C_alv + 0.3 * C_inh / PPM_per_mg_per_l;
  
  # Quantity metabolized in liver###updated with isoforms
  dQMEO_liv = (Vmax_MEO_2B6 + Vmax_MEO_2E1) * V_liv * 1000* ((Q_liv / V_liv)/PC_liv) / (Km_MEO + ((Q_liv / V_liv)/PC_liv));
  dQ1HME_liv = (Vmax_1HME_3A4 + Vmax_1HME_2C19 + Vmax_1HME_2C9 + Vmax_1HME_2D6 + Vmax_1HME_3A4) * V_liv * 1000 * ((Q_liv / V_liv)/PC_liv) / (Km_1HME + ((Q_liv / V_liv)/PC_liv));
  dQ3DMPOH_liv = Vmax_3DMPOH * V_liv * 1000 * ((Q_liv / V_liv)/PC_liv) / (Km_3DMPOH + ((Q_liv / V_liv)/PC_liv));
  dQ2HDME_liv = Vmax_2HDME * V_liv * 1000 * ((Q_liv / V_liv)/PC_liv) / (Km_2HDME + ((Q_liv / V_liv)/PC_liv));
  dQ3HMA_liv = Vmax_3HMA * V_liv * 1000 * ((Q_liv / V_liv)/PC_liv) / (Km_3HMA + ((Q_liv / V_liv)/PC_liv));
  dQ1EU_liv = Vmax_1EU_1A2 * V_liv * 1000 * ((Q_liv / V_liv)/PC_liv) / (Km_1EU + ((Q_liv / V_liv)/PC_liv));
  dQ1HMES_liv = Vmax_1HMES * V_liv * 1000 * ((Q_1HME / V_liv)/PC_1HME) / (Km_1HMES + ((Q_1HME / V_liv)/PC_1HME));
  dQ1HMEG_liv = (Vmax_1HMEG_2B7 + Vmax_1HMEG_1A9) * V_liv * 1000 * ((Q_1HME / V_liv)/PC_1HME) / (Km_1HMEG + ((Q_1HME / V_liv)/PC_1HME));
  dQ1OME_liv = Vmax_1OME * V_liv * 1000 * ((Q_1HME / V_liv)/PC_1HME) / (Km_1OME + ((Q_1HME / V_liv)/PC_1HME));
  
  
  
  
  # Differentials for quantities
  dt (Q_fat) = Flow_fat * (C_art - Cout_fat);
  dt (Q_rp)  = Flow_rp  * (C_art - Cout_rp);
  dt (Q_sp)  = Flow_sp  * (C_art - Cout_sp);
  dt (Q_liv) = R_ing * Ka + Flow_liv * (C_art - Cout_liv) - dQMEO_liv - dQ1HME_liv - dQ3DMPOH_liv - dQ2HDME_liv - dQ3HMA_liv -dQ1EU_liv;
  dt (Q_1HME) = dQ1HME_liv - dQ1OME_liv - dQ1HMEG_liv - dQ1HMES_liv; ##updated
  # Metabolite formation
  dt (Q_MEO) = dQMEO_liv;
  dt (Q_3DMPOH) = dQ3DMPOH_liv;
  dt (Q_2HDME) = dQ2HDME_liv;
  dt (Q_1EU) = dQ1EU_liv;
  dt (Q_3HMA) = dQ3HMA_liv;
  dt (Q_1HMES) = dQ1HMES_liv;
  dt (Q_1HMEG) = dQ1HMEG_liv;
  dt (Q_1OME) = dQ1OME_liv;
  
} # End of Dynamics


#---------------------------------------------------------
# CalcOutputs 
# The following outputs are only calculated just before values
# are saved.  They are not calculated with each integration step.
#---------------------------------------------------------

CalcOutputs {
  Q_total= Q_fat + Q_rp + Q_sp + Q_liv + Q_MEO + Q_1HME + Q_3DMPOH + Q_2HDME + Q_3HMA + Q_1EU + Q_1HMES + Q_1HMEG + Q_1OME;
  # Liver concentration
  C_ME_liv = Q_liv / V_liv;
  C_MEO_liv = Q_MEO / V_liv;
  C_3DMPOH_liv = Q_3DMPOH / V_liv;
  C_2HDME_liv = Q_2HDME / V_liv;
  C_1EU_liv = Q_1EU / V_liv;
  C_3HMA_liv = Q_3HMA / V_liv;
  C_1HME_liv = Q_1HME / V_liv;
  C_1HMES_liv = Q_1HMES / V_liv;
  C_1HMEG_liv = Q_1HMEG / V_liv;
  C_1OME_liv = Q_1OME/ V_liv;

} # End of output calculation

End.
