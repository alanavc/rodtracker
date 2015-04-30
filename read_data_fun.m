function read_data_fun(pars,outputfile)

%encode bacteria
save_bacteria_fun(pars,outputfile);

%encode all possible movements (automatic)
create_edges_fun(pars,outputfile);

disp('DONE!')


