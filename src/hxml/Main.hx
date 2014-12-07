package hxml;

import sys.FileSystem;
import sys.io.File;
import sys.io.Process;

using StringTools;

class Main extends mcli.CommandLine{

	public static function main()
    {
        new mcli.Dispatch(Sys.args()).dispatch(new Main());
    }

    public function help()
    {
        Sys.println(this.showUsage());
        Sys.exit(0);
    }

    public function runDefault(){

    	var fileNames = FileSystem.readDirectory("./");
    	
    	var errored  = false;
    	for (fileName in fileNames){
    		if(fileName.endsWith(".hxml")){
    			var input = File.read(fileName);
    			var line = "";
    			while(true){
    				try{
    					line = input.readLine();	
    				}catch(e : Dynamic){
    					break;
    				}
    				
                    var commentIndex = line.indexOf("#");
                    if(commentIndex != -1){
                        line = line.substr(0,commentIndex);
                    }
    				if (line.indexOf("-lib ") != -1){
    					var lib = line.replace("-lib ", "");
    					var splits = lib.split(":");

                        var args = ["install"];
                        for (split in splits){
                            args.push(split.trim());
                        }
        				    

        				var haxelibProcess = new Process("haxelib", args);
        				haxelibProcess.stdin.writeString("n\n"); // do not set if older version was choosen while the newest version was already installed
    					var output = haxelibProcess.stdout.readAll().toString();//wait
    					Sys.println(output);

    	    			var stderr = haxelibProcess.stderr.readAll().toString();
    	    			
    	    			if(stderr != ""){
    	    				Sys.println(stderr);
    	    				errored = true;
    	    			}
    	    			
    	    			var exitCode = haxelibProcess.exitCode();
    	    			if(exitCode != 0){
    	    				errored = true;
    	    				Sys.println("haxelib exited with exitCode : " + exitCode);
    	    			}    					
    				}
    				
    			}
    			if(errored){
    				Sys.exit(1);	
    			}
    			
    		}
    	}
    }

}