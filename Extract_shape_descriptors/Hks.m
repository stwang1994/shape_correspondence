function [hks] = Hks(pathname,filename,dstpath)

%infile = 'sphereunifsm.off';
%source_id = 299;
%%the index of the point on the surface to which you compute the distance
%%from all other points. Input is assumed to start with zero, so we shift.
% centerind = source_id+1; 

%[filename,pathname] = uigetfile('*.off','OFF-files (*.off)','Ñ¡ÔñoffÎÄ¼þ');
infile = fullfile(pathname, filename);

%read mesh from the off file
%fid=fopen(infile);
%fgetl(fid);
%nos = fscanf(fid, '%d %d  %d', [3 1]);
%nopts = nos(1);
%notrg = nos(2);
%coord = fscanf(fid, '%g %g  %g', [3 nopts]);
%coord = coord';
%triang=fscanf(fid, '%d %d %d %d',[4 notrg]);
%triang=triang';
%triang=triang(:,2:4)+1; %%we have added 1 because the vertex indices start from 0 in vtk format
%fclose(fid);

fid = load(infile);
coord = [fid.shape.X,fid.shape.Y, fid.shape.Z];
triang = fid.shape.TRIV;

nopts = length(fid.shape.X);
notrg = length(triang);

tic;
bir=[1 1 1];
trgarea=zeros(1,notrg);
for i=1:notrg
    trgx=[coord(triang(i,1),1) coord(triang(i,2),1) coord(triang(i,3),1)];
    trgy=[coord(triang(i,1),2) coord(triang(i,2),2) coord(triang(i,3),2)];
    trgz=[coord(triang(i,1),3) coord(triang(i,2),3) coord(triang(i,3),3)];
    aa=[trgx; trgy; bir];
    bb=[trgx; trgz; bir];
    cc=[trgy; trgz; bir];
    area=sqrt(det(aa)^2+det(bb)^2+det(cc)^2)/2;
    trgarea(i)=area;
end


%find the approximate voronoi area of each vertex
AM = zeros(nopts, 1);
for i=1:notrg
    AM(triang(i,1:3)) = AM(triang(i,1:3)) + trgarea(i)/3;
end

AM = AM/sum(AM);

%now construct the cotan laplacian and find the eigenfuncitons
A = sparse(nopts, nopts);

for i=1:notrg
    for ii=1:3
        for jj=(ii+1):3
            kk = 6 - ii - jj; % third vertex no
            v1 = triang(i,ii);
            v2 = triang(i,jj);
            v3 = triang(i,kk);
            e1 = [coord(v1,1) coord(v1,2) coord(v1,3)] - [coord(v2,1) coord(v2,2) coord(v2,3)];
            e2 = [coord(v2,1) coord(v2,2) coord(v2,3)] - [coord(v3,1) coord(v3,2) coord(v3,3)];
            e3 = [coord(v1,1) coord(v1,2) coord(v1,3)] - [coord(v3,1) coord(v3,2) coord(v3,3)];
            cosa = e2* e3'/sqrt(sum(e2.^2)*sum(e3.^2));
            sina = sqrt(1 - cosa^2);
            cota = cosa/sina;
            w = 0.5*cota;
            A(v1, v1) = A(v1, v1) - w;
            A(v1, v2) = A(v1, v2) + w;
            A(v2, v2) = A(v2, v2) - w;
            A(v2, v1) = A(v2, v1) + w;
        end
    end

end

T = sparse([1:nopts], [1:nopts], (AM), nopts, nopts, nopts);

preprocess_time = toc

W = A;
Am = T;

nev = min(300, length(AM));

[evecs evals] = eigs(W, Am, nev, -1e-5);
evals = diag(evals);
tmin = abs(4*log(10) / evals(end));
tmax = abs(4*log(10) / evals(2));
nstep = 100;

stepsize = (log(tmax) - log(tmin)) / nstep;
logts = log(tmin):stepsize:log(tmax);
ts = exp(logts);

scale = true;
if scale == true, 
   hks = abs( evecs(:, 2:end) ).^2 * exp( ( abs(evals(2)) - abs(evals(2:end)) )  * ts);
   colsum = sum(Am*hks);
   scale = 1.0./ colsum; 
   scalem = sparse([1:length(scale)], [1:length(scale)], scale);
   hks = hks * scalem;
else
   hks = abs( evecs(:, 2:end) ).^2 * exp( - abs(evals(2:end)) * ts);
end

parsave(fullfile(dstpath, filename), hks);
end

% distler = mean(hks,2);
% ofid = fopen('hksmap.vtk','w');
% fprintf(ofid, '# vtk DataFile Version 3.0\n');
% fprintf(ofid,'vtk output\n');
% fprintf(ofid,'ASCII\n');
% fprintf(ofid,'DATASET POLYDATA\n');
% fprintf(ofid,'POINTS %d float\n', nopts);
% fprintf(ofid,'%g %g %g\n', coord');
% fprintf(ofid,'POLYGONS %d %d\n', notrg, 4*notrg)
% fprintf(ofid,'3 %d %d %d\n', triang'-1);
% fprintf(ofid,'\n');
% fprintf(ofid,'POINT_DATA %d\n', nopts);
% fprintf(ofid,'SCALARS distance_from float\n');
% fprintf(ofid,'LOOKUP_TABLE default\n');
% fprintf(ofid,'%g\n', distler);
% fclose(ofid);


% ofid = fopen(outfile,'w');
% fprintf(ofid,'%g\n', distler);
% fclose(ofid);
function parsave(fn, desc)
save(fn, 'desc', '-v7.3');
end