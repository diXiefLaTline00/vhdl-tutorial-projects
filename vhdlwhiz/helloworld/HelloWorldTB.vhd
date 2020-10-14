
entity HelloWorldTB is
end entity; 

architecture sim of HelloWorldTB is
    begin
        thread_name: process is --process is like a thread
        begin
            report "hello world"; --prints to standard output
            --wait for 1000 ms; --simulation will wait for ever on this command
            --process will repeat after X ms otherwise if no stop is given will terminate
        end process; 
end architecture; 