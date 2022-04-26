import glob
import os
import sys
import cdo

def main(argv):
   inputfile = argv[0]
   outputfile = argv[1]
   print ('Input file is "', inputfile)
   print ('Output file is "', outputfile)
   
   chrtout_files = glob.glob(inputfile)
   if len(chrtout_files) > 1000:
     print('Number of files exceeds 1000, performing consolidation in stages')
     # merge using intermediate files
     i = 0
     intermediate_files = []
     while i <= len(chrtout_files):
       fname = f'{outputfile}.{i}.tmp'
       print(f'\t> processing intermediate file {fname}...', end='', flush=True)
       cdo.Cdo().cat(input=chrtout_files[i:i+1000], output=fname)
       print('done')
       intermediate_files.append(fname)
       i += 1000

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
