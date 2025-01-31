 /***************************************************************************** 
  * Project: RooFit                                                           * 
  *                                                                           * 
  * This code was autogenerated by RooClassFactory                            * 
  *****************************************************************************/ 

 // Your description goes here... 

 #include "Riostream.h" 
 #include "TROOT.h"
 #include "TMath.h"
 #include "RooFBfalseIdentifyCS.h" 
 #include "RooAbsReal.h" 
 #include "RooAbsCategory.h" 

 ClassImp(RooFBfalseIdentifyCS) 

 RooFBfalseIdentifyCS::RooFBfalseIdentifyCS(const char *name, const char *title, 
											RooAbsReal& _costheta,
											RooAbsReal& _yQ,
											RooAbsReal& _A0,
											RooAbsReal& _A4,
											TH1D&       _hPyQ) :
   RooAbsPdf(name,title), 
   costheta("costheta","costheta",this,_costheta),
   yQ("yQ","yQ",this,_yQ),
   A0("A0","A0",this,_A0),
   A4("A4","A4",this,_A4)
 {
   hPyQ = (TH1D*)_hPyQ.Clone("");
 } 


 RooFBfalseIdentifyCS::RooFBfalseIdentifyCS(const RooFBfalseIdentifyCS& other, const char* name) :  
   RooAbsPdf(other,name), 
   costheta("costheta",this,other.costheta),
   yQ("yQ",this,other.yQ),
   A0("A0",this,other.A0),
   A4("A4",this,other.A4)
 { 
   hPyQ = (TH1D*)other.hPyQ->Clone("");
 }

 Double_t RooFBfalseIdentifyCS::evaluate() const 
 { 
   // ENTER EXPRESSION IN TERMS OF VARIABLE ARGUMENTS HERE
   Double_t dflt = 1.e-30;
   Int_t bin = hPyQ->FindBin(yQ);
   if(bin<1 || bin>hPyQ->GetNbinsX()) return dflt;
   Double_t PyQ = hPyQ->GetBinContent(bin);
   Double_t pdf = (3./8.)*(1. + A0/2. + (1.-2.*PyQ)*A4*costheta + (1.-(3./2.)*A0)*costheta*costheta);
   return (pdf>0.) ? pdf : dflt;
 } 



