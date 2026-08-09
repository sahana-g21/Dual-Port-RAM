Dual-Port-RAM

A parameterized, synthesizable True Dual-Port RAM designed in Verilog, verified with a self-checking testbench, and synthesized using Cadence Genus.


📌 Overview

This project implements a Dual-Port RAM that allows two independent read/write operations to happen simultaneously on two separate ports (Port A and Port B), each with its own clock, address, data-in, data-out, and write-enable signals. It also includes collision detection logic to flag when both ports try to access the same memory address in the same cycle.

Dual-port memories like this are widely used in real hardware wherever two different clock domains, cores, or processes need shared, low-latency access to the same memory block — for example, FIFOs, video frame buffers, network packet buffers, and communication between two processor cores on a single SoC.


⚙️ Features

- Fully parameterized: `DATA_WIDTH`, `ADDR_WIDTH`, `DEPTH`
- Two completely independent ports (A and B), each with its own clock
- Synchronous read and write on each port (registered outputs)
- Write-first (read-during-write returns new data) behavior on each port
- Real-time collision detection when both ports touch the same address
- Self-checking testbench with 7 directed test scenarios
- Synthesized and mapped to standard cells using Cadence Genus (578 leaf cells)


📂 Files

Dual-Port-RAM.v 
tb_dual_port_ram.v  


🖥️ Tools Used

- Language: Verilog (IEEE 1364)
- Simulation: Cadence NCLaunch / SimVision (Xcelium)
- Synthesis: Cadence Genus (RTL-to-Gate)


✅ Verification Summary

The testbench covers:
1. Port A write → Port B read
2. Port B write → Port A read
3. Simultaneous write, different addresses (no collision expected)
4. Simultaneous write, same address (collision expected)
5. Read on one port + write on the other, same address (collision expected)
6. Simultaneous read, same address (no collision expected)
7. Full memory fill (all 16 locations) and read-back verification


📊 Simulation Waveform
<img width="3876" height="2262" alt="simulation_waveform" src="https://github.com/user-attachments/assets/4dbec8c1-f172-4534-be6a-680e7f54b378" />

🧠 RTL Code
<img width="3700" height="2101" alt="rtl_code" src="https://github.com/user-attachments/assets/0dbfadb8-548d-4c9b-98c8-77ecf4b74c87" />

✍🏻 Testbench
<img width="3775" height="2200" alt="testbench_code1" src="https://github.com/user-attachments/assets/f24df2a6-5e0d-4d0c-996a-a028ff5c563a" />
<img width="3955" height="2263" alt="testbench_code2" src="https://github.com/user-attachments/assets/bfd03f97-90ae-466b-9f31-566f86942bae" />
<img width="3938" height="2256" alt="testbench_code3" src="https://github.com/user-attachments/assets/b22dc912-0034-4f66-abfe-35e16eb02ca9" />
<img width="3799" height="2173" alt="testbench_code4" src="https://github.com/user-attachments/assets/7096d5b8-0d92-495e-ab1f-a5a76fa2e891" />

▶️ How to Synthesize (Genus)

```tcl
read_hdl Dual-Port-RAM.v
elaborate dual_port_ram
read_sdc constraints.sdc
syn_generic
syn_map
syn_opt
report_timing
report_area
report_power
write_hdl > dual_port_ram_netlist.v
```

📈 Synthesis Reports
Power 
<img width="3000" height="2259" alt="power_report" src="https://github.com/user-attachments/assets/cb0a96e0-3443-4b3a-9686-738ab951ef46" />
Area 
<img width="3050" height="2296" alt="area_report" src="https://github.com/user-attachments/assets/78ee937e-57d8-4203-86c7-a64bf16d3800" />
Timing 
<img width="3080" height="2319" alt="timing_report" src="https://github.com/user-attachments/assets/ff5bfc13-c13c-41b6-9415-46fcc497430a" />
Gate count
<img width="2727" height="3622" alt="gate_count" src="https://github.com/user-attachments/assets/43a457d1-0ce7-4fd3-b8d0-7a781328c9c4" />

🔧Netlist
<img width="4080" height="2374" alt="synthesis_netlist" src="https://github.com/user-attachments/assets/1fe5d2de-b07e-4ae6-8285-dcef4f577250" />

📝Constraints
<img width="3673" height="2213" alt="contraints_code" src="https://github.com/user-attachments/assets/c9d26e5b-3516-47db-88a6-b303feeb86e6" />


🎯 Why This Project

This was built to strengthen practical RTL design and verification skills — writing synthesizable, parameterized Verilog, building a self-checking testbench with directed test cases, and carrying a design through the full ASIC front-end flow (RTL → simulation → synthesis) using industry-standard Cadence tools. Dual-port memory is a foundational building block in real SoC and FPGA designs, making it a strong project to demonstrate RTL fundamentals.


## 📖 Author

Sahana — ECE graduate, VTU. VLSI Design & Verification (Verilog/SystemVerilog, Cadence, ModelSim).
