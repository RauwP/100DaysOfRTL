//day44_if

interface day44_if #(parameter NUM_PORTS = 8)();
	logic [NUM_PORTS-1:0] req, gnt;
endinterface