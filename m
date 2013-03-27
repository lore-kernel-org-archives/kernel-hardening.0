Reply-To: kernel-hardening@lists.openwall.com
From: Russ Allbery <rra@stanford.edu>
In-Reply-To: <51534E5C.8070303@linux.vnet.ibm.com> (Corey Bryant's message of
	"Wed, 27 Mar 2013 15:54:04 -0400")
References: <51534E5C.8070303@linux.vnet.ibm.com>
Date: Wed, 27 Mar 2013 13:31:35 -0700
Message-ID: <877gkswpnc.fsf@windlord.stanford.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: [kernel-hardening] Re: [oss-security] Security vulnerability tools
To: oss-security@lists.openwall.com
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Corey Bryant <coreyb@linux.vnet.ibm.com> writes:

> Clang
> -----
> Static analysis tool for C/C++

Clang is, properly speaking, a compiler.  It happens to also have a static
analyzer available as part of the same code base.

If you're going to mention Clang, it's probably also pointing out that
good old GCC has very extensive warning flags that can, among other
things, find possible security vulnerabilities by locating variables that
are used before being set, dangerous printf formats, mismatches between
printf formats and arguments, and so forth.  For example, I currently use:

WARNINGS = -g -O -D_FORTIFY_SOURCE=2 -Wall -Wextra -Wendif-labels           \
        -Wformat=2 -Winit-self -Wswitch-enum -Wdeclaration-after-statement  \
        -Wshadow -Wpointer-arith -Wbad-function-cast -Wcast-align           \
        -Wwrite-strings -Wjump-misses-init -Wlogical-op                     \
        -Wstrict-prototypes -Wmissing-prototypes -Wredundant-decls          \
        -Wnested-externs -Werror

with GCC (4.6 or later) with all of my software.  Many of those are not
security-related, of course, but -Wformat=2 certainly is, and some of the
-Wall and -Wextra warnings are as well.

-- 
Russ Allbery (rra@stanford.edu)             <http://www.eyrie.org/~eagle/>
