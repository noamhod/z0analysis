#!/usr/bin/env ruby

require 'pathname'
require 'fileutils'
require 'ftools'
require 'find'
include FileUtils



class QSUB
	# http://juixe.com/techknow/index.php/2007/01/22/ruby-class-tutorial/
	attr_accessor :homedir,
				  :thisdir,
				  :rootdir,
				  :targetdir,
				  :sourcedir,
				  :macrodir,
				  :jobdir,
				  :prefix,
				  :nchars,
				  :secondprefix,
				  :nsubchars
	
	def initialize(dosetup=false)
		if(dosetup) then
			%x(source $HOME/setROOT528c.sh)
		end
		
		#log = Logger.new(STDOUT)
		#log.level = Logger::WARN
		
		#export PBS_SERVER=tau-ce.hep.tau.ac.il
		ENV['PBS_SERVER'] = "tau-ce.hep.tau.ac.il"
		puts "PBS_SERVER=#{ENV['PBS_SERVER']} is set."

		# ENV['DATADIR'] = "/data/hod/2011/NTUP_SMDILEP_dimuon_p591"
		# ENV['RUNDIR'] = "#{thisdir}/../run"
		# ENV['LD_LIBRARY_PATH'] = "#{ENV['LD_LIBRARY_PATH']}:#{ENV['RUNDIR']}"
		# ENV['LD_LIBRARY_PATH'] = "#{ENV['LD_LIBRARY_PATH']}:#{ENV['RUNDIR']}/../GoodRunsLists-00-00-91/StandAlone"
	end
	
	def check_variables
		ok=true
		
		puts homedir
		puts thisdir
		puts rootdir
		puts targetdir
		puts sourcedir
		puts macrodir
		puts jobdir
		puts prefix
		puts nchars
		puts secondprefix
		puts nsubchars
		
		if(!homedir)	then
			ok=false
			LOG("ERROR", "homedir is not set")
		end
		if(!thisdir)	then
			ok=false
			LOG("ERROR", "thisdir is not set")
		end
		if(!rootdir)    then
			ok=false
			LOG("ERROR", "rootdir is not set")
		end
		if(!targetdir)	then
			ok=false
			LOG("ERROR", "targetdir is not set")
		end
		if(!sourcedir)	then
			ok=false
			LOG("ERROR", "sourcedir is not set")
		end
		if(!macrodir)	then
			ok=false
			LOG("ERROR", "macrodir is not set")
		end
		if(!jobdir)	then
			ok=false
			LOG("ERROR", "jobdir is not set")
		end
		if(!prefix)	then
			ok=false
			LOG("ERROR", "prefix is not set")
		end
		if(!nchars)	then
			ok=false
			LOG("ERROR", "nchars is not set")
		end
		if(!secondprefix)	then
			ok=false
			LOG("ERROR", "secondprefix is not set")
		end
		if(!nsubchars)	then
			ok=false
			LOG("ERROR", "nsubchars is not set")
		end
		
		return ok
	end
	
	def set_thisdir(str="")
		@thisdir = str
	end

	def set_rootdir(str="")
		@rootdir = str
	end
	
	def set_homedir(str="")
		@homedir = str
	end
	
	def set_sourcedir(str="")
		@sourcedir = str
	end
	
	def set_targetdir(str="")
		@targetdir = str
	end
	
	def set_macrodir(str="")
		@macrodir = str
	end
	
	def set_jobdir(str="")
		@jobdir = str
	end
	
	def set_prefix(str="",ncr=8)
		@prefix = str
		@nchars = ncr
	end
	
	def set_secondprefix(str="",nsubcr=5)
		@secondprefix = str
		@nsubchars    = nsubcr
	end
	
	def get_run_number(dataset="",fullprefix="")
		if(fullprefix=="") then
			substring = prefix
		else
			substring = fullprefix
		end
		return dataset[substring.length,nchars]
	end
	
	def find_substring(string="")
		start_ss = string.index(secondprefix)
		return string[start_ss+secondprefix.length,nsubchars]
	end
	
	def search_directory(path="",pattern=".root",fullprefix="")
		# see: http://rosettacode.org/wiki/Walk_a_directory/Recursively
		hashmap = Hash.new
		Find.find(path) do |entry|
			if File.file?(entry) and entry[pattern]
				filepath = entry.to_s()
				number     = get_run_number(filepath,fullprefix)
				subnumber  = find_substring(filepath)
				fullnumber = "#{number}.#{subnumber}"
				hashmap[Float(fullnumber)] = filepath
			end
		end

		hashmap = hashmap.sort
		puts hashmap
		return hashmap
	end
	
	def make_list(datasetdir="",fullprefix="",runnumber="")	
		files = Hash.new
		files = search_directory(datasetdir,".root",fullprefix)
		listfilename = targetdir+"/../../conf/tmp/#{runnumber}.list"
		listfile = File.open(listfilename,'w')
		files.each {|key,val|
			listfile.puts "#{val}\n"
		}
		listfile.close
	end
	
	def qsub(datasetdir="",dataset="")
		#puts dataset
		runnumber = get_run_number(dataset)
		fullprefix = sourcedir+"/"+prefix
		make_list(datasetdir,fullprefix,runnumber)
		macroname = "#{macrodir}/macro_#{runnumber}.C"
		jobname   = "#{jobdir}/job_#{runnumber}.sh"
		rundirregular="#{thisdir}/../run"
		rundir='\"'+"#{thisdir}"+'/../run/\"'
		grltag='\"00-00-91\"'
		singlerun = '\"SINGLERUN\"'
		
		#cd(rundir)
		macrofile = File.open(macroname, 'w') { |f| 
			f.puts "{"
			f.puts "   gROOT->Reset();"
			f.puts "   gROOT->ProcessLine(\".L #{rundirregular}/analysisLocalControlMain.C\");"
			f.puts "   gROOT->ProcessLine(\"load(#{grltag},#{rundir})\");"
			f.puts "   gROOT->ProcessLine(\"alc.initialize(#{runnumber},#{singlerun},#{rundir})\");"
			f.puts "   gROOT->ProcessLine(\"alc.loop(0,0)\");"
			f.puts "}"
		}
		
		jobfile = File.open(jobname, 'w') { |f| 
			f.puts "#!/bin/bash"
			f.puts "export PBS_SERVER=tau-ce.hep.tau.ac.il"
			f.puts "export ROOTSYS=#{rootdir}"
			f.puts "export LD_LIBRARY_PATH=$ROOTSYS/lib:$LD_LIBRARY_PATH"
			f.puts "export PATH=$ROOTSYS/bin:$PATH"
			f.puts "export RUBYLIB=$ROOTSYS/lib:$RUBYLIB"
			f.puts "export LD_LIBRABY_PATH=$LD_LIBRABY_PATH:#{rundirregular}"
			f.puts "export LD_LIBRABY_PATH=$LD_LIBRABY_PATH:#{thisdir}/../GoodRunsLists-00-00-91/StandAlone"
			f.puts "$ROOTSYS/bin/root.exe -l -b -q #{macroname}"
		}
		
		#puts "%x(qsub -q N -e #{rundirregular}/tmp/err -o #{rundirregular}/tmp/out #{rundirregular}/#{jobname})"
		%x(qsub -q N -e #{rundirregular}/tmp/err -o #{rundirregular}/tmp/out #{jobname})
	end
	
	def batch_qsub(inlist=[],runnumberslist=[])
	
		############ clean before start ##############
		%x(ruby clean_tmp.rb) ########################
		##############################################
	
		if(!self.check_variables) then
			LOG("ERROR", "there are uninitialized variables")
			return
		end
		
		inlist.each{ |dataset|
			run = get_run_number(dataset)	
			runnumberslist << run
			datasetdir = sourcedir+"/"+dataset
			qsub(datasetdir,dataset)
		}

		%x(qstat | grep hod)
		puts "USE \'qstat | grep hod\' to monitor the jobs"
	end
	
	def merge(inlist=[], mergedfilename="merged.root")
		line = String.new
		inlist.each { |dataset|
			run = get_run_number(dataset)
			fname = "#{targetdir}/run_#{run}.root"
			if(File.exists?(fname)) then
				line += "  #{fname}"
			else
				LOG("WARNING","Missing ROOT file: #{fname}")
			end
		}
		LOG("WARNING","For the missing files (if any) go to ../run/tmp and run the specific macro again:   root.exe -l -b -q macro_XXXXXX.C\n then try to merge again")
		%x(hadd -f #{targetdir}/../#{mergedfilename}    #{line})
	end
	
	def finalize()
		# %x(rm -f #{macrodir}/*.#log)
		# %x(rm -f #{macrodir}/*.C)
		# %x(rm -f #{targetdir}/*.list)
		# %x(rm -f #{targetdir}/*.root)
	end
	
	def LOG(msgtype="DEBUG",msg="")
		puts "[#{__FILE__} +#{__LINE__}] #{msgtype}: #{msg}"
	end
end


rootfiles = Array.new
