CXX=g++ -m64
CXXFLAGS=-I../common -Iobjs/ -O3 -std=c++11 -Wall -fPIC

APP_NAME=mandelbrot.exe
OBJDIR=objs
COMMONDIR=../common

PPM_CXX=$(COMMONDIR)/ppm.cpp
PPM_OBJ=$(OBJDIR)/ppm.o

default: $(APP_NAME)

.PHONY: dirs clean

dirs:
	@if not exist $(OBJDIR) mkdir $(OBJDIR)

clean:
	del /Q /S $(OBJDIR) *.ppm *~ $(APP_NAME)

OBJS=$(OBJDIR)/main.o $(OBJDIR)/mandelbrotSerial.o $(OBJDIR)/mandelbrotThread.o $(PPM_OBJ)

$(APP_NAME): dirs $(OBJS)
		$(CXX) $(CXXFLAGS) -o $@ $(OBJS) -lm -lpthread

$(OBJDIR)/%.o: %.cpp
		$(CXX) $< $(CXXFLAGS) -c -o $@

$(OBJDIR)/%.o: $(COMMONDIR)/%.cpp
	$(CXX) $< $(CXXFLAGS) -c -o $@

$(OBJDIR)/main.o: $(COMMONDIR)/CycleTimer.h

