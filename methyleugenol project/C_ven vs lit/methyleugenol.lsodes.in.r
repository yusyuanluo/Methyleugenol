# ./mcsim.perc.model.R.exe perc.lsodes.in.R
Integrate (Lsodes, 1e-6, 1e-8, 1);

Simulation {
  
  PO_dose = 0.01908;           # micromol/kg bw
  Period = 1e10;          # Only one dose
  
  # measurements before end of exposure
  # and at [5' 30'] 2hr 18 42 67 91 139 163
  
  Print (C_ME_liv, C_MEO_liv, C_1HME_liv, C_3DMPOH_liv, C_2HDME_liv, C_3HMA_liv, C_1EU_liv, C_1HMES_liv, C_1HMEG_liv, C_1OME_liv, C_1OME_cyt_liv, C_ven, Q_total, 0, 0.01, 0.02, 0.05, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2, 3, 4, 5, 6, 7, 8, 12, 16, 20, 23);

}

END.
