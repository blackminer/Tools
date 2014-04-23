.PHONY: all clean

# Requires libusb-dev libusb-1.0.0-dev libudev-dev

OUTPUT = \
	readserial writeserial ping version coremap hfupdate createupdate \
	enterloader readdb thermistor hfudump readdbstream hfterm hcm \
	hfsetfans

GCC = gcc

all: $(OUTPUT)

INCLUDE_DIRS = /usr/include/libusb-1.0 /usr/local/include/libusb-1.0
EXTRA_LINKER = -L/usr/local/lib

CFLAGS = -g -c -Wall
CCOPTS = $(CFLAGS)
CCOPTS += $(foreach INC,$(INCLUDE_DIRS),-I$(INC))

LIBS = -ludev -lpthread -lusb-1.0 -lm

LINKABLE_SOURCES = \
	board_util.c \
	crc.c

C_SOURCES = \
	enterloader.c \
	ping.c \
	readserial.c \
	writeserial.c \
	coremap.c \
	createupdate.c \
	hfupdate.c \
	readdb.c \
	readdbstream.c \
	version.c \
	thermistor.c \
	hfudump.c \
	hfterm.c \
	hcm.c \
	hfsetfans.c

OBJS = $(C_SOURCES:%.c=%.o)

DEPS = $(C_SOURCES:%.c=%.d)

LINKABLE_OBJS = $(LINKABLE_SOURCES:%.c=%.o)

LINKABLE_DEPS = $(LINKABLE_SOURCES:%.c=%.d)

$(LINKABLE_OBJS): %.o: %.c
	$(GCC) $(CCOPTS) -o $@ $<

$(OBJS): %.o: %.c
	$(GCC) $(CCOPTS) -o $@ $<

%: %.o $(LINKABLE_OBJS)
	$(GCC) $(EXTRA_LINKER) -o $@ $< $(LINKABLE_OBJS) $(LIBS)

clean:
	-$(RM) $(OBJS) $(LINKABLE_OBJS) $(OUTPUT)
	-$(RM) *~

