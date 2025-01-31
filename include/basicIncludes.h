/* * * * * * * * * * * */
/* created by Naom Hod */
/* noam.hod@cern.ch    */
/* noam.com@gmail.com  */
/* on 23/07/2010 11:24 */
/* * * * * * * * * * * */

#ifndef BASICINCLUDES_H
#define BASICINCLUDES_H

#include "rawStd.h"
#include "rawROOT.h"
#include "rawRooFit.h"
#include "types.h"
#include "enums.h"
#include "couplings.h"
#include "width.h"
#include "helicity.h"
using namespace couplings;
using namespace width;
using namespace helicity;

// #include <TROOT.h>
// #include <TSystem.h>
// #include <TMatrix.h>
// #include <TVector.h>
// #include <TLorentzVector.h>
// #include <TVector3.h>
// #include <TCut.h>
// #include <TChain.h>
// #include <TH1.h>
// #include <TH2.h>
// #include <TStyle.h>
// #include <TCanvas.h>
// #include <TFile.h>
// #include <TDirectory.h>
// #include <TLegend.h>
// #include <TMinuit.h>
// #include <TApplication.h>
// #include <TF1.h>
// #include <TF2.h>
// #include <TF12.h>
// #include <TAxis.h>
// #include <TLine.h>
// #include <TPaveText.h>
// #include <TThread.h>
// #include <TList.h>
// #include <Riostream.h>
// #include <TDOMParser.h>
// #include <TXMLNode.h>
// #include <TXMLAttr.h>
// #include <TEventList.h>

// #include <RooFit.h>
// #include <RooRealVar.h>
// #include <RooGenericPdf.h>
// #include <RooArgList.h>
// #include <RooDataSet.h>
// #include <RooPlot.h>
// #include <RooMCStudy.h>
// #include <RooAbsMCStudyModule.h>
// #include <RooGenContext.h>
// #include <RooAbsPdf.h>
// #include <RooDataHist.h>
// #include <RooFitResult.h>
// #include <RooErrorVar.h>
// #include <RooFormulaVar.h>
// #include <RooRandom.h>
// #include <RooCmdConfig.h>
// #include <RooGlobalFunc.h>
// #include <RooPullVar.h>
// #include <RooClassFactory.h>
// #include <RooVoigtian.h>
// #include <RooExponential.h>
// #include <RooAddPdf.h>
// #include <RooBinning.h>
// #include <RooExtendPdf.h>

// #include <iostream>
// #include <stdlib.h>
// #include <stdio.h>      // for the sprintf call
// #include <string>
// #include <sstream>      // for the int to string operation (stringstream call)
// #include <cstring>      // for the string functions
// #include <math.h>
// #include <cmath>
// #include <complex>
// #include <fstream>
// #include <vector>
// #include <map>
// #include <ctime>
// #include <time.h>
// #include <pthread.h>
// #include <iomanip>

// using namespace std;
// using namespace RooFit;

static string sRunNumber = "";

/*
typedef map<int, const char*>   TMapiP2cc;
typedef multimap<int, int>      TMapii;
typedef multimap<int, string>   TMapis;
typedef map<double, double>     TMapdd;
typedef map<double, vector<int> > TMapdvi;
typedef map<float,  vector<int> > TMapfvi;
typedef vector<TLorentzVector*> TVectorP2VL;
typedef map<string, TObject*>   TMapSP2TOBJ;
typedef map<TString, TObject*>  TMapTSP2TOBJ;
typedef map<string, TH1*>       TMapSP2TH1;
typedef map<string, vector<TH1*> > TMapSvTH1;
typedef map<string, TH2*>       TMapSP2TH2;
typedef map<string, TGraph*>    TMapSP2TGraph;
typedef map<TString, TString>   TMapTSTS;
typedef map<TString, TH1*>      TMapTSP2TH1;
typedef map<TString, TH2*>      TMapTSP2TH2;
typedef map<TString, TGraph*>   TMapTSP2TGraph;
typedef map<TString, TLine*>    TMapTSP2TLINE;
typedef map<TString, TTree*>    TMapTSP2TTREE;
typedef map<TString, double>    TMapTSd;
typedef map<string, TH1D*>      TMapSP2TH1D;
typedef map<string, TH2D*>      TMapSP2TH2D;
typedef map<string, TCanvas*>   TMapSP2TCNV;
typedef map<TString, TCanvas*>  TMapTSP2TCNV;
typedef map<string, double>     TMapsd;
typedef map<string, int>        TMapsi;
typedef map<string, bool>       TMapsb;
typedef map<double, string>     TMapds;
typedef map<double, int>        TMapdi;
typedef map<TString, vector<float> >  TMapTSvf;
typedef map<string, vector<double> >  TMapsvd;
typedef map<string, vector<double>* > TMapsP2vd;
typedef map<string, vector<float>* > TMapsP2vf;
typedef map<string, string> TMapss;
typedef map<string, vector<string> > TMapsvs;
typedef map<string, vector<string>* > TMapsP2vs;
typedef map<int, vector<string>* >    TMapiP2vs;
typedef multimap<float, float > TMultimapff;
typedef vector<TCanvas*> TVecCanvas;
*/

#include "logs.h"

#include "style.h"

#include "bins.h"

#include "colors.h"

#include "histos.h"

#include "asymgraph.h"

#include "kFactors.h"

#define utilities_cxx
#include "utilities.C"

#define kinematics_cxx
#include "kinematics.C"

#include "units.h"

#define WZphysD3PD_cxx
#include "WZphysD3PD.C"

/*
#ifdef __CINT__
#pragma link C++ class vector<vector<double> >+;
#pragma link C++ class vector<vector<float> >+;
#pragma link C++ class vector<vector<int> >+;
#pragma link C++ class vector<vector<unsigned int> >+;
#else
template class std::vector<std::vector<double> >;
template class std::vector<std::vector<float> >;
template class std::vector<std::vector<int> >;
template class std::vector<std::vector<unsigned int> >;
#endif
*/


/*
#ifdef __CINT__
#pragma link C++ class std::vector<std::vector<double> >+;
#else
	template class std::vector<std::vector<double> >;
#endif

#ifdef __CINT__
#pragma link C++ class std::vector<std::vector<float> >+;
#else
	template class std::vector<std::vector<float> >;
#endif

#ifdef __CINT__
#pragma link C++ class std::vector<std::vector<int> >+;
#else
	template class std::vector<std::vector<int> >;
#endif

#ifdef __CINT__
#pragma link C++ class std::vector<std::vector<unsigned int> >+;
#else
	template class std::vector<std::vector<unsigned int> >;
#endif
*/

// #define fitParameters_cxx
// #include "fitParameters.C"

// #define fitFunctions_cxx
// #include "fitFunctions.C"

/*
enum pdtEnum { // *** note that this is not a complete list of pdt's particles ***
	PDTDWN=1, PDTUP=2, PDTSTR=3, PDTCHM=4, PDTBOT=5, PDTTOP=6,
	PDTBOTPRIME=7, PDTTOPPRIME=8,
	PDTE=11, PDTNUE=12, PDTMU=13, PDTNUMU=14, PDTTAU=15, PDTNUTAU=16,
	PDTTAUPRIME=17, PDTNUTAUPRIME=18,
	PDTGLU=21, PDTGAMMA=22, PDTZ=23, PDTWPLUS=24, PDTZPRIME0=32,PDTGRV=5000039,
	PDTFIRSTMESON=111, PDTLASTMESON=555,
	PDTFIRSTBARYON=1103, PDTLASTBARYON=5554
};

enum models
{
	ZPd3pd=-2,
	Z0d3pd=-1,
	Z0,ZP,KK,
	DT
};

enum enumMCs
{
	DYmumu=0,
	Diboson
};
*/
#endif

