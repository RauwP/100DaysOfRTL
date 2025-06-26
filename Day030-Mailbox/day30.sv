module day30_tb();

mailbox ping_mb = new();
mailbox pong_mb = new();

string received_data_pong, received_data_ping, pong = "pong",ping = "ping";
int cnt;
initial begin
	forever begin
		ping_mb.get(received_data_ping);
		$display("%t: %s", $time, received_data_ping);
		#1;
		pong_mb.put($sformatf("%s%0d", pong, cnt));
	end
end

initial begin
	cnt = 0;
	$display("%t: Sending first ping...", $time);
	ping_mb.put($sformatf("%s%0d", ping, cnt));
	forever begin
		pong_mb.get(received_data_pong);
		$display("%t: %s",$time, received_data_pong);
		#1;
		cnt = cnt+1;
		ping_mb.put($sformatf("%s%0d", ping, cnt));
	end
end

initial begin
	#200;
	$finish();
end

endmodule
	