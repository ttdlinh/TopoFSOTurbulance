# Lib
import sys
import re

#-------------------------------------------------------------------------------
# Var
file_input = None
file_output = None


#-------------------------------------------------------------------------------
# Xu ly
def process():
    global file_input
    global file_output
    buff = 4096
    first_line = ""
    case = 0
    location = []
    ma_tran_D = []

    # Doc du lieu
    file_in = open(file_input,"r")
    text = file_in.readlines(buff)
    while text != []:
        for line in text:
            line= line.strip()
            # Neu la dong dau tien
            if first_line  == "":
                first_line = line
                continue

            # Neu dang doc so node
            if case == 0:
                case = 1
                n = line
                continue

            # Neu doc danh sach not thi gan case = 2
            if line == "#x #y #z":
                case = 2
                continue

            # Neu doc nguong BER gan case = 3
            if line == "#nguong BER":
                case = 3
                continue

            # Neu doc ma tran yeu cau
            if line == "#source_index dest_index bw don vi Mbps":
                case = 5
                continue

            # neu case = 2
            if case == 2:
                line_split = re.split(" ",line)
                line_dict = {
                    "x" : line_split[0],
                    "y" : line_split[1],
                    "z" : line_split[2]
                    }
                location.append(line_dict)
                continue

            # neu case = 3
            if case == 3:
                case = 4
                BER = line
                continue

            # Neu case = 4
            if case == 5:
                line_split = re.split(" ",line)
                if len(line_split) < 2:
                    break
                line_dict = {
                    "src" : line_split[0],
                    "dst" : line_split[1],
                    "bw"  : line_split[2]
                }
                ma_tran_D.append(line_dict)
                continue
        text = file_in.readlines(buff)

    # Ghi file
    write_file = open(file_output,"w")

    write_file.write("n = " + str(n)+";\n")

    write_file.write("alpha = 1;\n")

    write_file.write("k = " +str(n)+";\n")

    write_file.write("beta = "+ str(BER)+";\n")

    write_file.write("d = "+ str(len(ma_tran_D))+ ";\n")

    write_file.write("cap = 1000;\n\n")

    ok = 0
    for item in location:
        string =""
        if ok == 0:
            ok = 1
            string = "A = ["
            string += "[" +str(item["x"])+" "+str(item["y"])+" "+str(item["z"])+ "]\n"
        else:
            string += "[" +str(item["x"])+" "+str(item["y"])+" "+str(item["z"])+ "]\n"
        write_file.write(string)
    write_file.write("];\n\n")

    ok = 0
    for item in ma_tran_D:
        string =""
        if ok == 0:
            ok = 1
            string = "D = ["
            string += "[" +str(item["src"])+" "+str(item["dst"])+" "+str(item["bw"])+ "]\n"
        else:
            string += "[" +str(item["src"])+" "+str(item["dst"])+" "+str(item["bw"])+ "]\n"
        write_file.write(string)
    write_file.write("];\n\n")

    write_file.write("SheetConnection my_sheet(\"BER and distance.xlsx\");\n")

    write_file.write("BER from SheetRead(my_sheet,\"\'Sheet1\'!C2:C21\");\n")

#-------------------------------------------------------------------------------
# Main
#-------------------------------------------------------------------------------
def main():
    process()
    pass

if __name__ == '__main__':
    #file_input = "D:/inputnodes.txt"
    #file_output = "D:/output.dat"
    file_input = sys.argv[1]
    file_output = sys.argv[2]
    main()
