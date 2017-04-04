function GetTxtFile(srcpath,dstpath,name)
%###########################################
% Record the list of files into a .txt file
% Example:
% GetTxtFile('./data/','./','train')
%###########################################
fnames = dir(fullfile(srcpath, '*.mat'));

textFileName = strcat(dstpath,name,'.txt');
textFile = fopen(textFileName,'w');

for i = 1 : length(fnames)
    fprintf('Saving %s\n', fnames(i).name)
    a = fnames(i).name;
    
    fprintf(textFile,'%s\n',fnames(i).name);
    
end

fclose(textFile);