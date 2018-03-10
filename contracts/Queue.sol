pragma solidity ^0.4.15;

/**
 * @title Queue
 * @dev Data structure contract used in `Crowdsale.sol`
 * Allows buyers to line up on a first-in-first-out basis
 * See this example: http://interactivepython.org/courselib/static/pythonds/BasicDS/ImplementingaQueueinPython.html
 */

contract Queue {
	/* State variables */
	uint8 size = 5;
	address[5] fifo;
	uint current;
	uint timeLimit = 50;
	uint headCheckIn;

	/* Add events */
	// YOUR CODE HERE

	/* Add constructor */
	function Queue() public {
		current = 0;
	}

	/* Returns the number of people waiting in line */
	function qsize() constant returns(uint) {
		return current;
	}

	/* Returns whether the queue is empty or not */
	function empty() constant returns(bool) {
		return current == 0;
	}

	/* Returns the address of the person in the front of the queue */
	function getFirst() constant returns(address) {
		return fifo[0];
	}

	/* Allows `msg.sender` to check their position in the queue */
	function checkPlace() constant returns(uint) {
		for (uint x = 0; x < fifo.length; x++) {
			if (fifo[x] == msg.sender) {
				return x;
			}
			return fifo.length;
		}
	}

	function timeLimitExceeded() returns(bool) {
		return now - headCheckIn > timeLimit;
	}

	function isWaiting() returns(bool) {
		return qsize() > 1;
	}

	/* Allows anyone to expel the first person in line if their time
	 * limit is up
	 */
	function checkTime() { // TODO: ask difference between checkTime and dequeue
		if (timeLimitExceeded()) {
			dequeue();
		}
	}

	/* Removes the first person in line; either when their time is up or when
	 * they are done with their purchase
	 */
	function dequeue() private {
		if (current <= 0) {
			return;
		}
		Ejected(fifo[0]);
		for (uint x = 1; x < fifo.length; x++) {
			fifo[x - 1] = fifo[x];
		}
		headCheckIn = now;
		fifo[current] = 0;
		current--;
	}

	/* Places `addr` in the first empty position in the queue */
	function enqueue(address addr) {
		if (current >= fifo.length) {
			return;
		}
		if (current == 0) {
			headCheckIn = now;
		}
		fifo[current] = addr;
		current++;
	}

	event Ejected(address ejected);
}
