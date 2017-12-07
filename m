From: "Tobin C. Harding" <me@tobin.cc>
Date: Fri,  8 Dec 2017 09:27:54 +1100
Message-Id: <1512685676-21933-2-git-send-email-me@tobin.cc>
In-Reply-To: <1512685676-21933-1-git-send-email-me@tobin.cc>
References: <1512685676-21933-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH 1/3] doc: convert printk-formats.txt to rst
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
 - Convert lib/vsnprintf.c function docs to use kernel-docs and
   include in Documentation/printk-formats.rst

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 Documentation/00-INDEX                             |   2 -
 Documentation/core-api/index.rst                   |   1 +
 .../printk-formats.rst}                            | 268 +++++++++++----------
 lib/vsprintf.c                                     | 155 +++++-------
 4 files changed, 196 insertions(+), 230 deletions(-)
 rename Documentation/{printk-formats.txt => core-api/printk-formats.rst} (59%)

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
index d5bbe035316d..2f9df634a726 100644
--- a/Documentation/core-api/index.rst
+++ b/Documentation/core-api/index.rst
@@ -21,6 +21,7 @@ Core utilities
    flexible-arrays
    librs
    genalloc
+   printk-formats
 
 Interfaces for kernel debugging
 ===============================
diff --git a/Documentation/printk-formats.txt b/Documentation/core-api/printk-formats.rst
similarity index 59%
rename from Documentation/printk-formats.txt
rename to Documentation/core-api/printk-formats.rst
index aa0a776c817a..f1262a617dec 100644
--- a/Documentation/printk-formats.txt
+++ b/Documentation/core-api/printk-formats.rst
@@ -5,6 +5,7 @@ How to get printk format specifiers right
 :Author: Randy Dunlap <rdunlap@infradead.org>
 :Author: Andrew Murray <amurray@mpc-data.co.uk>
 
+
 Integer types
 =============
 
@@ -25,39 +26,49 @@ Integer types
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
+.. kernel-doc:: lib/vsprintf.c
+     :doc: Extended Format Pointer Specifiers
+
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
 
@@ -69,22 +80,22 @@ Symbols/Function Pointers
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
 
@@ -96,34 +107,34 @@ Examples::
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
+kernel memory layout before printing pointers with %px. %px is functionally
+equivalent to %lx (or %lu). %px, however, is preferable because it is more
 uniquely grep'able. If, in the future, we need to modify the way the Kernel
-handles printing pointers it will be nice to be able to find the call
+handles printing pointers we will be better equipped to find the call
 sites.
 
-Struct Resources
-================
+Struct resources
+----------------
 
 ::
 
@@ -133,43 +144,48 @@ Struct Resources
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
 
-DMA addresses types ``dma_addr_t``
-==================================
+Passed by reference.
+
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
 
 	%*pE[achnops]
 
-For printing raw buffer as an escaped string. For the following buffer::
+For printing raw a buffer as an escaped string. For the following buffer::
 
 		1b 62 20 5c 43 07 22 90 0d 5d
 
-few examples show how the conversion would be done (the result string
-without surrounding quotes)::
+A few examples show how the conversion would be done (excluding surrounding
+quotes)::
 
 		%*pE		"\eb \C\a"\220\r]"
 		%*pEhp		"\x1bb \C\x07"\x90\x0d]"
@@ -179,23 +195,23 @@ The conversion rules are applied according to an optional combination
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
 
@@ -204,12 +220,12 @@ Raw buffer as a hex string
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
 
@@ -220,21 +236,21 @@ MAC/FDDI addresses
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
-specifier to use reversed byte order suitable for visual interpretation
-of Bluetooth addresses which are in the little endian order.
+specifier to use reversed byte order suitable for visual interpretation of
+Bluetooth addresses which are in the little endian order.
 
 Passed by reference.
 
 IPv4 addresses
-==============
+--------------
 
 ::
 
@@ -243,17 +259,18 @@ IPv4 addresses
 	%p[Ii]4[hnbl]
 
 For printing IPv4 dot-separated decimal addresses. The ``I4`` and ``i4``
-specifiers result in a printed address with (``i4``) or without (``I4``)
-leading zeros.
+specifiers result in a printed address with (i4) or without (I4) leading
+zeros.
 
-The additional ``h``, ``n``, ``b``, and ``l`` specifiers are used to specify
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
 
@@ -262,7 +279,7 @@ IPv6 addresses
 	%pI6c	1:2:3:4:5:6:7:8
 
 For printing IPv6 network-order 16-bit hex addresses. The ``I6`` and ``i6``
-specifiers result in a printed address with (``I6``) or without (``i6``)
+specifiers result in a printed address with (I6) or without (i6)
 colon-separators. Leading zeros are always used.
 
 The additional ``c`` specifier can be used with the ``I`` specifier to
@@ -272,7 +289,7 @@ http://tools.ietf.org/html/rfc5952
 Passed by reference.
 
 IPv4/IPv6 addresses (generic, with port, flowinfo, scope)
-=========================================================
+---------------------------------------------------------
 
 ::
 
@@ -282,9 +299,9 @@ IPv4/IPv6 addresses (generic, with port, flowinfo, scope)
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
@@ -309,7 +326,7 @@ Further examples::
 	%pISpfc		1.2.3.4:12345	or [1:2:3:4:5:6:7:8]:12345/123456789
 
 UUID/GUID addresses
-===================
+-------------------
 
 ::
 
@@ -318,18 +335,18 @@ UUID/GUID addresses
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
 
@@ -344,7 +361,7 @@ equivalent of ``%s`` ``dentry->d_name.name`` we used to use, ``%pd<n>`` prints
 Passed by reference.
 
 block_device names
-==================
+------------------
 
 ::
 
@@ -353,14 +370,14 @@ block_device names
 For printing name of block_device pointers.
 
 struct va_format
-================
+----------------
 
 ::
 
 	%pV
 
-For printing struct va_format structures. These contain a format string
-and va_list as follows::
+For printing struct va_format structures. These contain a format string and
+va_list as follows::
 
 	struct va_format {
 		const char *fmt;
@@ -375,31 +392,27 @@ correctness of the format string and va_list arguments.
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
+equivalent to ``%pOFf``.
 
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
@@ -412,11 +425,10 @@ kobjects
 							P - Populated
 							B - Populated bus
 
-	Passed by reference.
-
+Passed by reference.
 
 struct clk
-==========
+----------
 
 ::
 
@@ -430,8 +442,8 @@ structure; ``%pCr`` prints the current clock rate.
 
 Passed by reference.
 
-bitmap and its derivatives such as cpumask and nodemask
-=======================================================
+Bitmap and its derivatives (such as cpumask and nodemask)
+---------------------------------------------------------
 
 ::
 
@@ -439,13 +451,13 @@ bitmap and its derivatives such as cpumask and nodemask
 	%*pbl	0,3-6,8-10
 
 For printing bitmap and its derivatives such as cpumask and nodemask,
-``%*pb`` output the bitmap with field width as the number of bits and ``%*pbl``
-output the bitmap as range list with field width as the number of bits.
+``%*pb`` outputs the bitmap with field width as the number of bits and ``%*pbl``
+outputs the bitmap as range list with field width as the number of bits.
 
 Passed by reference.
 
-Flags bitfields such as page flags, gfp_flags
-=============================================
+Flags bitfields (such as page flags, gfp_flags)
+-----------------------------------------------
 
 ::
 
@@ -459,14 +471,14 @@ character. Currently supported are [p]age flags, [v]ma_flags (both
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
 
@@ -476,8 +488,10 @@ For printing netdev_features_t.
 
 Passed by reference.
 
+Thanks
+======
+
 If you add other ``%p`` extensions, please extend lib/test_printf.c with
 one or more test cases, if at all feasible.
 
-
 Thank you for your cooperation and attention.
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 01c3957b2de6..e9538ed3d8b2 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1727,115 +1727,68 @@ static char *ptr_to_id(char *buf, char *end, void *ptr, struct printf_spec spec)
 	return number(buf, end, hashval, spec);
 }
 
+/**
+ * DOC: Extended Format Pointer Specifiers
+ *
+ * Briefly we handle the following extensions:
+ *
+ * - F - For symbolic function descriptor pointers with offset.
+ * - f - For simple symbolic function names without offset.
+ * - S - For symbolic direct pointers with offset.
+ * - s - For symbolic direct pointers without offset.
+ * - [FfSs]R - As above with __builtin_extract_return_addr() translation.
+ * - B - For backtraced symbolic direct pointers with offset.
+ * - R - For decoded struct resource, e.g., [mem 0x0-0x1f 64bit pref].
+ * - r - For raw struct resource, e.g., [mem 0x0-0x1f flags 0x201].
+ * - b[l] - For a bitmap, the number of bits is determined by the field width
+ *   which must be explicitly specified either as part of the format string
+ *   32b[l] or through *b[l], [l] selects range-list format instead of hex format.
+ * - M - For a 6-byte MAC address, it prints the address in the usual
+ *   colon-separated hex notation.
+ * - m - For a 6-byte MAC address, it prints the hex address without colons.
+ * - MF - For a 6-byte MAC FDDI address, it prints the address with a
+ *   dash-separated hex notation.
+ * - [mM]R - For a 6-byte MAC address, Reverse order (Bluetooth).
+ * - I[46] - For IPv4/IPv6 addresses printed in the usual way.
+ * - I[S][pfs] - For generic IPv4/IPv6 address (struct sockaddr *) that falls
+ *   back to [4] or [6] and is able to print port [p], flowinfo [f], scope [s].
+ * - i[46] - For 'raw' IPv4/IPv6 addresses IPv6 omits the colons (01020304...0f)
+ *   IPv4 uses dot-separated decimal with leading 0's (010.123.045.006).
+ * - i[S][pfs] - For generic IPv4/IPv6 address (struct sockaddr *) that falls back
+ *   to [4] or [6] ([pfs] as above).
+ * - [Ii][4S][hnbl] - For IPv4 addresses in host, network, big or little endian order.
+ * - I[6S]c - For IPv6 addresses printed as per http://tools.ietf.org/html/rfc5952.
+ * - E[achnops] - For an escaped buffer.
+ * - U - For a 16 byte UUID/GUID.
+ * - V - For a struct va_format which contains a format ``string *`` and ``va_list *``.
+ * - K -  For a kernel pointer that should be hidden from unprivileged users.
+ * - NF - For a netdev_features_t.
+ * - h[CDN] - For a variable-length buffer.
+ * - a[pd] - For address types [p] phys_addr_t, [d] dma_addr_t and derivatives.
+ * - d[234] - For a dentry name (optionally 2-4 last components).
+ * - D[234] - Same as 'd' but for a struct file.
+ * - g - For block_device name (gendisk + partition number).
+ * - C[n] - For a clock, it prints the name (Common Clock Framework) or
+ *   address (legacy clock framework) of the clock. [n] is optional.
+ * - Cr - For a clock, it prints the current rate of the clock.
+ * - G - For flags to be printed as a collection of symbolic strings that
+ *   would construct the specific value.
+ * - O - For a kobject based struct (device node).
+ * - x - For printing the address.
+ */
+
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
  * by an extra set of alphanumeric characters that are extended format
  * specifiers.
  *
+ * Please see Documentation/printk-formats.rst for fuller description
+ * of specifier extensions. Also please update that file when making
+ * changes if necessary.
+ *
  * Please update scripts/checkpatch.pl when adding/removing conversion
  * characters.  (Search for "check for vsprintf extension").
  *
- * Right now we handle:
- *
- * - 'F' For symbolic function descriptor pointers with offset
- * - 'f' For simple symbolic function names without offset
- * - 'S' For symbolic direct pointers with offset
- * - 's' For symbolic direct pointers without offset
- * - '[FfSs]R' as above with __builtin_extract_return_addr() translation
- * - 'B' For backtraced symbolic direct pointers with offset
- * - 'R' For decoded struct resource, e.g., [mem 0x0-0x1f 64bit pref]
- * - 'r' For raw struct resource, e.g., [mem 0x0-0x1f flags 0x201]
- * - 'b[l]' For a bitmap, the number of bits is determined by the field
- *       width which must be explicitly specified either as part of the
- *       format string '%32b[l]' or through '%*b[l]', [l] selects
- *       range-list format instead of hex format
- * - 'M' For a 6-byte MAC address, it prints the address in the
- *       usual colon-separated hex notation
- * - 'm' For a 6-byte MAC address, it prints the hex address without colons
- * - 'MF' For a 6-byte MAC FDDI address, it prints the address
- *       with a dash-separated hex notation
- * - '[mM]R' For a 6-byte MAC address, Reverse order (Bluetooth)
- * - 'I' [46] for IPv4/IPv6 addresses printed in the usual way
- *       IPv4 uses dot-separated decimal without leading 0's (1.2.3.4)
- *       IPv6 uses colon separated network-order 16 bit hex with leading 0's
- *       [S][pfs]
- *       Generic IPv4/IPv6 address (struct sockaddr *) that falls back to
- *       [4] or [6] and is able to print port [p], flowinfo [f], scope [s]
- * - 'i' [46] for 'raw' IPv4/IPv6 addresses
- *       IPv6 omits the colons (01020304...0f)
- *       IPv4 uses dot-separated decimal with leading 0's (010.123.045.006)
- *       [S][pfs]
- *       Generic IPv4/IPv6 address (struct sockaddr *) that falls back to
- *       [4] or [6] and is able to print port [p], flowinfo [f], scope [s]
- * - '[Ii][4S][hnbl]' IPv4 addresses in host, network, big or little endian order
- * - 'I[6S]c' for IPv6 addresses printed as specified by
- *       http://tools.ietf.org/html/rfc5952
- * - 'E[achnops]' For an escaped buffer, where rules are defined by combination
- *                of the following flags (see string_escape_mem() for the
- *                details):
- *                  a - ESCAPE_ANY
- *                  c - ESCAPE_SPECIAL
- *                  h - ESCAPE_HEX
- *                  n - ESCAPE_NULL
- *                  o - ESCAPE_OCTAL
- *                  p - ESCAPE_NP
- *                  s - ESCAPE_SPACE
- *                By default ESCAPE_ANY_NP is used.
- * - 'U' For a 16 byte UUID/GUID, it prints the UUID/GUID in the form
- *       "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
- *       Options for %pU are:
- *         b big endian lower case hex (default)
- *         B big endian UPPER case hex
- *         l little endian lower case hex
- *         L little endian UPPER case hex
- *           big endian output byte order is:
- *             [0][1][2][3]-[4][5]-[6][7]-[8][9]-[10][11][12][13][14][15]
- *           little endian output byte order is:
- *             [3][2][1][0]-[5][4]-[7][6]-[8][9]-[10][11][12][13][14][15]
- * - 'V' For a struct va_format which contains a format string * and va_list *,
- *       call vsnprintf(->format, *->va_list).
- *       Implements a "recursive vsnprintf".
- *       Do not use this feature without some mechanism to verify the
- *       correctness of the format string and va_list arguments.
- * - 'K' For a kernel pointer that should be hidden from unprivileged users
- * - 'NF' For a netdev_features_t
- * - 'h[CDN]' For a variable-length buffer, it prints it as a hex string with
- *            a certain separator (' ' by default):
- *              C colon
- *              D dash
- *              N no separator
- *            The maximum supported length is 64 bytes of the input. Consider
- *            to use print_hex_dump() for the larger input.
- * - 'a[pd]' For address types [p] phys_addr_t, [d] dma_addr_t and derivatives
- *           (default assumed to be phys_addr_t, passed by reference)
- * - 'd[234]' For a dentry name (optionally 2-4 last components)
- * - 'D[234]' Same as 'd' but for a struct file
- * - 'g' For block_device name (gendisk + partition number)
- * - 'C' For a clock, it prints the name (Common Clock Framework) or address
- *       (legacy clock framework) of the clock
- * - 'Cn' For a clock, it prints the name (Common Clock Framework) or address
- *        (legacy clock framework) of the clock
- * - 'Cr' For a clock, it prints the current rate of the clock
- * - 'G' For flags to be printed as a collection of symbolic strings that would
- *       construct the specific value. Supported flags given by option:
- *       p page flags (see struct page) given as pointer to unsigned long
- *       g gfp flags (GFP_* and __GFP_*) given as pointer to gfp_t
- *       v vma flags (VM_*) given as pointer to unsigned long
- * - 'O' For a kobject based struct. Must be one of the following:
- *       - 'OF[fnpPcCF]'  For a device tree object
- *                        Without any optional arguments prints the full_name
- *                        f device node full_name
- *                        n device node name
- *                        p device node phandle
- *                        P device node path spec (name + @unit)
- *                        F device node flags
- *                        c major compatible string
- *                        C full compatible string
- *
- * - 'x' For printing the address. Equivalent to "%lx".
- *
- * ** Please update also Documentation/printk-formats.txt when making changes **
- *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
  * pointer to the real address.
-- 
2.7.4
