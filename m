Date: Fri, 7 Apr 2017 01:20:19 +0800
From: kbuild test robot <lkp@intel.com>
Message-ID: <201704070133.TVMZxWQ6%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <20170406033550.32525-3-ewk@edkovsky.org>
Subject: [kernel-hardening] Re: [PATCH v5 2/2] extable: verify address is read-only
To: Eddie Kovsky <ewk@edkovsky.org>
Cc: kbuild-all@01.org, jeyu@redhat.com, rusty@rustcorp.com.au, keescook@chromium.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Eddie,

[auto build test WARNING on next-20170330]
[cannot apply to linus/master linux/master jeyu/modules-next v4.9-rc8 v4.9-rc7 v4.9-rc6 v4.11-rc5]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Eddie-Kovsky/module-verify-address-is-read-only/20170407-004322
config: i386-randconfig-x014-201714 (attached as .config)
compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All warnings (new ones prefixed by >>):

   In file included from include/linux/trace_clock.h:12:0,
                    from include/linux/ftrace.h:9,
                    from kernel/extable.c:18:
   kernel/extable.c: In function 'core_kernel_rodata':
   kernel/extable.c:169:29: error: '__start_ro_after_init' undeclared (first use in this function)
     if (addr >= (unsigned long)__start_ro_after_init &&
                                ^
   include/linux/compiler.h:160:30: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                 ^~~~
>> kernel/extable.c:169:2: note: in expansion of macro 'if'
     if (addr >= (unsigned long)__start_ro_after_init &&
     ^~
   kernel/extable.c:169:29: note: each undeclared identifier is reported only once for each function it appears in
     if (addr >= (unsigned long)__start_ro_after_init &&
                                ^
   include/linux/compiler.h:160:30: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                 ^~~~
>> kernel/extable.c:169:2: note: in expansion of macro 'if'
     if (addr >= (unsigned long)__start_ro_after_init &&
     ^~
   kernel/extable.c:170:28: error: '__end_ro_after_init' undeclared (first use in this function)
         addr < (unsigned long)__end_ro_after_init)
                               ^
   include/linux/compiler.h:160:30: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                 ^~~~
>> kernel/extable.c:169:2: note: in expansion of macro 'if'
     if (addr >= (unsigned long)__start_ro_after_init &&
     ^~

vim +/if +169 kernel/extable.c

    12	    GNU General Public License for more details.
    13	
    14	    You should have received a copy of the GNU General Public License
    15	    along with this program; if not, write to the Free Software
    16	    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
    17	*/
  > 18	#include <linux/ftrace.h>
    19	#include <linux/memory.h>
    20	#include <linux/extable.h>
    21	#include <linux/module.h>
    22	#include <linux/mutex.h>
    23	#include <linux/init.h>
    24	#include <linux/kprobes.h>
    25	#include <linux/filter.h>
    26	
    27	#include <asm/sections.h>
    28	#include <linux/uaccess.h>
    29	
    30	/*
    31	 * mutex protecting text section modification (dynamic code patching).
    32	 * some users need to sleep (allocating memory...) while they hold this lock.
    33	 *
    34	 * NOT exported to modules - patching kernel text is a really delicate matter.
    35	 */
    36	DEFINE_MUTEX(text_mutex);
    37	
    38	extern struct exception_table_entry __start___ex_table[];
    39	extern struct exception_table_entry __stop___ex_table[];
    40	
    41	/* Cleared by build time tools if the table is already sorted. */
    42	u32 __initdata __visible main_extable_sort_needed = 1;
    43	
    44	/* Sort the kernel's built-in exception table */
    45	void __init sort_main_extable(void)
    46	{
    47		if (main_extable_sort_needed && __stop___ex_table > __start___ex_table) {
    48			pr_notice("Sorting __ex_table...\n");
    49			sort_extable(__start___ex_table, __stop___ex_table);
    50		}
    51	}
    52	
    53	/* Given an address, look for it in the exception tables. */
    54	const struct exception_table_entry *search_exception_tables(unsigned long addr)
    55	{
    56		const struct exception_table_entry *e;
    57	
    58		e = search_extable(__start___ex_table, __stop___ex_table-1, addr);
    59		if (!e)
    60			e = search_module_extables(addr);
    61		return e;
    62	}
    63	
    64	static inline int init_kernel_text(unsigned long addr)
    65	{
    66		if (addr >= (unsigned long)_sinittext &&
    67		    addr < (unsigned long)_einittext)
    68			return 1;
    69		return 0;
    70	}
    71	
    72	int core_kernel_text(unsigned long addr)
    73	{
    74		if (addr >= (unsigned long)_stext &&
    75		    addr < (unsigned long)_etext)
    76			return 1;
    77	
    78		if (system_state == SYSTEM_BOOTING &&
    79		    init_kernel_text(addr))
    80			return 1;
    81		return 0;
    82	}
    83	
    84	/**
    85	 * core_kernel_data - tell if addr points to kernel data
    86	 * @addr: address to test
    87	 *
    88	 * Returns true if @addr passed in is from the core kernel data
    89	 * section.
    90	 *
    91	 * Note: On some archs it may return true for core RODATA, and false
    92	 *  for others. But will always be true for core RW data.
    93	 */
    94	int core_kernel_data(unsigned long addr)
    95	{
    96		if (addr >= (unsigned long)_sdata &&
    97		    addr < (unsigned long)_edata)
    98			return 1;
    99		return 0;
   100	}
   101	
   102	int __kernel_text_address(unsigned long addr)
   103	{
   104		if (core_kernel_text(addr))
   105			return 1;
   106		if (is_module_text_address(addr))
   107			return 1;
   108		if (is_ftrace_trampoline(addr))
   109			return 1;
   110		if (is_kprobe_optinsn_slot(addr) || is_kprobe_insn_slot(addr))
   111			return 1;
   112		if (is_bpf_text_address(addr))
   113			return 1;
   114		/*
   115		 * There might be init symbols in saved stacktraces.
   116		 * Give those symbols a chance to be printed in
   117		 * backtraces (such as lockdep traces).
   118		 *
   119		 * Since we are after the module-symbols check, there's
   120		 * no danger of address overlap:
   121		 */
   122		if (init_kernel_text(addr))
   123			return 1;
   124		return 0;
   125	}
   126	
   127	int kernel_text_address(unsigned long addr)
   128	{
   129		if (core_kernel_text(addr))
   130			return 1;
   131		if (is_module_text_address(addr))
   132			return 1;
   133		if (is_ftrace_trampoline(addr))
   134			return 1;
   135		if (is_kprobe_optinsn_slot(addr) || is_kprobe_insn_slot(addr))
   136			return 1;
   137		if (is_bpf_text_address(addr))
   138			return 1;
   139		return 0;
   140	}
   141	
   142	/*
   143	 * On some architectures (PPC64, IA64) function pointers
   144	 * are actually only tokens to some data that then holds the
   145	 * real function address. As a result, to find if a function
   146	 * pointer is part of the kernel text, we need to do some
   147	 * special dereferencing first.
   148	 */
   149	int func_ptr_is_kernel_text(void *ptr)
   150	{
   151		unsigned long addr;
   152		addr = (unsigned long) dereference_function_descriptor(ptr);
   153		if (core_kernel_text(addr))
   154			return 1;
   155		return is_module_text_address(addr);
   156	}
   157	
   158	/**
   159	 * core_kernel_rodata - Verify address points to read-only section
   160	 * @addr: address to test
   161	 *
   162	 */
   163	int core_kernel_rodata(unsigned long addr)
   164	{
   165		if (addr >= (unsigned long)__start_rodata &&
   166		    addr < (unsigned long)__end_rodata)
   167			return 1;
   168	
 > 169		if (addr >= (unsigned long)__start_ro_after_init &&
   170		    addr < (unsigned long)__end_ro_after_init)
   171			return 1;
   172	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--/04w6evG8XlLl3ft
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICOdz5lgAAy5jb25maWcAlFxLc9w4kr73r6hw72Hm0LZeVntjQwcQBKswRRIUAJZKujDU
ctmtGFny6DHdvb9+MwGyCIDJ8uxEx4QrM/HOx5cJUD//9POCvb0+fbt9vb+7fXj4a/F197h7
vn3dfV58uX/Y/c8iV4ta2YXIpX0PwuX949ufH+5PP50vzt4fH78/+uX57myx3j0/7h4W/Onx
y/3XN2h+//T4088gzlVdyGV3fpZJu7h/WTw+vS5edq8/9fTtp/Pu9OTir+D3+EPWxuqWW6nq
Lhdc5UKPTNXaprVdoXTF7MW73cOX05NfcFrvBgmm+QraFf7nxbvb57vfP/z56fzDnZvli1tE
93n3xf/etysVX+ei6UzbNErbcUhjGV9bzbiY8qqqHX+4kauKNZ2u8w5WbrpK1hefDvHZ9uL4
nBbgqmqY/WE/kVjUXS1E3plll1esK0W9tKtxrktRCy15Jw1D/pSRtcspcXUl5HJl0yWz627F
NqJreFfkfOTqKyOqbstXS5bnHSuXSku7qqb9clbKTDMr4OBKdp30v2Km403baeBtKR7jK9GV
soYDkjdilHCTMsK2TdcI7fpgWgSLdTs0sESVwa9CamM7vmrr9Yxcw5aCFvMzkpnQNXPq2yhj
ZFaKRMS0phFwdDPsK1bbbtXCKE0FB7iCOVMSbvNY6SRtmU3GcKpqOtVYWcG25GBYsEeyXs5J
5gIO3S2PlWANkXmCuXamauaato1WmTAju5DbTjBdXsPvrhLBmTdLy2DNoJEbUZqLk4G+N1k4
SQOm/eHh/rcP354+vz3sXj78V1uzSqAGCGbEh/eJ7Up92V0pHRxF1soyh4WLTmz9eCYyXLsC
RcAtKRT8X2eZwcbOdy2dJ3xAf/X2HSh7tyRtJ+oNrBynWEl7cbqfPNdwlM4UJRznu3ejC+xp
nRWG8oSwz6zcCG1AXbAdQe5Ya1Wi1GtQMVF2yxvZ0JwMOCc0q7wJ7T3kbG/mWsyMX96cAWO/
1mBW4VJTvpvbIQGc4SH+9obYyWiu0x7PiCagcqwtwdaUsahfF+/+9vj0uPv7/hjMFWvC3sy1
2ciGk3MDYwadry5b0QpSwOsI2ILS1x2zEFVWxJyKFatz5xL2DVsjwD0SsqyF6JycjLNLx4DJ
ghKVgcnOU8GjWL5KiVYLMVgFmNji5e23l79eXnffRqvYxxGwQOcDiBADLLNSV1MOOkHwRyhB
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
LoMJcR2JAQA=

--/04w6evG8XlLl3ft--
