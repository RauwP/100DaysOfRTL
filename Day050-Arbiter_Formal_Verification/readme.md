# Day 50: Formal Verification for an Arbiter

## Task Description

This challenge applies formal verification to a common control structure: the Fixed Priority Arbiter from Day 14. The goal is to write a set of SystemVerilog Assertions (SVA) that mathematically prove the arbiter's logic is correct under all possible input conditions.

Verifying an arbiter is about proving adherence to a set of rules. We will write properties to ensure the arbiter correctly enforces its priority scheme and generates a valid, one-hot grant signal.

### Core Functionality:

You must write formal properties to verify the three primary rules of the arbiter:

1.  **Priority Enforcement:** The grant signal (`gnt_o`) must be issued to the highest-priority requester. For this arbiter, the highest bit index has the highest priority (e.g., `req_i[3]` has priority over `req_i[2]`). The assertion must prove this for all possible request combinations.
2.  **One-Hot Grant:** The output grant vector (`gnt_o`) must be "one-hot," meaning at most one bit can be high at any given time.
3.  **No Grant Without Request:** A grant bit (`gnt_o[i]`) can only be high if the corresponding request bit (`req_i[i]`) is also high. A grant should never be issued to a non-requesting port.

### Key Concepts & Syntax Learned

This task requires modeling priority logic and vector properties using SVA.

* **Modeling Priority Logic:** Capturing priority in an assertion can be complex. A common way is to build a helper function or use a series of implications. For example, to prove `req_i[3]` has the highest priority, you can assert: "If `req_i[3]` is high, then `gnt_o[3]` must be high." For the next level, you'd assert: "If `req_i[3]` is low AND `req_i[2]` is high, then `gnt_o[2]` must be high," and so on.

* **Checking Vector Properties with `$countones`**: SystemVerilog provides built-in system functions that are very useful in assertions. To verify the one-hot property, `$countones()` is the perfect tool. It counts the number of bits that are set to '1' in a vector.

* **Writing the Properties:** Here is how you could write the properties for the arbiter using the project's macros.

    ```systemverilog
    // In day50.sv, inside the Arbiter module

    // Property 1: Check the one-hot grant condition.
    // The number of set bits in the grant vector must be less than or equal to 1.
    `ASSERT(OneHotGrant_A, $countones(gnt_o) <= 1)

    // Property 2: Check that a grant implies a request.
    // This can be checked for all bits at once. If any bit in gnt_o is high,
    // the corresponding bit in req_i must also have been high.
    // (gnt_o[i] -> req_i[i]) is equivalent to (~gnt_o[i] | req_i[i])
    `ASSERT(GrantImpliesRequest_A, ((~gnt_o | req_i) == '1))

    // Property 3: Check priority. This requires individual checks.
    // Check highest priority:
    `ASSERT(Priority3_A, `IMPLIES(req_i[3], gnt_o == 4'b1000))
    // Check next priority:
    `ASSERT(Priority2_A, `IMPLIES(!req_i[3] && req_i[2], gnt_o == 4'b0100))
    // and so on...
    ```

