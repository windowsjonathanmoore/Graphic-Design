#include <iostream>
#include <cstdlib>
#include <cassert>
#include <string>

using namespace std;

#include "LinkedList.h"

int main(int argc, char* argv[]) {

    LinkedList<int> i1;
    assert (i1.size() == 0);
    assert (i1.empty());

    i1.push_front(1);
    assert (i1.size() == 1);
    assert (!i1.empty());

    i1.push_back(2);
    i1.push_back(3);

    LinkedList<int> i2 = i1;
    assert (i2.size() == 3);

    i1.pop_front();
    assert (i1.size() == 2);
    assert (i2.size() == 3);

    i1.dump();
    i2.dump();

    LinkedList<string> s;
    s.push_front("third");
    s.push_front("second");
    s.push_front("first");
    s.dump();

    return EXIT_SUCCESS;
}
