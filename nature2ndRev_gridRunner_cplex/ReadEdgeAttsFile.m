function Primitives = ReadEdgeAttsFile (FileName)

%% This function reads in the *.atts file (passed as an argument)
%% containing the list of edge SEGMENTS found in an image and returns it as
%% a list structure, "Primitives". The *.atts file can be created using
%% "RunLolaScript.sh"
%% To control combinatorics only the 300 largest edge segments are
%% returned. This can be changed easily by editing the statement towards
%% the end of this function. 
%%
%% Last edited by Sudeep Sarkar (sarkar@cse.usf.edu)
%%
%% Copyright (C) 2011,  Sudeep Sarkar 
%% All rights reserved.
%%     This program is free software for research and educational purposes
%%     ONLY. For these purposes, you can redistribute it and/or modify it
%%     under the terms of the GNU General Public License as published by
%%     the Free Software Foundation, either version 3 of the License, or
%%     (at your option) any later version. This program is distributed in
%%     the hope that it will be useful, but WITHOUT ANY WARRANTY; without
%%     even the implied warranty of MERCHANTABILITY or FITNESS FOR A
%%     PARTICULAR PURPOSE.  See the GNU General Public License for more
%%     details. You should have received a copy of the GNU General Public
%%     License along with this program.  If not, see
%%     <http://www.gnu.org/licenses/>.

NUM = 1; N_line = 0; N_arc = 0;
infile = fopen(FileName, 'r');
Lengths = [];
flag = 0;
paren = fscanf(infile, ' %c', 1);
if (paren == '(')
    while (flag==0)
        paren = fscanf(infile, ' %c', 1);
        if (paren == ')')     flag = 1; break;
        else
            Primitives(NUM).id =  fscanf(infile, ' %d', 1);
           % fprintf (1, '%d ', Primitives(NUM).id);
            paren = fscanf(infile, ' %c', 1);
            Primitives(NUM).yc = fscanf(infile, ' %f', 1);
            Primitives(NUM).xc = fscanf(infile, ' %f', 1);
            Primitives(NUM).radius = fscanf(infile, ' %f', 1);
            if (Primitives(NUM).radius < 9999.0)
                Primitives(NUM).radius = (-Primitives(NUM).radius);
            else Primitives(NUM).radius = 999999.0;
            end;
            if Primitives(NUM).radius > 99999.0
                Primitives(NUM).mark = 'LINE'; N_line = N_line + 1;
            else
                Primitives(NUM).mark = 'ARC'; N_arc = N_arc + 1;
            end;
            
        end;

        Primitives(NUM).error = fscanf(infile, ' %f', 1);
        paren = fscanf(infile, ' %c', 1); % reads in ( 
        Primitives(NUM).sy = fscanf(infile, ' %d', 1);
        Primitives(NUM).sx = fscanf(infile, ' %d', 1);
        paren = fscanf(infile, ' %c', 1); % reads in )
        
        paren = fscanf(infile, ' %c', 1);
        Primitives(NUM).ey = fscanf(infile, ' %d', 1);
        Primitives(NUM).ex = fscanf(infile, ' %d', 1);
        paren = fscanf(infile, ' %c', 1);

        Primitives(NUM).slope = fscanf(infile, ' %f', 1);
        fscanf(infile, ' %f', 1);
        Primitives(NUM).mag_plus = fscanf(infile, ' %f', 1);
        Primitives(NUM).width_plus = fscanf(infile, ' %f', 1);
        Primitives(NUM).mag_minus = fscanf(infile, ' %f', 1);
        Primitives(NUM).width_minus = fscanf(infile, ' %f', 1);
        
        fscanf(infile, ' %f', 2); % reads in the grad dir
        paren = fscanf(infile, ' %c', 1); %reads in (
        fscanf(infile, ' %f', 2);
        paren = fscanf(infile, ' %c', 1); % reads in )
        fscanf(infile, ' %f', 2);
        
        paren = fscanf(infile, ' %c', 1); % reads in )
        paren = fscanf(infile, ' %c', 1); % reads in (
        flag1 = 0;
        Primitives(NUM).length = 1;
        while (flag1==0) 
            paren = fscanf(infile, ' %c', 1);
            if (paren == ')')    flag1 = 1;
            else
                
                Primitives(NUM).y(Primitives(NUM).length) = fscanf(infile, '%d ', 1);
                Primitives(NUM).x(Primitives(NUM).length) = fscanf(infile, '%d ', 1);
                Primitives(NUM).length = Primitives(NUM).length + 1;
                paren = fscanf(infile, ' %c', 1);
            end;
        end;
        Primitives(NUM).length = Primitives(NUM).length - 1;
        Primitives(NUM).cx = Primitives(NUM).x(round(Primitives(NUM).length/2));
        Primitives(NUM).cy = Primitives(NUM).y(round(Primitives(NUM).length/2));
        paren = fscanf(infile, ' %c', 1);
        Lengths = [Lengths Primitives(NUM).length];
        NUM = NUM + 1;
    end;
end;
[Lengths index] = sort(Lengths, 'descend');
Primitives = Primitives(index(1:min(NUM-1,3000))); % return only the 300 longest elements
 
fprintf (1, '\n %d longest primitives returned (%d lines, %d arcs read, but returning only 3000 max elements for computational reasons)\n', length(Primitives), N_line, N_arc);
fclose(infile);
