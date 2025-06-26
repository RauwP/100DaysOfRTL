module day29_tb();

event ping, pong;

initial begin //process 1 (ping)
	forever begin
		@ping;
		$display("%t: Ping!", $time);
		#1;
		->pong;
	end
end

initial begin //process 2 (pong)
	$display("%t: Sending first ping...", $time);
	->ping;
	forever begin
		@pong;
		$display("%t: Pong", $time);
		#1;
		->ping;
	end
end

initial begin
	#200;
	$finish();
end

endmodule