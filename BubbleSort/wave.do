onerror {resume}
quietly virtual signal -install /bubblesort_tb/ram2 { (context /bubblesort_tb/ram2 )(memoryarray(0) &memoryarray(1) &memoryarray(2) &memoryarray(3) &memoryarray(4) &memoryarray(5) &memoryarray(6) &memoryarray(7) &memoryarray(8) &memoryarray(9) &memoryarray(10) )} memory
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider BubbleSort
add wave -noupdate -format Logic -radix hexadecimal /bubblesort_tb/processor_beh/clk
add wave -noupdate -format Logic -radix hexadecimal /bubblesort_tb/processor_beh/rst
add wave -noupdate -format Logic -radix hexadecimal /bubblesort_tb/processor_beh/start
add wave -noupdate -format Literal -radix hexadecimal /bubblesort_tb/processor_beh/startaddr
add wave -noupdate -format Literal -radix hexadecimal /bubblesort_tb/processor_beh/size
add wave -noupdate -format Logic -radix hexadecimal /bubblesort_tb/processor_beh/up
add wave -noupdate -format Logic -radix hexadecimal /bubblesort_tb/processor_beh/done
add wave -noupdate -divider RAM1
add wave -noupdate -format Literal -radix hexadecimal /bubblesort_tb/ram1/memoryarray
add wave -noupdate -divider BubbleSort_str
add wave -noupdate -format Logic -radix hexadecimal /bubblesort_tb/processor_str/clk
add wave -noupdate -format Logic -radix hexadecimal /bubblesort_tb/processor_str/rst
add wave -noupdate -format Logic -radix hexadecimal /bubblesort_tb/processor_str/start
add wave -noupdate -format Literal -radix hexadecimal /bubblesort_tb/processor_str/startaddr
add wave -noupdate -format Literal -radix hexadecimal /bubblesort_tb/processor_str/size
add wave -noupdate -format Logic -radix hexadecimal /bubblesort_tb/processor_str/up
add wave -noupdate -format Logic -radix hexadecimal /bubblesort_tb/processor_str/done
add wave -noupdate -divider RAM2
add wave -noupdate -format Literal -radix hexadecimal /bubblesort_tb/ram2/memoryarray
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6985 ns} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {26250 ns}
