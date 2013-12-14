note
	description: "Summary description for {TR_BACKGROUND_TASK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TR_BACKGROUND_TASK
inherit
	THREAD

create
	make_with_function

feature

	make_with_function(a_function: FUNCTION[ANY, TUPLE, ANY]; a_timeout: INTEGER_32)
		do
			function := a_function
			timeout := a_timeout
			create launch_mutex.make
		end

	execute
		do
			print("TR_BACKGROUND_TASK execute runs on thread id: " + current_thread_id.out + "%N")

			create ev_timeout.make_with_interval (timeout)
			ev_timeout.actions.extend (agent stop_execution)
				-- stop execution of this thread after timeout on timeout thread
			function.call (function.operands)
			function_result := function.last_result
		end

	get_result : ANY
		require
			has_terminated: terminated
		do
			Result := function_result
		end

feature {NONE}

	stop_execution
		do
			print("TR_BACKGROUND_TASK stop_execution runs on thread id: " + current_thread_id.out + "%N")

			ev_timeout.set_interval (0) -- stop timeout
			ev_timeout := Void
			exit -- exit this thread (parent thread of EV_TIMEOUTs thread)
		end

feature {NONE}

	function: FUNCTION[ANY, TUPLE, ANY]
	function_result: ANY
	timeout: INTEGER_32
	ev_timeout: EV_TIMEOUT

end
