SetPoints ("", "setpts.out", 0, Bodywt, Pct_M_fat, Pct_M_liv, Pct_M_rp, Pct_M_sp, Pct_M_blood, Flow_tot, Pct_Flow_fat, Pct_Flow_liv, Pct_Flow_rp, Pct_Flow_sp, Vmax_1HME_1A2, Vmax_1HME_2C9, Vmax_1HME_2C19, Vmax_1HME_2D6, Vmax_1HME_3A4, Vmax_MEO_2B6, Vmax_MEO_2E1, Vmax_1EU_1A2, Vmax_1HMEG_1A9, Vmax_1HMEG_2B7, Vmax_1OME, Vmax_1HMES, Km_1OME, Km_1HMES);

Simulation { 
  PO_dose = 0.002632;
  Print (C_1HMES_liv, 24);
  } End.

