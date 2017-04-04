function concate(srcpath1, srcpath2, dstpath)
    fnames1 = dir(fullfile(srcpath1, '*.mat'));
    for i = 1 : length(fnames1)
        fprintf('Read %s\n',fnames1(i).name);
        label1 = load(fullfile(srcpath1, fnames1(i).name));
        label2 = load(fullfile(srcpath2, fnames1(i).name));
        desc = [label1.desc,label2.desc]; 
        parsave(fullfile(dstpath, fnames1(i).name), desc);
    end
    
end

function parsave(fn, desc)
save(fn, 'desc', '-v7.3');
end