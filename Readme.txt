The code changes based on the GCNN.

In Extract_shape_descriptors folder, there are files used to compute multiple shape descriptors
Be careful of the folder/file path
1: run run_forrest_run.m
2: In data_process.m to compute hks
3: In crop_data.m, it connects multiple shape descriptors.
If it is identical class, you only need to run the final part.(Concate desc data)
If it is multiple classes, you need to run all parts.
For the (Cut geovec) part, you need run it for several times to crop each shape descriptor, then in Concate desc data part, you need to run it to connect each shape descriptor one by one.

In the Network_training folder, there are files used to train the model
Be careful of the folder/file path
In \Experiment folder, it it main python file to run experiment

experiment1: the whole model
experiment2: improvement comparison
	experiment2_1: the model without multiple shape descriptors
	experiment2_2: the model without concatenating layer
experiment3: architecture comparison
	experiment3_1: the model with input linear layer
	experiment3_2: the model with adjusted linear layer
	experiment3_3: the model with 2 combined GC layer
	experiment3_4: the model with 1 combined GC layer 
experiment4: parameter setting comparison
	experiment4_1: test epoch = 100; train epoch = 100
	experiment4_2: test epoch = 50; train epoch = 100
	experiment4_2: test epoch = 50; train epoch = 50
experiment5: method comparison in multiple class
	change the train.txt and test.txt to evaluate the result

In the command.txt is the command to run the python file

Steps to run the code:
1. Put experiment file you want to run into the network_training folder
2. Run the command line in the command.txt

All other experiment files should be run following above steps, be careful to change the data path according to the Example.py