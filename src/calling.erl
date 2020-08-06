%% @author pavankrishna
%% @doc @todo Add description to calling.


-module(calling).

%% ====================================================================
%% API functions
%% ====================================================================
-export([listen/1]).

%% ====================================================================
%% Internal functions
%% ====================================================================
%keeps process in sleep
sleep()->

  random:seed(now()),

  timer:sleep(random:uniform(100)).

%It recieves messages and checks with time
listen(Message_Receiver)->

  receive

    {introduction_msg, Message_Sender}->

      sleep(), Current_Timestamp = element(3, now()),

      whereis(master) ! {Message_Receiver, " received intro message from ", Message_Sender, Current_Timestamp},

      whereis(Message_Sender) ! {reply, Message_Receiver, Current_Timestamp},listen(Message_Receiver);

    {reply, Message_Sender, Current_Timestamp}->

      sleep(),

      whereis(master) ! {Message_Receiver, " received reply message from ", Message_Sender, Current_Timestamp},listen(Message_Receiver)

      after 1000->

        io:fwrite("~n~nProcess ~w has received no calls for 1 second, ending...", [Message_Receiver])

  end.

