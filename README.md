<h1 align="center">Hardware Accelerator for Genetic Local Sequence Alignment</h1>

<h1 align="center">
  <img src="HomePageContent/Images/sw_main.jpeg" height="300">
</h1>

<div align="center">
    <p><strong>This project was completed as part of a B.Sc. special project at the Technion, in collaboration with Apple</strong></p>
</div>


<h4 align="center">
    Dor Lerman:
    <a href="https://www.linkedin.com/in/dor-lerman-962481336/"><img src="HomePageContent/Images/Linkedin_icon_readme.png" width="30" height="30"/></a>
    <a href="https://github.com/dorlerman80"><img src="HomePageContent/Images/GitHub_icon_readme.png" width="30" height="30"/></a>
</h4>

<h4 align="center">
    Niv Bar-Tov:
    <a href="https://www.linkedin.com/in/niv-bar-tov"><img src="HomePageContent/Images/Linkedin_icon_readme.png" width="30" height="30"/></a>
    <a href="https://github.com/nivbartov"><img src="HomePageContent/Images/GitHub_icon_readme.png" width="30" height="30"/></a>
</h4>

## 📖 Table of Contents

- [Overview](#-overview)
- [Key Features](#-key-features)
- [Architecture](#-architecture)
- [Available Tests](#-available-tests)
- [How to Build](#-how-to-build)
- [How to Run a Test or Regression](#-how-to-run-a-test-or-regression)
- [License](#-license)

## 📘 Overview

LocalAlignAccelerator is a VLSI-based project that implements a dedicated hardware accelerator for the Smith-Waterman algorithm. It drastically reduces the runtime of local sequence alignment using parallel processing and efficient control logic. The accelerator was designed, verified, and synthesized as part of an academic-industry collaboration with **Apple Israel**.

## 🚀 Key Features

- Implements **Smith-Waterman algorithm** in hardware
- Supports **32-letter DNA sequences** (A, T, G, C)
- Outputs aligned sequences and similarity score
- Fully custom **SystemVerilog** implementation
- Multi-cycle architecture
- UVM-based testbench for full functional verification
- Synthesizable for **TSMC 65nm** technology
- Target frequency: **100 MHz**
- Efficient **area usage**: 1.0mm × 1.0mm sq. mm.


## 🧠 Architecture

The top-level unit of the **LocalAlignAccelerator** consists of the following sub-units:

1. **Sequences Buffer**  
   Stores the inserted sequences (query and database). Accepts input serially and buffers it for computation.

2. **Matrix Calculation**  
   Responsible for filling the substitution matrix by calculating the score of each cell based on match, mismatch, and gap penalties.

3. **Matrix Memory**  
   Stores traceback information for each cell in the substitution matrix. This module is implemented using registers and holds the source direction and zero-score flags.

4. **Max Registers**  
   Tracks and updates the maximum alignment score and its position (i, j) in the matrix. Updated after every computation cycle if a higher score is found.

5. **Traceback Unit**  
   Recursively traces back from the cell with the maximum score to a cell with a score of zero. Generates the optimal local alignment in reverse order using the traceback information stored in the Matrix Memory.

6. **Controller**  
   A finite state machine (FSM) that orchestrates all other sub-units by providing necessary control signals throughout the alignment process.

More information can be read from the [SW_accelerator_MAS.pdf](Documents/SW_Accelerator_MAS.pdf)
in the Architecture section.


## 🧪 Available Tests

The testbench includes multiple UVM tests to validate the design under different scenarios. Each test targets specific functionality or edge conditions of the accelerator.

| Test Name        | Description |
|------------------|-------------|
| `base_test`      | Default functional test with fixed sequences, clock, and reset behavior. Verifies core alignment flow. |
| `clk_test`       | Randomizes the clock duty cycle and period to verify robustness under varying timing conditions. |
| `rst_test`       | Randomizes reset duration and timing to ensure proper reinitialization of the design. |
| `clk_rst_test`   | Combines randomized clock and reset to test the system under more complex asynchronous conditions. |
| `start_test`     | Randomly applies the `start` signal to test proper sequence latching and computation triggering. |
| `letters_test`   | Tests various similarity levels between query and database sequences (e.g., 0%, 50%, 100%). Validates scoring behavior. |
| `score_test`     | Verifies correctness of score output across varying match/mismatch/gap configurations. |
| `alignment_test` | Checks if the reconstructed aligned sequences are valid and match expected tracebacks. |
| `max_score_test` | Specifically tests the tracking of the maximum score and its location in the matrix. |

All tests include self-checking logic, randomized input sequences, and scoreboard comparison against a golden reference model.

More information can be read from the [SW_accelerator_MAS.pdf](Documents/SW_Accelerator_MAS.pdf)
in the Verification section.


## 🔧 How to Build

```bash
git clone https://github.com/dorlerman80/LocalAlignAccelerator.git
cd LocalAlignAccelerator
make comp
```

## 🔧 How to Run a Test or Regression

To execute the regression script with a specified number of tests:

```bash
run_regression.sh <number_of_tests>
```

For example:

```bash
run_regression.sh 1800 &
```

This will:

1. Initialize the regression run and create a dated regression directory.
2. Execute `run_test.sh` for each test.
3. Randomly select a test and configuration for each run.
4. Create a directory for the test inside the regression folder.
5. Build and simulate the test using the test's Makefile and a randomly chosen seed.
6. Generate build and simulation logs.
7. Check for `UVM_ERROR` in the logs to determine pass/fail status.
8. Save test logs and record results in `regression_results.txt`.
9. Collect coverage files once all tests are complete.
10. Generate a coverage report viewable at:

```bash
firefox ./regression_<date>/coverage_report/dashboard.html
```

To run a single specific test:

```bash
run_test.sh <test_name>
```

For example:

```bash
run_test.sh valid_test
```

After the test runs, you'll be notified if it passed or failed, and logs will be available for review.


## License

This project is licensed under the MIT License - see the `LICENSE.md` file for details.
