
#ifndef _LINKEDLIST_H_
#define _LINKEDLIST_H_

using namespace std;

/*!Begin Snippet:fullnode*/
/*!Begin Snippet:private*/
template <typename T>
class LinkedList {

private:
    class Node {
        friend class LinkedList<T>;

    private:
        T data;
        Node* next;

    public:
        Node(T d, Node* n = NULL) : data(d), next(n) {}}
    ;
    /*!End Snippet:fullnode*/

    Node* head;  // Beginning of list
    Node* tail;  // End of list
    int count;    // Number of nodes in list
    /*!End Snippet:private*/

public:

    LinkedList(const LinkedList<T>& src);  // Copy constructor
    ~LinkedList(void);  // Destructor

    /*!Begin Snippet:simple*/
    // Default constructor
    LinkedList(void) : head(NULL), tail(NULL), count(0) {}

    // Returns a reference to first element
    T& front(void) {
        assert (head != NULL);
        return head->data;
    }

    // Returns a reference to last element
    T& back(void) {
        assert (tail != NULL);
        return tail->data;
    }

    // Returns count of elements of list
    int size(void) {
        return count;
    }

    // Returns whether or not list contains any elements
    bool empty(void) {
        return count == 0;
    }
    /*!End Snippet:simple*/

    void push_front(T);  // Insert element at beginning
    void push_back(T);   // Insert element at end
    void pop_front(void);  // Remove element from beginning
    void pop_back(void);  // Remove element from end

    void dump(void);  // Output contents of list
};

/*!Begin Snippet:copyconstructor*/
// Copy constructor
template <typename T>
LinkedList<T>::LinkedList(const LinkedList<T>& src) :
        head(NULL), tail(NULL), count(0) {

    Node* current = src.head;
    while (current != NULL) {
        this->push_back(current->data);
        current = current->next;
    }

}
/*!End Snippet:copyconstructor*/

/*!Begin Snippet:destructor*/
// Destructor
template <typename T>
LinkedList<T>::~LinkedList(void) {

    while (! this->empty()) {
        this->pop_front();
    }
}
/*!End Snippet:destructor*/

/*!Begin Snippet:pushfront*/
// Insert an element at the beginning
template <typename T>
void LinkedList<T>::push_front(T d) {

    Node* new_head = new Node(d, head);

    if (this->empty()) {
        head = new_head;
        tail = new_head;
    } else {
        head = new_head;
    }
    count++;
}
/*!End Snippet:pushfront*/

/*!Begin Snippet:pushback*/
// Insert an element at the end
template <typename T>
void LinkedList<T>::push_back(T d) {

    Node* new_tail = new Node(d, NULL);

    if (this->empty()) {
        head = new_tail;
    } else {
        tail->next = new_tail;
    }

    tail = new_tail;
    count++;
}
/*!End Snippet:pushback*/

/*!Begin Snippet:popfront*/
// Remove an element from the beginning
template <typename T>
void LinkedList<T>::pop_front(void) {

    assert(head != NULL);

    Node* old_head = head;

    if (this->size() == 1) {
        head = NULL;
        tail = NULL;
    } else {
        head = head->next;
    }

    delete old_head;
    count--;
}
/*!End Snippet:popfront*/

/*!Begin Snippet:popback*/
// Remove an element from the end
template <typename T>
void LinkedList<T>::pop_back(void) {

    assert(tail != NULL);

    Node* old_tail = tail;

    if (this->size() == 1) {
        head = NULL;
        tail = NULL;
    } else {

        // Traverse the list to node just before tail
        Node* current = head;
        while (current->next != tail) {
            current = current->next;
        }

        // Unlink and reposition
        current->next = NULL;
        tail = current;
    }

    delete old_tail;
    count--;
}
/*!End Snippet:popback*/

/*!Begin Snippet:printlist*/
// Display the contents of the list
template <typename T>
void LinkedList<T>::dump(void) {

    cout << "(";

    Node* current = head;

    if (current != NULL) {

        while (current->next != NULL) {
            cout << current->data << ", ";
            current = current->next;
        }
        cout << current->data;
    }

    cout << ")" << endl;
}
/*!End Snippet:printlist*/

/*!End Snippet:filebegin*/
#endif
