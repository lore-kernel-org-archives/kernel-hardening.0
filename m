From: "Tobin C. Harding" <me@tobin.cc>
Date: Mon, 18 Dec 2017 09:30:05 +1100
Message-Id: <1513549807-20287-2-git-send-email-me@tobin.cc>
In-Reply-To: <1513549807-20287-1-git-send-email-me@tobin.cc>
References: <1513549807-20287-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH v2 1/3] doc: convert printk-formats.txt to rst
To: Jonathan Corbet <corbet@lwn.net>
Cc: "Tobin C. Harding" <me@tobin.cc>, Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Alexander Popov <alex.popov@linux.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Documentation/printk-formats.txt is a candidate for conversion to
ReStructuredText format. Some effort has already been made to do this
conversion even thought the suffix is currently .txt

Changes required to complete conversion

 - Move printk-formats.txt to core-api/printk-formats.rst
 - Add entry to Documentation/core-api/index.rst
 - Remove entry from Documentation/00-INDEX
 - Fix minor grammatical errors.
 - Order heading adornments as suggested by rst docs.
 - Use 'Passed by reference' uniformly.
 - Update pointer documentation around %px specifier.
 - Fix erroneous double backticks (to commas).
 - Simplify documentation for kobject.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 Documentation/00-INDEX                             |   2 -
 Documentation/core-api/index.rst                   |   1 +
 .../printk-formats.rst}                            | 271 +++++++++++----------
 3 files changed, 141 insertions(+), 133 deletions(-)
 rename Documentation/{printk-formats.txt => core-api/printk-formats.rst} (57%)

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 3bec49c33bbb..7023bfaec21c 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -346,8 +346,6 @@ prctl/
 	- directory with info on the priveledge control subsystem
 preempt-locking.txt
 	- info on locking under a preemptive kernel.
-printk-formats.txt
-	- how to get printk format specifiers right
 process/
 	- how to work with the mainline kernel development process.
 pps/
diff --git a/Documentation/core-api/index.rst b/Documentation/core-api/index.rst
index d4d54b05d6c5..d55ee6b006ed 100644
--- a/Documentation/core-api/index.rst
+++ b/Documentation/core-api/index.rst
@@ -22,6 +22,7 @@ Core utilities
    flexible-arrays
    librs
    genalloc
+   printk-formats
 
 Interfaces for kernel debugging
 ===============================
diff --git a/Documentation/printk-formats.txt b/Documentation/core-api/printk-formats.rst
similarity index 57%
rename from Documentation/printk-formats.txt
rename to Documentation/core-api/printk-formats.rst
index aa0a776c817a..cf266992261e 100644
--- a/Documentation/printk-formats.txt
+++ b/Documentation/core-api/printk-formats.rst
@@ -5,6 +5,7 @@ How to get printk format specifiers right
 :Author: Randy Dunlap <rdunlap@infradead.org>
 :Author: Andrew Murray <amurray@mpc-data.co.uk>
 
+
 Integer types
 =============
 
@@ -25,39 +26,45 @@ Integer types
 		s64			%lld or %llx
 		u64			%llu or %llx
 
-If <type> is dependent on a config option for its size (e.g., ``sector_t``,
-``blkcnt_t``) or is architecture-dependent for its size (e.g., ``tcflag_t``),
-use a format specifier of its largest possible type and explicitly cast to it.
+
+If <type> is dependent on a config option for its size (e.g., sector_t,
+blkcnt_t) or is architecture-dependent for its size (e.g., tcflag_t), use a
+format specifier of its largest possible type and explicitly cast to it.
 
 Example::
 
 	printk("test: sector number/total blocks: %llu/%llu\n",
 		(unsigned long long)sector, (unsigned long long)blockcount);
 
-Reminder: ``sizeof()`` result is of type ``size_t``.
+Reminder: sizeof() returns type size_t.
 
-The kernel's printf does not support ``%n``. For obvious reasons, floating
-point formats (``%e, %f, %g, %a``) are also not recognized. Use of any
+The kernel's printf does not support %n. Floating point formats (%e, %f,
+%g, %a) are also not recognized, for obvious reasons. Use of any
 unsupported specifier or length qualifier results in a WARN and early
-return from vsnprintf.
-
-Raw pointer value SHOULD be printed with %p. The kernel supports
-the following extended format specifiers for pointer types:
+return from vsnprintf().
 
-Pointer Types
+Pointer types
 =============
 
-Pointers printed without a specifier extension (i.e unadorned %p) are
-hashed to give a unique identifier without leaking kernel addresses to user
-space. On 64 bit machines the first 32 bits are zeroed. If you _really_
-want the address see %px below.
+A raw pointer value may be printed with %p which will hash the address
+before printing. The Kernel also supports extended specifiers for printing
+pointers of different types.
+
+Plain pointers
+--------------
 
 ::
 
 	%p	abcdef12 or 00000000abcdef12
 
-Symbols/Function Pointers
-=========================
+Pointers printed without a specifier extension (i.e unadorned %p) are
+hashed to prevent leaking information about the kernel memory layout. This
+has the added benefit of providing a unique identifier. On 64-bit machines
+the first 32 bits are zeroed. If you *really* want the address see %px
+below.
+
+Symbols/Function pointers
+-------------------------
 
 ::
 
@@ -69,22 +76,22 @@ Symbols/Function Pointers
 	%ps	versatile_init
 	%pB	prev_fn_of_versatile_init+0x88/0x88
 
-The ``F`` and ``f`` specifiers are for printing function pointers,
-for example, f->func, &gettimeofday. They have the same result as
-``S`` and ``s`` specifiers. But they do an extra conversion on
-ia64, ppc64 and parisc64 architectures where the function pointers
-are actually function descriptors.
 
-The ``S`` and ``s`` specifiers can be used for printing symbols
-from direct addresses, for example, __builtin_return_address(0),
-(void *)regs->ip. They result in the symbol name with (``S``) or
-without (``s``) offsets. If KALLSYMS are disabled then the symbol
-address is printed instead.
+The ``F`` and ``f`` specifiers are for printing function pointers, for
+example, f->func, &gettimeofday. They have the same result as ``S`` and
+``s`` specifiers. But they do an extra conversion on ia64, ppc64 and
+parisc64 architectures where the function pointers are actually function
+descriptors.
+
+The ``S`` and ``s`` specifiers can be used for printing symbols from direct
+addresses, for example, __builtin_return_address(0), (void *)regs->ip. They
+result in the symbol name with (S) or without (s) offsets. If KALLSYMS are
+disabled then the symbol address is printed instead.
 
 The ``B`` specifier results in the symbol name with offsets and should be
-used when printing stack backtraces. The specifier takes into
-consideration the effect of compiler optimisations which may occur
-when tail-call``s are used and marked with the noreturn GCC attribute.
+used when printing stack backtraces. The specifier takes into consideration
+the effect of compiler optimisations which may occur when tail-call's are
+used and marked with the noreturn GCC attribute.
 
 Examples::
 
@@ -96,34 +103,33 @@ Examples::
 	printk("Faulted at %pS\n", (void *)regs->ip);
 	printk(" %s%pB\n", (reliable ? "" : "? "), (void *)*stack);
 
-Kernel Pointers
-===============
+Kernel pointers
+---------------
 
 ::
 
 	%pK	01234567 or 0123456789abcdef
 
 For printing kernel pointers which should be hidden from unprivileged
-users. The behaviour of ``%pK`` depends on the ``kptr_restrict sysctl`` - see
+users. The behaviour of %pK depends on the kptr_restrict sysctl - see
 Documentation/sysctl/kernel.txt for more details.
 
-Unmodified Addresses
-====================
+Unmodified addresses
+--------------------
 
 ::
 
 	%px	01234567 or 0123456789abcdef
 
-For printing pointers when you _really_ want to print the address. Please
+For printing pointers when you *really* want to print the address. Please
 consider whether or not you are leaking sensitive information about the
-Kernel layout in memory before printing pointers with %px. %px is
-functionally equivalent to %lx. %px is preferred to %lx because it is more
-uniquely grep'able. If, in the future, we need to modify the way the Kernel
-handles printing pointers it will be nice to be able to find the call
-sites.
+kernel memory layout before printing pointers with %px. %px is functionally
+equivalent to %lx (or %lu). %px is preferred because it is more uniquely
+grep'able. If in the future we need to modify the way the Kernel handles
+printing pointers we will be better equipped to find the call sites.
 
-Struct Resources
-================
+Struct resources
+----------------
 
 ::
 
@@ -133,32 +139,37 @@ Struct Resources
 		[mem 0x0000000060000000-0x000000006fffffff pref]
 
 For printing struct resources. The ``R`` and ``r`` specifiers result in a
-printed resource with (``R``) or without (``r``) a decoded flags member.
+printed resource with (R) or without (r) a decoded flags member.
+
 Passed by reference.
 
-Physical addresses types ``phys_addr_t``
-========================================
+Physical address types phys_addr_t
+----------------------------------
 
 ::
 
 	%pa[p]	0x01234567 or 0x0123456789abcdef
 
-For printing a ``phys_addr_t`` type (and its derivatives, such as
-``resource_size_t``) which can vary based on build options, regardless of
-the width of the CPU data path. Passed by reference.
+For printing a phys_addr_t type (and its derivatives, such as
+resource_size_t) which can vary based on build options, regardless of the
+width of the CPU data path.
+
+Passed by reference.
 
-DMA addresses types ``dma_addr_t``
-==================================
+DMA address types dma_addr_t
+----------------------------
 
 ::
 
 	%pad	0x01234567 or 0x0123456789abcdef
 
-For printing a ``dma_addr_t`` type which can vary based on build options,
-regardless of the width of the CPU data path. Passed by reference.
+For printing a dma_addr_t type which can vary based on build options,
+regardless of the width of the CPU data path.
+
+Passed by reference.
 
 Raw buffer as an escaped string
-===============================
+-------------------------------
 
 ::
 
@@ -168,8 +179,8 @@ For printing raw buffer as an escaped string. For the following buffer::
 
 		1b 62 20 5c 43 07 22 90 0d 5d
 
-few examples show how the conversion would be done (the result string
-without surrounding quotes)::
+A few examples show how the conversion would be done (excluding surrounding
+quotes)::
 
 		%*pE		"\eb \C\a"\220\r]"
 		%*pEhp		"\x1bb \C\x07"\x90\x0d]"
@@ -179,23 +190,23 @@ The conversion rules are applied according to an optional combination
 of flags (see :c:func:`string_escape_mem` kernel documentation for the
 details):
 
-	- ``a`` - ESCAPE_ANY
-	- ``c`` - ESCAPE_SPECIAL
-	- ``h`` - ESCAPE_HEX
-	- ``n`` - ESCAPE_NULL
-	- ``o`` - ESCAPE_OCTAL
-	- ``p`` - ESCAPE_NP
-	- ``s`` - ESCAPE_SPACE
+	- a - ESCAPE_ANY
+	- c - ESCAPE_SPECIAL
+	- h - ESCAPE_HEX
+	- n - ESCAPE_NULL
+	- o - ESCAPE_OCTAL
+	- p - ESCAPE_NP
+	- s - ESCAPE_SPACE
 
 By default ESCAPE_ANY_NP is used.
 
 ESCAPE_ANY_NP is the sane choice for many cases, in particularly for
 printing SSIDs.
 
-If field width is omitted the 1 byte only will be escaped.
+If field width is omitted then 1 byte only will be escaped.
 
 Raw buffer as a hex string
-==========================
+--------------------------
 
 ::
 
@@ -204,12 +215,12 @@ Raw buffer as a hex string
 	%*phD	00-01-02- ... -3f
 	%*phN	000102 ... 3f
 
-For printing a small buffers (up to 64 bytes long) as a hex string with
-certain separator. For the larger buffers consider to use
+For printing small buffers (up to 64 bytes long) as a hex string with a
+certain separator. For larger buffers consider using
 :c:func:`print_hex_dump`.
 
 MAC/FDDI addresses
-==================
+------------------
 
 ::
 
@@ -220,11 +231,11 @@ MAC/FDDI addresses
 	%pmR	050403020100
 
 For printing 6-byte MAC/FDDI addresses in hex notation. The ``M`` and ``m``
-specifiers result in a printed address with (``M``) or without (``m``) byte
-separators. The default byte separator is the colon (``:``).
+specifiers result in a printed address with (M) or without (m) byte
+separators. The default byte separator is the colon (:).
 
 Where FDDI addresses are concerned the ``F`` specifier can be used after
-the ``M`` specifier to use dash (``-``) separators instead of the default
+the ``M`` specifier to use dash (-) separators instead of the default
 separator.
 
 For Bluetooth addresses the ``R`` specifier shall be used after the ``M``
@@ -234,7 +245,7 @@ of Bluetooth addresses which are in the little endian order.
 Passed by reference.
 
 IPv4 addresses
-==============
+--------------
 
 ::
 
@@ -243,19 +254,20 @@ IPv4 addresses
 	%p[Ii]4[hnbl]
 
 For printing IPv4 dot-separated decimal addresses. The ``I4`` and ``i4``
-specifiers result in a printed address with (``i4``) or without (``I4``)
-leading zeros.
+specifiers result in a printed address with (i4) or without (I4) leading
+zeros.
 
-The additional ``h``, ``n``, ``b``, and ``l`` specifiers are used to
 specify
 
-host, network, big or little endian order addresses respectively. Where
-no specifier is provided the default network/big endian order is used.
+The additional ``h``, ``n``, ``b``, and ``l`` specifiers are used to
+specify host, network, big or little endian order addresses
+respectively. Where no specifier is provided the default network/big endian
+order is used.
 
 Passed by reference.
 
 IPv6 addresses
-==============
+--------------
 
 ::
 
@@ -262,7 +274,7 @@ IPv6 addresses
 	%pI6c	1:2:3:4:5:6:7:8
 
 For printing IPv6 network-order 16-bit hex addresses. The ``I6`` and ``i6``
-specifiers result in a printed address with (``I6``) or without (``i6``)
+specifiers result in a printed address with (I6) or without (i6)
 colon-separators. Leading zeros are always used.
 
 The additional ``c`` specifier can be used with the ``I`` specifier to
@@ -272,7 +284,7 @@ http://tools.ietf.org/html/rfc5952
 Passed by reference.
 
 IPv4/IPv6 addresses (generic, with port, flowinfo, scope)
-=========================================================
+---------------------------------------------------------
 
 ::
 
@@ -282,9 +294,9 @@ IPv4/IPv6 addresses (generic, with port, flowinfo, scope)
 	%pISpc	1.2.3.4:12345	or [1:2:3:4:5:6:7:8]:12345
 	%p[Ii]S[pfschnbl]
 
-For printing an IP address without the need to distinguish whether it``s
-of type AF_INET or AF_INET6, a pointer to a valid ``struct sockaddr``,
-specified through ``IS`` or ``iS``, can be passed to this format specifier.
+For printing an IP address without the need to distinguish whether it's of
+type AF_INET or AF_INET6. A pointer to a valid struct sockaddr, specified
+through ``IS`` or ``iS``, can be passed to this format specifier.
 
 The additional ``p``, ``f``, and ``s`` specifiers are used to specify port
 (IPv4, IPv6), flowinfo (IPv6) and scope (IPv6). Ports have a ``:`` prefix,
@@ -309,7 +321,7 @@ Further examples::
 	%pISpfc		1.2.3.4:12345	or [1:2:3:4:5:6:7:8]:12345/123456789
 
 UUID/GUID addresses
-===================
+-------------------
 
 ::
 
@@ -318,33 +330,33 @@ UUID/GUID addresses
 	%pUl	03020100-0504-0706-0809-0a0b0c0e0e0f
 	%pUL	03020100-0504-0706-0809-0A0B0C0E0E0F
 
-For printing 16-byte UUID/GUIDs addresses. The additional 'l', 'L',
-'b' and 'B' specifiers are used to specify a little endian order in
-lower ('l') or upper case ('L') hex characters - and big endian order
-in lower ('b') or upper case ('B') hex characters.
+For printing 16-byte UUID/GUIDs addresses. The additional ``l``, ``L``,
+``b`` and ``B`` specifiers are used to specify a little endian order in
+lower (l) or upper case (L) hex notation - and big endian order in lower (b)
+or upper case (B) hex notation.
 
 Where no additional specifiers are used the default big endian
-order with lower case hex characters will be printed.
+order with lower case hex notation will be printed.
 
 Passed by reference.
 
-dentry names
-============
+Dentry names
+------------
 
 ::
 
 	%pd{,2,3,4}
 	%pD{,2,3,4}
 
-For printing dentry name; if we race with :c:func:`d_move`, the name might be
-a mix of old and new ones, but it won't oops.  ``%pd`` dentry is a safer
-equivalent of ``%s`` ``dentry->d_name.name`` we used to use, ``%pd<n>`` prints
-``n`` last components.  ``%pD`` does the same thing for struct file.
+For printing dentry name; if we race with :c:func:`d_move`, the name might
+be a mix of old and new ones, but it won't oops.  %pd dentry is a safer
+equivalent of %s dentry->d_name.name we used to use, %pd<n> prints ``n``
+last components.  %pD does the same thing for struct file.
 
 Passed by reference.
 
 block_device names
-==================
+------------------
 
 ::
 
@@ -353,7 +365,7 @@ block_device names
 For printing name of block_device pointers.
 
 struct va_format
-================
+----------------
 
 ::
 
@@ -375,31 +387,27 @@ correctness of the format string and va_list arguments.
 Passed by reference.
 
 kobjects
-========
+--------
 
 ::
 
-	%pO
+	%pOF[fnpPcCF]
 
-	Base specifier for kobject based structs. Must be followed with
-	character for specific type of kobject as listed below:
 
-	Device tree nodes:
+For printing kobject based structs (device nodes). Default behaviour is
+equivalent to %pOFf.
 
-	%pOF[fnpPcCF]
+	- f - device node full_name
+	- n - device node name
+	- p - device node phandle
+	- P - device node path spec (name + @unit)
+	- F - device node flags
+	- c - major compatible string
+	- C - full compatible string
 
-	For printing device tree nodes. The optional arguments are:
-	    f device node full_name
-	    n device node name
-	    p device node phandle
-	    P device node path spec (name + @unit)
-	    F device node flags
-	    c major compatible string
-	    C full compatible string
-	Without any arguments prints full_name (same as %pOFf)
-	The separator when using multiple arguments is ':'
+The separator when using multiple arguments is ':'
 
-	Examples:
+Examples::
 
 	%pOF	/foo/bar@0			- Node full name
 	%pOFf	/foo/bar@0			- Same as above
@@ -412,11 +420,10 @@ kobjects
 							P - Populated
 							B - Populated bus
 
-	Passed by reference.
-
+Passed by reference.
 
 struct clk
-==========
+----------
 
 ::
 
@@ -424,28 +431,28 @@ struct clk
 	%pCn	pll1
 	%pCr	1560000000
 
-For printing struct clk structures. ``%pC`` and ``%pCn`` print the name
+For printing struct clk structures. %pC and %pCn print the name
 (Common Clock Framework) or address (legacy clock framework) of the
-structure; ``%pCr`` prints the current clock rate.
+structure; %pCr prints the current clock rate.
 
 Passed by reference.
 
-bitmap and its derivatives such as cpumask and nodemask
-=======================================================
+Bitmap and its derivatives such as cpumask and nodemask
+-------------------------------------------------------
 
 ::
 
 	%*pb	0779
 	%*pbl	0,3-6,8-10
 
-For printing bitmap and its derivatives such as cpumask and nodemask,
-``%*pb`` output the bitmap with field width as the number of bits and ``%*pbl``
-output the bitmap as range list with field width as the number of bits.
+For printing bitmap and its derivatives such as cpumask and nodemask, %*pb
+outputs the bitmap with field width as the number of bits and %*pbl outputs
+the bitmap as range list with field width as the number of bits.
 
 Passed by reference.
 
 Flags bitfields such as page flags, gfp_flags
-=============================================
+---------------------------------------------
 
 ::
 
@@ -459,14 +466,14 @@ character. Currently supported are [p]age flags, [v]ma_flags (both
 expect ``unsigned long *``) and [g]fp_flags (expects ``gfp_t *``). The flag
 names and print order depends on the particular	type.
 
-Note that this format should not be used directly in :c:func:`TP_printk()` part
-of a tracepoint. Instead, use the ``show_*_flags()`` functions from
-<trace/events/mmflags.h>.
+Note that this format should not be used directly in the
+:c:func:`TP_printk()` part of a tracepoint. Instead, use the show_*_flags()
+functions from <trace/events/mmflags.h>.
 
 Passed by reference.
 
 Network device features
-=======================
+-----------------------
 
 ::
 
@@ -476,8 +483,10 @@ For printing netdev_features_t.
 
 Passed by reference.
 
-If you add other ``%p`` extensions, please extend lib/test_printf.c with
-one or more test cases, if at all feasible.
+Thanks
+======
 
+If you add other %p extensions, please extend <lib/test_printf.c> with
+one or more test cases, if at all feasible.
 
 Thank you for your cooperation and attention.
-- 
2.7.4
