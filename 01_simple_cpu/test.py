import os
import random
import subprocess
import argparse

tests = [ 
          [ 'task1/1', 'data/task1/1/inst_disassembled.mem', 'data/task1/1/reg-in.mem', 'data/task1/1/reg-out.mem' ],
          [ 'task1/2', 'data/task1/2/inst_disassembled.mem', 'data/task1/2/reg-in.mem', 'data/task1/2/reg-out.mem' ],
          [ 'task2/1', 'data/task2/1/inst_disassembled.mem', 'data/task2/1/reg-in.mem', 'data/task2/1/reg-out.mem' ],
          [ 'task2/2', 'data/task2/2/inst_disassembled.mem', 'data/task2/2/reg-in.mem', 'data/task2/2/reg-out.mem' ],
          [ 'task3/1', 'data/task3/1/inst_disassembled.mem', 'data/task3/1/reg-in.mem', 'data/task3/1/reg-out.mem' ],
          [ 'task3/2', 'data/task3/2/inst_disassembled.mem', 'data/task3/2/reg-in.mem', 'data/task3/2/reg-out.mem' ],
          [ 'task4/1', 'data/task4/1/inst_disassembled.mem', 'data/task4/1/reg-in.mem', 'data/task4/1/reg-out.mem' ],
          [ 'task5/1', 'data/task5/1/inst_disassembled.mem', 'data/task5/1/reg-in.mem', 'data/task5/1/reg-out.mem' ],
          [ 'fibonacci', 'data/fib/inst_disassembled.mem', 'data/fib/reg-in.mem', 'data/fib/reg-out.mem' ]
        ]
def get_ans_reg(path_to_reg):
    cwd = os.getcwd()
    reg_f = open(os.path.join(cwd, path_to_reg), "r")
    lines = reg_f.readlines()

    reg = [] 
    for line in lines:
        words = line.split()
        if len(words) == 0:
            continue
        reg.append(int(words[0]))
    return reg

def execute_veri():
    process = os.system("./simple_cpu > data/stat.out")

def get_veri_reg():
    cwd = os.getcwd()
    reg_f = open(os.path.join(cwd, "data/stat.out"), "r")
    lines = reg_f.readlines()
    
    reg = []
    for line in lines:
        words = line.split()
        if len(words) == 0:
            continue
        if "Reg" in words[1]:
            reg.append(int(words[3]))
    return reg

def main():
    parser = argparse.ArgumentParser(description="Test Verilog")

    print("[*] test start")
    print(tests[0])
    for test in tests:
        print("starting test " + test[0])
        os.system('cp ' + test[1] + ' ./data/inst.mem')
        os.system('cp ' + test[2] + ' ./data/register.mem')
        ans_reg = get_ans_reg(test[3])

        print("your register values should be")
        print(ans_reg)

        execute_veri()

        veri_reg = get_veri_reg()
        print("your verilog register values are")
        print(veri_reg)

        if ans_reg == veri_reg:
            print("test passed")
            print("-------------------------------")
        else:
            print("test failed")
            print("-------------------------------")

        os.system("rm ./data/stat.out")


if __name__ == '__main__':
    main()
