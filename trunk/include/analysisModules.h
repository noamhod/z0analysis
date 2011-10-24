/* * * * * * * * * * * */
/* created by Naom Hod */
/* noam.hod@cern.ch    */
/* noam.com@gmail.com  */
/* on 23/07/2010 11:24 */
/* * * * * * * * * * * */

#include "basicIncludes.h"

#define XML_cxx
#include "XML.C"

#define fit_cxx
#include "fit.C"

#define Afb_cxx
#include "Afb.C"

#define tagNprobe_cxx
#include "tagNprobe.C"

#define selection_cxx
#include "selection.C"

#define graphicObjects_cxx
#include "graphicObjects.C"

#define xmlconfig_cxx
#include "xmlconfig.C"

#define eventDumper_cxx
#include "eventDumper.C"

using namespace cuts;
using namespace fitparameters;

#ifndef ANALYSISMUDULES_H
#define ANALYSISMUDULES_H

class analysisModules : public selection,
						public xmlconfig,
						public eventDumper,
						public graphicObjects,
						public fit,
						public tagNprobe,
						public Afb
{
	public:
		analysisModules();
		analysisModules(string sEventDumpFilePath) :
		eventDumper(sEventDumpFilePath)
		{
			_DEBUG("analysisModules::analysisModules");
			
			string str_xml_path = utilities::checkANDsetFilepath("BASEDIR", "/../xml");
			_INFO("getting the xml file from this directory: "+str_xml_path);
			xmlconfig::get(str_xml_path);
			
			if(sEventDumpFilePath != "") setInterestingThreshold( 646.33*GeV2TeV );
			
			setCutFlowMapSVDPtr( cutFlowHandler::m_cutFlowMapSVD );
			ginitialize();
		}
		~analysisModules();
};
#endif

