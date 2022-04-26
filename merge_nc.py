import glob
import os
import sys
import cdo
from pprint import pprint

def main(argv):
   inputfile = argv[0]
   outputfile = argv[1]
   print ('Input file is "', inputfile)
   print ('Output file is "', outputfile)
   
   chrtout_files = sorted(glob.glob(inputfile))
   #pprint(chrtout_files)
   if len(chrtout_files) == 0:
      print("Cannot find files to merge!")
      return
   output_folder = os.path.dirname(chrtout_files[0])
   try:
     # Create the directory in the path
     os.makedirs(output_folder, exist_ok = True)
     print("Directory %s Created Successfully" % output_folder)
   except OSError as error:
     print("Directory %s Creation Failed" % output_folder)

   chrtout_files_count = len(chrtout_files)
   chunk_size = 1000
   print(f"file count: {chrtout_files_count}; chunk_size: {chunk_size}")
   if len(chrtout_files) > chunk_size:
     print(f'Number of files exceeds {chunk_size}, performing consolidation in stages')
     # merge using intermediate files
     i = 0
     intermediate_files = []
     while i <= len(chrtout_files):
       fname = f'{outputfile}.{i}.tmp'
       print(f'\t> processing intermediate file {fname}...', end='', flush=True)
       cdo.Cdo().cat(input=chrtout_files[i:i+chunk_size], output=fname)
       print('done')
       intermediate_files.append(fname)
       i += chunk_size

     # merge intermediate files into final consolidated file
     print(f'\t+ processing final consolidated file...',
                          end='', flush=True)
     cdo.Cdo().cat(input=intermediate_files, output=outputfile)
     print('done')

     # remove intermediate files
     for ifile in intermediate_files:
       print(f'\t- removing intermediate files {ifile}...', end='', flush=True)
       os.remove(ifile)
       print('done')
   else:
     # merge without intermediate files
     print(f'processing file...', end='', flush=True)
     cdo.Cdo().cat(input=chrtout_files, output=outputfile)
     print('done')
   
if __name__ == "__main__":
   main(sys.argv[1:])
