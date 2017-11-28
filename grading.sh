#!/bin/bash

COUNT = 0;

for i in $(ls solutions | sort | grep -v 'sh'); do
	# remove a.out if it exists
    if [ -f ./a.out ]; then
    	rm a.out
   	fi

   	if [ -f output.txt ]; then
   		rm output.txt
   	fi

    clear
    let "COUNT++"

    echo 'Grading DoubleList for student: ' $i
    echo '- solution number: ' $COUNT
    cat 'DoubleList3-Gunnar/'$i'-DoubleList.txt'
    read -p "Grade student? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || continue

    # If there is no separate .h and .cpp file then try to just compile main.cpp
    echo "================== Compiling... ================="
    echo ""
    if [ ! -f 'solutions/'$i/'DoubleList/src/DoubleList.cpp' ]; then
    	echo "Compiling main.cpp only..."
    	g++ 'solutions/'$i/'DoubleList/main.cpp' -w -o a.out || echo "~ COMPILATION FAILED! ~"
    else
    	echo "Compiling main.cpp DoubleList.cpp DoubleList.h..."
    	g++ -I'solutions/'$i/'DoubleList/include' 'solutions/'$i/'DoubleList/src/DoubleList.cpp' 'solutions/'$i/'DoubleList/main.cpp' -w -o a.out || echo "~ COMPILATION FAILED! ~"
    fi
    echo ""
    echo "================ Compiling done! ================"
    

    # Check if there is a resulting compiled file to be run
    echo ""
    if [ ! -f ./a.out ]; then
    	echo "--> There is no compiled object file to run"
    else
        echo "######### Student solution Output #########"
        echo ""
        #valgrind --leak-check=yes --quiet ./a.out
        ./a.out <<< "1 2 3 4 5 6 7" | tee output.txt
        echo ""
        echo "######### End of Student Solution Output #########"
    fi
    echo""

    # Check diff 
    echo "========== Checking diff =========="
    diff expected_output.txt output.txt
    echo "==========  Ending diff  =========="

    # Remove bin and obj folders recursively so that the project can be recompiled with Code::Blocks
    rm -rf 'solutions'/$i/'DoubleList/bin'
    rm -rf 'solutions'/$i/'DoubleList/obj'

    # Getting tree folder structure
    echo ""
    echo "========== Getting folder structure =========="
    tree 'solutions'/$i/'DoubleList'

    

    # Waiting for user input before launching the solution and grading file
    read -p "Press enter to open grading file and codeblocks project"

    # Open the Code::Blocks project and the text file for 
    echo "... Opening files"
    xdg-open 'DoubleList3-Gunnar/'$i'-DoubleList.txt'
    xdg-open 'solutions/'$i/'DoubleList/DoubleList.cbp' &

    

   	# wait for user to press enter twice to grade next solution
    read -p ""
    read -p ""

    clear
done;