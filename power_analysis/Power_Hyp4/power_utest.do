



use "/Users/caterinagiannnetti/Dropbox (Salvati)/Michalis/Emotions_measurement/DATA/do_files/Power_Hyp4/dataset_hyp4.dta", clear


  
  
regress mg_relative_meantonic  mg_m_valence mg_m_valencesq if ind_obs==1 ,  noconstant
utest mg_m_valence mg_m_valencesq 



  capture program drop simregress
program simregress, rclass
    version 16
    // DEFINE THE INPUT PARAMETERS AND THEIR DEFAULT VALUES
    syntax, n(integer)          /// Sample size
          [alpha(real 0.05)    /// Alpha level
           mg_valence(real 0.706)       /// I use the value for Equal treatment ---> evidence for a U-shaped 
		   mg_valencesq(real 157) ///
             esd(real 0.987) ]      //  Standard deviation of the error
    quietly {
        // GENERATE THE RANDOM DATA
        clear
        set obs `n'
		*I use the value for the entire sample
        generate mg_m_valence= rnormal(-0.023,0.017) 
		generate mg_m_valencesq=mg_m_valence*mg_m_valence
        generate e = rnormal(0,`esd')
        generate mg_meantonic =  `mg_valence'*mg_m_valence + `mg_valencesq'*mg_m_valencesq + e
        // TEST THE NULL HYPOTHESIS
        regress mg_meantonic  mg_m_valence mg_m_valencesq
        utest  mg_m_valence mg_m_valencesq
		*estimates store full
        *regress mg_meantonic  mg_m_valence
        *estimates store reduced
        *lrtest full reduced
		
    }
    // RETURN RESULTS
	//*in this case, the power is to not reject the null
    return scalar reject = (1-r(p)<`alpha')
end


capture program drop power_cmd_simregress
program power_cmd_simregress, rclass
    version 16
    // DEFINE THE INPUT PARAMETERS AND THEIR DEFAULT VALUES
    syntax, n(integer)          /// Sample size
          [ alpha(real 0.05)    /// Alpha level
           mg_valence(real -18)       /// Age parameter
		   mg_valencesq(real -77) ///
             esd(real 0.987) ///
            reps(integer 100)]  //   Number of repetitions

    // GENERATE THE RANDOM DATA AND TEST THE NULL HYPOTHESIS
    quietly {
        simulate reject=r(reject), reps(`reps'):               ///
             simregress, n(`n') mg_valence(`mg_valence') mg_valencesq(`mg_valencesq')    ///
                          esd(`esd') alpha(`alpha')
        summarize reject
    }
    // RETURN RESULTS
    return scalar power = r(mean)
    return scalar N = `n'
    return scalar alpha = `alpha'
    return scalar mg_valence = `mg_valence'
    return scalar mg_valencesq = `mg_valencesq'
    return scalar esd = `esd'
end

power simregress, n(900(100)1300)  alpha(0.05) 
