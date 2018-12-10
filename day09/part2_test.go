package main

import (
	"testing"
)

func TestEmpty(t *testing.T) {
	list := NewDoublyLinkedCircularList()
	output := list.ToString()
	expected := "[]"
	if output != expected {
		t.Errorf("Expected: %v, but it was: %v instead.", expected, output)
	}
}

func TestAppendOne(t *testing.T) {
	list := NewDoublyLinkedCircularList()
	list.Append(0)
	output := list.ToString()
	expected := "[0]"
	if output != expected {
		t.Errorf("Expected: %v, but it was: %v instead.", expected, output)
	}
}

func TestAppendAndRemove(t *testing.T) {
	list := NewDoublyLinkedCircularList()
	list.Append(0)
	list.Remove()
	output := list.ToString()
	expected := "[]"
	if output != expected {
		t.Errorf("Expected: %v, but it was: %v instead.", expected, output)
	}
}

func TestAppendAndRemoveTwice(t *testing.T) {
	list := NewDoublyLinkedCircularList()
	list.Append(0)
	list.Remove()
	list.Remove()
	output := list.ToString()
	expected := "[]"
	if output != expected {
		t.Errorf("Expected: %v, but it was: %v instead.", expected, output)
	}
}

func TestAppendThree(t *testing.T) {
	list := NewDoublyLinkedCircularList()
	list.Append(0)
	list.Append(1)
	list.Append(2)
	output := list.ToString()
	expected := "[0,1,2]"
	if output != expected {
		t.Errorf("Expected: %v, but it was: %v instead.", expected, output)
	}
}

func TestAppendThreeAndRemove(t *testing.T) {
	list := NewDoublyLinkedCircularList()
	list.Append(0)
	list.Append(1)
	list.Append(2)
	list.Remove()
	output := list.ToString()
	expected := "[0,1]"
	if output != expected {
		t.Errorf("Expected: %v, but it was: %v instead.", expected, output)
	}
}


func TestAppendThreeAndRemoveTwiceAndRotateNegative(t *testing.T) {
	list := NewDoublyLinkedCircularList()
	list.Append(0)
	list.Append(1)
	list.Append(2)
	list.Remove()
	list.Remove()
	list.Rotate(-1)
	output := list.ToString()
	expected := "[0]"
	if output != expected {
		t.Errorf("Expected: %v, but it was: %v instead.", expected, output)
	}
}

func TestAppendThreeAndRemoveTwiceAndRotatePositive(t *testing.T) {
	list := NewDoublyLinkedCircularList()
	list.Append(0)
	list.Append(1)
	list.Append(2)
	list.Remove()
	list.Remove()
	list.Rotate(1)
	output := list.ToString()
	expected := "[0]"
	if output != expected {
		t.Errorf("Expected: %v, but it was: %v instead.", expected, output)
	}
}

func TestAppendThreeAndRotateLarge(t *testing.T) {
	list := NewDoublyLinkedCircularList()
	list.Append(0)
	list.Append(1)
	list.Append(2)
	list.Rotate(-6)
	list.Rotate(5)
	output := list.ToString()
	expected := "[2,0,1]"
	if output != expected {
		t.Errorf("Expected: %v, but it was: %v instead.", expected, output)
	}
}

func TestAppendTwoAndAppendInBetween(t *testing.T) {
	list := NewDoublyLinkedCircularList()
	list.Append(0)
	list.Append(2)
	list.Rotate(-1)
	list.Append(1)
	list.Rotate(1)
	output := list.ToString()
	expected := "[0,1,2]"
	if output != expected {
		t.Errorf("Expected: %v, but it was: %v instead.", expected, output)
	}
}

func TestAppendZeroAndNil(t *testing.T) {
	list := NewDoublyLinkedCircularList()
	list.Append(0)
	list.Append(nil)
	output := list.ToString()
	expected := "[0,<nil>]"
	if output != expected {
		t.Errorf("Expected: %v, but it was: %v instead.", expected, output)
	}
}

func TestReadEmpty(t *testing.T) {
	list := NewDoublyLinkedCircularList()
	output := list.Read()
	var expected interface{} = nil
	if output != expected {
		t.Errorf("Expected: %v, but it was: %v instead.", expected, output)
	}
}

func TestReadNil(t *testing.T) {
	list := NewDoublyLinkedCircularList()
	list.Append(0)
	list.Append(nil)
	output := list.Read()
	var expected interface{} = nil
	if output != expected {
		t.Errorf("Expected: %v, but it was: %v instead.", expected, output)
	}
}

func TestAppendZeroAndRead(t *testing.T) {
	list := NewDoublyLinkedCircularList()
	list.Append(0)
	output := list.Read()
	expected := 0
	if output != expected {
		t.Errorf("Expected: %v, but it was: %v instead.", expected, output)
	}
}

func TestAppendZeroOneAndRead(t *testing.T) {
	list := NewDoublyLinkedCircularList()
	list.Append(0)
	list.Append(1)
	output := list.Read()
	expected := 1
	if output != expected {
		t.Errorf("Expected: %v, but it was: %v instead.", expected, output)
	}
}

func TestAppendZeroOneTwoAndRotateAndRead(t *testing.T) {
	list := NewDoublyLinkedCircularList()
	list.Append(0)
	list.Append(1)
	list.Append(2)
	list.Rotate(-1)
	output := list.Read()
	expected := 1
	if output != expected {
		t.Errorf("Expected: %v, but it was: %v instead.", expected, output)
	}
}

func TestAppendZeroOneTwoAndRotateAndRemove(t *testing.T) {
	list := NewDoublyLinkedCircularList()
	list.Append(0)
	list.Append(1)
	list.Append(2)
	list.Rotate(-2)
	list.Remove()
	output := list.ToString()
	expected := "[1,2]"
	if output != expected {
		t.Errorf("Expected: %v, but it was: %v instead.", expected, output)
	}
}

func TestEmptyLength(t *testing.T) {
	list := NewDoublyLinkedCircularList()
	output := list.Length()
	expected := 0
	if output != expected {
		t.Errorf("Expected: %v, but it was: %v instead.", expected, output)
	}
}

func TestEmptyRemoveLength(t *testing.T) {
	list := NewDoublyLinkedCircularList()
	list.Remove()
	output := list.Length()
	expected := 0
	if output != expected {
		t.Errorf("Expected: %v, but it was: %v instead.", expected, output)
	}
}

func TestAppendLength(t *testing.T) {
	list := NewDoublyLinkedCircularList()
	list.Append(0)
	output := list.Length()
	expected := 1
	if output != expected {
		t.Errorf("Expected: %v, but it was: %v instead.", expected, output)
	}
}

func TestAppendZeroOneLength(t *testing.T) {
	list := NewDoublyLinkedCircularList()
	list.Append(0)
	list.Append(1)
	output := list.Length()
	expected := 2
	if output != expected {
		t.Errorf("Expected: %v, but it was: %v instead.", expected, output)
	}
}

func TestAppendZeroOneTwoRemoveTwiceLength(t *testing.T) {
	list := NewDoublyLinkedCircularList()
	list.Append(0)
	list.Append(1)
	list.Append(2)
	list.Remove()
	list.Remove()
	output := list.Length()
	expected := 1
	if output != expected {
		t.Errorf("Expected: %v, but it was: %v instead.", expected, output)
	}
}
