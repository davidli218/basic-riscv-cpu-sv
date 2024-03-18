import argparse
import subprocess
from pathlib import Path

src_dir = Path(__file__).parent / "src"
test_dir = Path(__file__).parent / "test"
build_dir = Path(__file__).parent / "build"


def build_module(module_name: str, waveform: bool):
    test_name = test_dir / f"{module_name}_tb.sv"
    vpp_name = build_dir / f"{module_name}_tb.vvp"
    vcd_name = build_dir / f"{module_name}_tb.vcd"

    subprocess.run(["iverilog", "-g2012", "-o", vpp_name, "-I", src_dir, test_name])
    subprocess.run(["vvp", vpp_name])

    if waveform:
        subprocess.run(["gtkwave", vcd_name])


def main():
    parser = argparse.ArgumentParser(description='Build a SystemVerilog module')

    parser.add_argument(
        '-m', '--module', required=True,
        help='Compile the specified module and run the testbench'
    )

    parser.add_argument(
        '-w', '--waveform', action='store_true',
        help='Display the waveform after running the testbench'
    )

    args = parser.parse_args()

    build_module(args.module, args.waveform)


if __name__ == '__main__':
    main()
