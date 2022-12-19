SRCDIR    = ../src
OBJDIR    = obj
VPROC_TOP = ../../VProc

ARCHFLAG  = -m32

C_FILES   = codec.c mem.c pcie.c pcie_utils.c pcicrc32.c ltssm.c veriuser.c
CFLAGS    = -c -fPIC ${ARCHFLAG} -I${MODEL_TECH}/../include -I ${VPROC_TOP}/code -DMODELSIM -DLTSSM_ABBREVIATED 

CC        = gcc

LIB       = libpcievhost.a

OBJS      = ${addprefix ${OBJDIR}/, ${C_FILES:%.c=%.o}}

${OBJDIR}/%.o: ${SRCDIR}/%.c
	@${CC} ${CFLAGS} $< -o $@

all: ${LIB}

${LIB} : ${OBJS}
	@ar cr ${LIB} ${OBJS}

${OBJS}: | ${OBJDIR}

${OBJDIR}:
	@mkdir ${OBJDIR}


clean:
	@rm -rf ${LIB} ${OBJS}
