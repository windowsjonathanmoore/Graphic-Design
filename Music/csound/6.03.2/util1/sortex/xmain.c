/*
    xmain.c

    Copyright (C) 1991 Barry Vercoe, John ffitch

    This file is part of Csound.

    The Csound Library is free software; you can redistribute it
    and/or modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    Csound is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with Csound; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
    02111-1307 USA
*/

#include "csound.h"                                /*   XMAIN.C  */

#if defined(LINUX) || defined(SGI) || defined(sol) || \
    defined(__MACH__) || defined(__EMX__)
#include <signal.h>
#endif

int main(int ac, char **av)         /* stdio stub for standalone extract */
{                                   /*     first opens the control xfile */
    CSOUND  *csound;
    FILE    *xfp;
    int     err = 1;

    csound = csoundCreate(NULL);
#if defined(LINUX) || defined(SGI) || defined(sol) || \
    defined(__MACH__) || defined(__EMX__)
    signal(SIGPIPE, SIG_DFL);
#endif
    if (ac != 2) {
      fprintf(stderr, "usage: extract xfile <in >out\n");
      goto err_return;
    }
    if ((xfp = fopen(av[1], "r")) == NULL) {
      fprintf(stderr, "extract: can't open %s\n", av[1]);
      goto err_return;
    }
    err = csoundScoreExtract(csound, stdin, stdout, xfp);
    fclose(xfp);
 err_return:
    csoundDestroy(csound);

    return err;
}

