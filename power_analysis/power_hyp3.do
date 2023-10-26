


*set trace on

use dataset_mediation.dta, clear


*sem (rad_a <-mg_relative_lf_hf  treat1 ) (mg_relative_lf_hf <-  treat1 ) 
*sum treat1 treat2 treat3
*mg_relative_edasymp mg_relative_ampsum

 
capture program drop simsem
program simsem, rclass
    version 17
    // PARSE INPUT
    syntax , n(integer)      ///           
        cov(string)         ///                                       
        [ alpha(real 0.05) var(string)]                             
    // COMPUTE POWER  
    *quietly {
       drop _all
       mat C =`cov'
       *mat m = `means'
	   *matrix list m
       drawnorm rad_a mg_relative_ampsum, ///
            n(`n')  cov(C)
	   gen treat1=rbinomial(1,0.375)
	   gen treat2=rbinomial(1, 0.125)
       gen treat3=rbinomial(1, 0.5)
       capture sem (rad_a <-mg_relative_ampsum treat1 treat2 )      ///
         (mg_relative_edasymp <-  treat1 treat2  )  
       local conv = e(converged)
       nlcom (_b[mg_relative_ampsum:treat1]* _b[rad_a:mg_relative_ampsum]) , post	  
	   local reject1 = cond(`conv'==1, r(table)[4,1]<`alpha', .)
    *}
	
    // RETURN RESULTS
    return scalar reject1 = `reject1'
    return scalar conv = `conv'
end


simulate  reject1=r(reject1)  converged=r(conv), reps(200) seed(333): simsem, n(1000)  cov(Sigma) alpha(0.05)


	   

capture program drop power_cmd_simsem
program power_cmd_simsem, rclass
   version 17
   // PARSE INPUT
   syntax, n(integer)                       ///
          cov(string)                       ///                     
          [ alpha(real 0.05)                ///        
                               ///
          reps(integer 100) ]                     
   // COMPUTE POWER
    simulate reject1=r(reject1) converged=r(conv), reps(`reps'):  ///
          simsem, n(`n')  cov(`cov') alpha(`alpha')
   // RETURN RESULTS
   return scalar N = `n'
   return scalar alpha = `alpha'
   summarize reject1 
   return scalar power = r(mean)
    summarize converged
   return scalar conv_rate = r(mean)
end



 power simsem, n(20000(10000)30000)  cov(Sigma) reps(200) alpha(0.05) 
 *table(N power1) graph
 
 