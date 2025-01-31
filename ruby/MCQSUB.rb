#!/usr/bin/env ruby

require 'pathname'
require 'fileutils'
require 'ftools'
require 'find'
require 'LoggerDecorator'
include FileUtils



class MCQSUB
	# http://juixe.com/techknow/index.php/2007/01/22/ruby-class-tutorial/
	attr_accessor :logger,
				  :logd,
				  :mcname,
				  :maxlistsize,
				  :nmcjobs,
				  :homedir,
				  :thisdir,
				  :rootdir,
				  :targetdir,
				  :sourcedir,
				  :macrodir,
				  :jobdir,
				  :prefix,
				  :nchars,
				  :secondprefix,
				  :nsubchars,
				  :grltag,
				  :mcptag,
				  :prwtag
	
	def initialize(dosetup=false)
		if(dosetup) then
			%x(source $HOME/setROOT528c.sh)
		end
		
		set_loggerdec("")
		# set_loglvl(Logger::INFO)
		# set_loglvl(Logger::DEBUG)
		# set_loglvl(Logger::WARN)
		# set_loglvl(Logger::ERROR)
		# set_loglvl(Logger::FATAL)
		
		#export PBS_SERVER=tau-ce.hep.tau.ac.il
		ENV['PBS_SERVER'] = "tau-ce.hep.tau.ac.il"
		logd.info "PBS_SERVER=#{ENV['PBS_SERVER']} is set."
	end
	
	def check_variables
		ok=true
		
		logd.info mcname
		logd.info maxlistsize
		logd.info nmcjobs
		logd.info homedir
		logd.info thisdir
		logd.info rootdir
		logd.info targetdir
		logd.info sourcedir
		logd.info macrodir
		logd.info jobdir
		logd.info prefix
		logd.info nchars
		logd.info secondprefix
		logd.info nsubchars
		logd.info grltag
		logd.info mcptag
		logd.info prwtag
		
		if(!mcname)	then
			ok=false
			logd.error "mcname is not set"
		end
		if(!maxlistsize)	then
			ok=false
			logd.error "maxlistsize is not set"
		end
		if(!nmcjobs)	then
			ok=false
			logd.error "nmcjobs is not set"
		end
		if(!homedir)	then
			ok=false
			logd.error "homedir is not set"
		end
		if(!thisdir)	then
			ok=false
			logd.error "thisdir is not set"
		end
		if(!rootdir)    then
			ok=false
			logd.error "rootdir is not set"
		end
		if(!targetdir)	then
			ok=false
			logd.error "targetdir is not set"
		end
		if(!sourcedir)	then
			ok=false
			logd.error "sourcedir is not set"
		end
		if(!macrodir)	then
			ok=false
			logd.error "macrodir is not set"
		end
		if(!jobdir)	then
			ok=false
			logd.error "jobdir is not set"
		end
		if(!prefix)	then
			ok=false
			logd.error "prefix is not set"
		end
		if(!nchars)	then
			ok=false
			logd.error "nchars is not set"
		end
		if(!secondprefix)	then
			ok=false
			logd.error "secondprefix is not set"
		end
		if(!nsubchars)	then
			ok=false
			logd.error "nsubchars is not set"
		end
		if(!grltag)	then
			ok=false
			logd.error "grltag is not set"
		end
		if(!mcptag)	then
			ok=false
			logd.error "mcptag is not set"
		end
		if(!prwtag)	then
			ok=false
			logd.error "prwtag is not set"
		end
		
		return ok
	end
	
	def set_mcname(str="")
		@mcname = str
	end
	
	def set_maxlistsize(n=4)
		@maxlistsize = n
	end
	
	def set_nmcjobs(n=4)
		@nmcjobs = n
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
	
	def set_grltag(str="")
		@grltag = str
	end
	
	def set_mcptag(str="")
		@mcptag = str
	end
	
	def set_prwtag(str="")
		@prwtag = str
	end
	
	def set_loggerdec(logfilename="")
		@logger = Logger.new(STDERR)
		logger = Logger.new(STDOUT)
		if(logfilename!="") then
			@logger = Logger.new(logfilename)
		end
		@logd = LoggerDecorator.new(logger)
	end
	
	def set_loglvl(lvl=Logger::INFO)
		logger.level = lvl
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
	
	def find_string(string="", substring="", n=0)
		start_ss = string.index(substring)
		return string[start_ss+substring.length, n]
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
		#puts hashmap
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
	
	
	###############################################################################################3
	def make_mc_list(datasetdir="",fullprefix="",jobname="")	
		files = Hash.new
		files = search_directory(datasetdir,".root",fullprefix)
		
		files_array = Array.new
		files.each {|key,val|
			files_array << val
		}
		
		jobslist = Array.new
		array_size = files_array.length
		last_index = array_size-1
		jobnumber = 1
		i=0
		while(i<last_index)
			listfilename = targetdir+"/../../conf/tmp/#{jobname}.#{jobnumber}.list"
			listfile = File.open(listfilename,'w')
			j=0
			while(j<maxlistsize and (i+j)<=last_index)
				listfile.puts "#{files_array[i+j]}\n"
				j = j+1
			end
			listfile.close
			jobnumber = jobnumber+1
			i = i+j
		end
		
		self.nmcjobs = jobnumber-1
		
		logd.info "nmcjobs="+nmcjobs.to_s()
		return nmcjobs
	end
	###############################################################################################
	
	
	def qsub(datasetdir="",dataset="",isMC=false)
		runnumber = get_run_number(dataset)
		fullprefix = sourcedir+"/"+prefix
		
		############
		### data ###
		############
		if(!isMC) then
			make_list(datasetdir,fullprefix,runnumber)
			macroname = "#{macrodir}/macro_#{runnumber}.C"
			jobname   = "#{jobdir}/job_#{runnumber}.sh"
		
			rundirregular="#{thisdir}/../run"
			rundir='\"'+"#{thisdir}"+'/../run/\"'
			grlTag='\"'+"#{grltag}"+'\"'
			singlerun = '\"SINGLERUN\"'
			runnumstr = '\"'+"#{runnumber}"+'\"'
			
			#cd(rundir)
			macrofile = File.open(macroname, 'w') { |f| 
				f.puts "{"
				f.puts "   gROOT->Reset();"
				f.puts "   gROOT->ProcessLine(\".L #{rundirregular}/analysisLocalControlMain.C\");"
				f.puts "   gROOT->ProcessLine(\"load(#{grlTag},#{rundir})\");"
				f.puts "   gROOT->ProcessLine(\"alc.initialize(#{runnumstr},#{singlerun},#{rundir})\");"
				f.puts "   gROOT->ProcessLine(\"alc.loop(0,0)\");"
				f.puts "}"
			}
			
			jobfile = File.open(jobname, 'w') { |f| 
				f.puts "#!/bin/bash"
				f.puts "export PBS_SERVER=tau-ce.hep.tau.ac.il"
				f.puts "export RUNNUMBER=#{runnumber}"
				f.puts "echo   \"HOST=$HOSTNAME\""
				f.puts "echo   \"RunNumber=$RUNNUMBER\""
				f.puts "export ROOTSYS=#{rootdir}"
				f.puts "export LD_LIBRARY_PATH=$ROOTSYS/lib:$LD_LIBRARY_PATH"
				f.puts "export PATH=$ROOTSYS/bin:$PATH"
				f.puts "export RUBYLIB=$ROOTSYS/lib:$RUBYLIB"
				f.puts "export LD_LIBRABY_PATH=$LD_LIBRABY_PATH:#{rundirregular}"
				f.puts "export LD_LIBRABY_PATH=$LD_LIBRABY_PATH:#{thisdir}/../GoodRunsLists-#{grltag}/StandAlone"
				f.puts "export LD_LIBRABY_PATH=$LD_LIBRABY_PATH:#{thisdir}/../MuonMomentumCorrections-#{mcptag}/StandAlone"
				f.puts "export LD_LIBRABY_PATH=$LD_LIBRABY_PATH:#{thisdir}/../PileupReweighting-#{prwtag}/StandAlone"
				f.puts "$ROOTSYS/bin/root.exe -l -b -q #{macroname}"
				f.puts "echo   \"RunNumber=$RUNNUMBER\""
				f.puts "echo   \"host = $HOSTNAME\""
			}

			%x(qsub -q HEP -e #{rundirregular}/tmp/err -o #{rundirregular}/tmp/out #{jobname}) ################################################################
			logd.info "sent --> #{dataset}"
			
		##########	
		### MC ###
		##########
		else
			njobs = make_mc_list(datasetdir,fullprefix,runnumber)
			for i in 1..njobs
				macroname = "#{macrodir}/macro_#{mcname}_#{runnumber}.#{i}.C"
				jobname   = "#{jobdir}/job_#{mcname}_#{runnumber}.#{i}.sh"
			
				rundirregular="#{thisdir}/../run"
				rundir='\"'+"#{thisdir}"+'/../run/\"'
				grlTag='\"'+"#{grltag}"+'\"'
				singlerun = '\"SINGLERUN\"'
				runnumstr = '\"'+"#{runnumber}.#{i}"+'\"'
				
				#cd(rundir)
				macrofile = File.open(macroname, 'w') { |f| 
					f.puts "{"
					f.puts "   gROOT->Reset();"
					f.puts "   gROOT->ProcessLine(\".L #{rundirregular}/analysisLocalControlMain.C\");"
					f.puts "   gROOT->ProcessLine(\"load(#{grlTag},#{rundir})\");"
					f.puts "   gROOT->ProcessLine(\"alc.initialize(#{runnumstr},#{singlerun},#{rundir})\");"
					f.puts "   gROOT->ProcessLine(\"alc.loop(0,0)\");"
					f.puts "}"
				}
				
				jobfile = File.open(jobname, 'w') { |f| 
					f.puts "#!/bin/bash"
					f.puts "export PBS_SERVER=tau-ce.hep.tau.ac.il"
					f.puts "export BASEDIR=#{rundirregular}"
					f.puts "export RUNNUMBER=#{runnumber}.#{i}"
					f.puts "echo   \"HOST=$HOSTNAME\""
					f.puts "echo   \"RunNumber=$RUNNUMBER\""
					f.puts "export ROOTSYS=#{rootdir}"
					f.puts "export LD_LIBRARY_PATH=$ROOTSYS/lib:$LD_LIBRARY_PATH"
					f.puts "export PATH=$ROOTSYS/bin:$PATH"
					f.puts "export RUBYLIB=$ROOTSYS/lib:$RUBYLIB"
					f.puts "export LD_LIBRABY_PATH=$LD_LIBRABY_PATH:#{rundirregular}"
					f.puts "export LD_LIBRABY_PATH=$LD_LIBRABY_PATH:#{thisdir}/../GoodRunsLists-#{grltag}/StandAlone"
					f.puts "export LD_LIBRABY_PATH=$LD_LIBRABY_PATH:#{thisdir}/../MuonMomentumCorrections-#{mcptag}/StandAlone"
					f.puts "export LD_LIBRABY_PATH=$LD_LIBRABY_PATH:#{thisdir}/../PileupReweighting-#{prwtag}/StandAlone"
					f.puts "$ROOTSYS/bin/root.exe -l -b -q #{macroname}"
					f.puts "echo   \"RunNumber=$RUNNUMBER\""
					f.puts "echo   \"host = $HOSTNAME\""
				}

				%x(qsub -q HEP -e #{rundirregular}/tmp/err -o #{rundirregular}/tmp/out #{jobname})
				logd.info "sent --> job(#{i}/#{njobs})"
			end
		end
	end
	
	def batch_qsub(inlist=[],runnumberslist=[],isMC=false)
	
		############ clean before start ##############
		#%x(ruby clean_tmp.rb) ########################
		##############################################
	
		if(!self.check_variables) then
			logd.error "there are uninitialized variables"
			return
		end
		
		inlist.each{ |dataset|
			run = get_run_number(dataset)	
			runnumberslist << run
			datasetdir = sourcedir+"/"+dataset
			qsub(datasetdir,dataset,isMC)
		}
		
		%x(qstat -u hod | grep #{mcname})
		logd.info "USE: qstat -u hod | grep #{mcname} to monitor the jobs"
	end
	
	def get_txtlogfiles(inlist=[], sPrefix="", sSuffix="",isMC=false)
		txtlogfiles = Array.new
		txtlogdir = macrodir
		inlist.each{ |dataset|
			run = get_run_number(dataset)
			if(!isMC) then
				txtlogfiles << "#{txtlogdir}/#{sPrefix}#{run}#{sSuffix}"
			else
				for i in 1..nmcjobs
					txtlogfiles << "#{txtlogdir}/#{sPrefix}#{run}.#{i}#{sSuffix}"
				end
			end
		}
		txtlogfiles.sort
		return txtlogfiles
	end
	
	def parse_line(line="")
		if(line=="") then return end
		if(line.index("SELECTION")  or  line.index("PRESELECTION")  or  line.index("processed")) then
			line = line.gsub(/\t/," ")
			line = line.gsub("  "," ")
			line = line.gsub("   "," ")
			words = line.split(" ")
			size = words.length
			count = 0
			words.each do |word|
				if(word.index("|")) then next end
				if(word.index(":")) then word = word.gsub(":","") end
				# puts "word[#{count}/#{size}] = #{word}"
				count += 1
			end
			# puts ""
		else
			return
		end
		return words
	end
	
	def add_cut(types=[],names=[],evnts=[], type="",name="",evts=0)
		types << type
		names << name
		evnts << evts
	end

	def add_evts(cutindex=0,evnts=[],evts=0)
		evnts[cutindex] += Integer(evts)
	end
	
	def merge_cutflow(inlist=[], filename="merged.cutflow",isMC=false)
		lastline=-1
		firstline=-25 # THIS IS THE NUMBER OF LINES COUNTED FROM BOTTOM, WHERE THE FIRST CUTFLOW LINE APPEARS - maybe should be 50 or some large number
		types = Array.new
		names = Array.new
		evnts = Array.new
		filescount=0
		files = get_txtlogfiles(inlist,"RunCutFlow.run_",".cuts",isMC)
		files.each{|file|
			lines = IO.readlines(file)[firstline..lastline]
			cutindex = 0
			checkrun = 0
			lines.each do |line|
				words = parse_line(line)
				if(!words) then next end
				if(words.length>0) then
					if(words[2]=="all"  and Integer(words[3])==0) then
						runnumber = find_string(file.to_s(), "RunCutFlow.run_", 6)
						rundirout = "#{thisdir}/../run/tmp/out"
						rundirerr = "#{thisdir}/../run/tmp/err"
						logd.warn "@@@ in file #{file}"
						logd.warn "@@@ no events were processed, check the following log files:"
						result1 = %x(ruby findthis.rb #{rundirout} RunNumber=#{runnumber})
						result1 = result1.gsub("\n","")
						logd.warn "@@@ #{result1}"
						result2 = %x(ruby findthis.rb #{rundirerr} #{runnumber})
						result2 = result2.gsub("\n","")
						logd.warn "@@@ #{result2}"
						hostline = IO.readlines(result1)[0..0]
						logd.warn "@@@ #{hostline}"
					end
					
					if(filescount==0) then
						add_cut(types,names,evnts, words[1],words[2],Integer(words[3]))
					else
						add_evts(cutindex,evnts,Integer(words[3]))
					end
				end
				cutindex += 1
			end
			filescount += 1
		}
	
		file = File.open("#{targetdir}/../#{filename}", 'w') do |f|
			f.puts "<? This is a summary of the cutflow from run #{Time.now} ?>"
			names.each do |name|
				string = "#{types[names.index(name)]} \t #{name} \t\t #{evnts[names.index(name)]}"
				logd.info string
				f.puts string
			end
		end
	end
	
	
	def merge_candidates(inlist=[], filename="merged.candidates",isMC=false)
		candidates_all = Array.new
		candidates_pT  = Array.new
		
		# all candidates
		files = get_txtlogfiles(inlist,"candidates_all.run_",".cnd",isMC)
		files.each{|file|
			lines = IO.readlines(file)
			lines = lines.sort
			#logd.info "There are #{lines.length} candidates in #{file}"
			lines.each do |line|
				candidates_all << line
			end
			#puts lines
		}
		filename_all = filename.gsub(".",".all.")
		file = File.open("#{targetdir}/../#{filename_all}", 'w') do |f|
			f.puts "<? This is a summary of all the passing candidates from run #{Time.now} ?>"
			candidates_all.each do |cand|
				f.puts cand
			end
		end
		
		# pT candidates
		files = get_txtlogfiles(inlist,"candidates_pT.run_",".cnd",isMC)
		files.each{|file|
			lines = IO.readlines(file)
			lines = lines.sort
			#logd.info "There are #{lines.length} candidates in #{file}"
			lines.each do |line|
				candidates_pT << line
			end
			#puts lines
		}
		candidates_pT.sort
		filename_pT = filename.gsub(".",".pT.")
		file = File.open("#{targetdir}/../#{filename_pT}", 'w') do |f|
			f.puts "<? This is a summary of all the pTcut-passing candidates from run #{Time.now} ?>"
			candidates_pT.each do |cand|
				f.puts cand
			end
		end
	end
	
	def merge_root(inlist=[], mergedfilename="merged.root",isMC=false)
		line = String.new
		inlist.each { |dataset|
			run = get_run_number(dataset)
			if(!isMC) then
				fname = "#{targetdir}/run_#{run}.root"
				if(File.exists?(fname)) then
					line += "  #{fname}"
				else
					logd.warn "Missing ROOT file: #{fname}"
				end
			else
				for i in 1..nmcjobs
					fname = "#{targetdir}/run_#{run}.#{i}.root"
					if(File.exists?(fname)) then
						line += "  #{fname}"
					else
						logd.warn "Missing ROOT file: #{fname}"
					end
				end
			end
		}
		logd.warn "For the missing files (if any) go to ../run/tmp and run the specific macro again:   root.exe -l -b -q macro_XXXXXX.C\n then try to merge again"
		%x(hadd -f #{targetdir}/../#{mergedfilename}    #{line})
	end
	
	
	
	
	#####################################################################################
	def repeat_every(interval)
		# http://stackoverflow.com/questions/2279210/timer-in-ruby-performance
		loop do
			start_time = Time.now
			yield
			elapsed = Time.now - start_time
			sleep([interval - elapsed, 0].max)
		end
	end

	def waitNmerge(interval=5,inlist=[], mergedfilename="merged",isMC=false)
		# http://stackoverflow.com/questions/2279210/timer-in-ruby-performance
		iteration=0
		repeat_every(interval) do
			shortname = mcname.gsub("PythiaB_","");
			shortname = shortname.gsub("mu15X","");
			shortname = shortname.gsub("Pythia","");
			shortname = shortname.gsub("no_filter","");
			shortname = shortname.gsub("Herwig","");
			shortname = shortname.gsub("Herwig","");
			shortname = shortname.gsub("McAtNlo_Jimmy","");
			shortname = shortname.gsub("_","");
		
			if(mcname.index("AlpgenJimmy")) then
				shortname = "AlpgenJimmy";
			end
	
			logd.info "... waiting[#{iteration}] -> searching for: #{shortname} (#{mcname})"
			%x(qstat -u hod | grep #{shortname} > /dev/null)
			if($?!=0) then
				break
			end
			iteration += 1
		end
		seconds = interval*iteration
		logd.info "!!!---merging (after #{iteration} iterations [#{seconds} seconds])---!!!"
		merge_root(inlist,"#{mergedfilename}.root",isMC)
		merge_candidates(inlist,"#{mergedfilename}.candidates",isMC)
		merge_cutflow(inlist,"#{mergedfilename}.cutflow",isMC)
	end
	
	def finalize()
		logger.close
	end
end


rootfiles = Array.new
