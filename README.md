# Inducing Thought Processes

This repository contains data collected for:
Schulte-Mecklenbeck, M., Kühberger, A., Gagl, B., & Hutzler, F. (2017). Inducing Thought Processes: Bringing Process Measures and Cognitive Processes Closer Together. Journal of Behavioral Decision Making.

The challenge in inferring cognitive processes from observational data is to correctly align overt behavior with its covert cognitive process. To improve our understanding of the overt–covert mapping in the domain of decision making, we collected eye-movement data during decisions between gamble-problems. Participants were either free to choose or instructed to use a specific choice strategy (maximizing expected value or a choice heuristic). We found large differences in looking patterns between free and instructed choices. However, looking patterns provided no support for the common assumption that attention is equally distributed between outcomes and probabilities, even when participants were instructed to maximize expected value. Eye-movement data are to some extent ambiguous with respect to underlying cognitive processes.

Variable description:
~~~~
 $ vp         : num  1 1 1 1 1 1 1 1 1 1 ... : subject number
 $ list       : Factor w/ 8 levels "l1","l2","l3",..: 1 1 1 1 1 1 1 1 1 1 ... : counter balancing list
 $ gamble     : chr  "1" "1" "1" "1" ... : gamble number
 $ stimcode   : Factor w/ 96 levels "c1s1_0.001_g1s1_6000_c2s1_0.999_",..: 56 56 56 56 56 56 56 56 56 56 ... : counterbalancing version
 $ condition  : Factor w/ 3 levels "EV","FREE","PH": 2 2 2 2 2 2 2 2 2 2 ... 
 $ AOI        : Factor w/ 8 levels "c1s1","c1s2",..: 1 1 5 7 7 3 3 6 2 8 ... : AOI name
 $ fixtime    : int  397 185 199 161 153 149 81 220 120 224 ... : fixation time in ms
 $ nfixAOI    : int  1 2 1 1 2 1 2 1 1 1 ... :  overall fixation number
 $ nfixGesamt : int  1 2 3 4 5 6 7 8 9 10 ... : sequence of fixations to AOIs 
 $ PHrelations: Factor w/ 12 levels "c2NDa","c2NDb",..: 1 1 11 11 11 5 5 12 2 10 ... : how does AOI relate to PH step
 $ RealValue  : chr  "0.2" "0.2" "-500" "-800" ... : real value in cell
 $ choice     : Factor w/ 2 levels "A","B": NA NA NA NA NA NA NA NA NA NA ... : participant's choice
 $ type       : chr  "P" "P" "O" "O" ... : P: probability, O: outcome
 $ orient     : chr  "v" "v" "v" "v" ... h: horizontal, v: vertical
 $ s1         : chr  "g1s1" "g1s1" "g1s1" "g1s1" ... : counterbalancing versions
...
 $ s8         : chr  "c2s2" "c2s2" "c2s2" "c2s2" ...
 $ v1         : chr  "-500" "-500" "-500" "-500" ... : values based on counterbalancing
...
 $ v8         : chr  "0.6" "0.6" "0.6" "0.6" ...
 $ task       : chr  "7" "7" "7" "7" ... : task number (see Appendix for gambles)
 $ gambletype : chr  "loss" "loss" "loss" "loss" ... : gambleytpe - pure loss, pure gain or mixed
 $ reasons    : Factor w/ 3 levels "one reason","two reasons",..: 1 1 1 1 1 1 1 1 1 1 ... : number of reasons for PH
 $ order      : Factor w/ 4 levels "EV FREE","FREE EV",..: 3 3 3 3 3 3 3 3 3 3 ... : which order did participants encounter
 $ PH         : chr  "min" "min" "min" "2nd" ... : step in PH
~~~~
