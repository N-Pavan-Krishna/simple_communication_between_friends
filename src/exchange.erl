%% @author pavankrishna
%% @doc @todo Add description to exchange.


-module(exchange).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/0]).



%% ====================================================================
%% Internal functions
%% ====================================================================
%start method reads the data from the file and invokes the init and make calls
start()->
  io:fwrite("~n"),
  io:fwrite("** Calls to be made **"),
  io:fwrite("~n"),

  {_, File} = file:consult("src/files/calls.txt"),

  init(File),make_calls(File),

  io:fwrite("~n~n"),
  io:fwrite("Program has ended."),
  io:fwrite("~n~n").
  
%It Displays the Calls List and Generates Process for Sender in the list
init([P|Q])->

  Name_Sender = element(1, P),
  Names_Recievers = element(2, P),

  io:fwrite("~n~w: ~w", [Name_Sender, Names_Recievers]),
  
  register(Name_Sender, spawn(calling, listen, [Name_Sender])),

  init(Q);

init([])-> register(master, self()),
io:fwrite("~n~n").
  
%This method sends messages to all the processes
make_calls([P|Q])->

  call(element(1, P), element(2, P)),

  make_calls(Q);

make_calls([])-> listen().

%This methods sends messages to particular process
call(Message_Sender, [Receiver|Q])->

  whereis(Receiver) ! {introduction_msg, Message_Sender},

  call(Message_Sender, Q);

call(_, [])-> ok.




%It gets reply and prints it
listen()->

  receive

    {PERSON_ONE, MESSAGE, PERSON_TWO, TIMESTAMP}->

      io:fwrite("~w~s~w [~w]~n", [PERSON_ONE, MESSAGE, PERSON_TWO, TIMESTAMP]), listen()

      after 1500->

        io:fwrite("~n~nMaster has received no replies for 1.5 seconds, ending...")

    end.



