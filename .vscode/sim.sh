#!/usr/bin/env bash
# Compila e simula com GHDL o testbench aberto no editor.
# Uso: sim.sh <arquivo_do_testbench.vhd> <tempo_de_simulacao>
# Gera ondas.ghw na pasta do testbench (abrir no GTKWave).
set -e

TB_FILE="$1"
STOP_TIME="$2"
DIR="$(dirname "$TB_FILE")"
cd "$DIR"

# Nome da entidade do testbench (primeira "entity X is" do arquivo)
TOP=$(grep -ioP '^\s*entity\s+\K\w+(?=\s+is)' "$(basename "$TB_FILE")" | head -n 1)
if [ -z "$TOP" ]; then
    echo "Nao achei a entidade em $TB_FILE. Abra o testbench antes de rodar."
    exit 1
fi

mkdir -p build
# -fsynopsys libera os pacotes std_logic_unsigned/std_logic_arith
OPTS="--std=08 -fsynopsys --workdir=build"
# -i importa todos os .vhd da pasta; -m descobre a ordem de compilacao sozinho
ghdl -i $OPTS *.vhd
ghdl -m $OPTS "$TOP"
ghdl -r $OPTS "$TOP" --stop-time="$STOP_TIME" --wave=ondas.ghw

echo "Simulacao de $TOP ate $STOP_TIME concluida: $DIR/ondas.ghw"
