
 add_fsm_encoding \
       {uart_comm.send_status} \
       { }  \
       {{0000 00} {0010 01} {0100 10} {1000 11} }

 add_fsm_encoding \
       {uart_comm.recv_status} \
       { }  \
       {{0000 000} {0001 001} {0010 010} {0100 011} {1000 100} }

 add_fsm_encoding \
       {multchan_comm.send_status} \
       { }  \
       {{0000 000} {0001 001} {0010 010} {0100 011} {1000 100} }
