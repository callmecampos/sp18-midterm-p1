'use strict';

/* Add the dependencies you're testing */
const Crowdsale = artifacts.require("./Crowdsale.sol");
const Queue = artifacts.require("./Queue.sol");
const Token = artifacts.require("./Token.sol");

contract('testTemplate', function(accounts) {
	/* Define your constant variables and instantiate constantly changing
	 * ones
	 */
	 const args = {};
 	let launch;
 	// YOUR CODE HERE

 	/* Do something before every `describe` method */
 	beforeEach(async function() {
 		// YOUR CODE HERE
 		launch = await Crowdsale.new();
		launch.SetDetails(1000000, 1000, "ETH", "Ethereum", 18);
 	});

 	/* Group test cases together
 	 * Make sure to provide descriptive strings for method arguements and
 	 * assert statements
 	 */
 	describe('Check', function() {
 		it("time cap", async function() {
 			// YOUR CODE HERE
			let cap = launch.setTimeCap(20);
 			assert.ok(cap);
 		});
 	});
});
