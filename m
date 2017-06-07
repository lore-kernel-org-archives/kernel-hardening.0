Date: Thu, 8 Jun 2017 01:42:33 +0800
From: kbuild test robot <lkp@intel.com>
Message-ID: <201706080107.xhkKszte%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <20170606005108.5646-4-Jason@zx2c4.com>
Subject: [kernel-hardening] Re: [PATCH v3 03/13] random: invalidate batched entropy after crng
 init
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: kbuild-all@01.org, Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jason,

[auto build test WARNING on linus/master]
[also build test WARNING on v4.12-rc4]
[cannot apply to next-20170607]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Jason-A-Donenfeld/Unseeded-In-Kernel-Randomness-Fixes/20170606-171249
config: sh-ul2_defconfig (attached as .config)
compiler: sh4-linux-gnu-gcc (Debian 6.1.1-9) 6.1.1 20160705
reproduce:
        wget https://raw.githubusercontent.com/01org/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=sh 

Note: it may well be a FALSE warning. FWIW you are at least aware of it now.
http://gcc.gnu.org/wiki/Better_Uninitialized_Warnings

All warnings (new ones prefixed by >>):

   In file included from include/linux/spinlock.h:53:0,
                    from include/linux/rcupdate.h:38,
                    from include/linux/rculist.h:10,
                    from include/linux/pid.h:4,
                    from include/linux/sched.h:13,
                    from include/linux/utsname.h:5,
                    from drivers//char/random.c:238:
   drivers//char/random.c: In function 'get_random_u64':
>> include/linux/irqflags.h:69:3: warning: 'flags' may be used uninitialized in this function [-Wmaybe-uninitialized]
      arch_local_irq_restore(flags);  \
      ^~~~~~~~~~~~~~~~~~~~~~
   drivers//char/random.c:2063:16: note: 'flags' was declared here
     unsigned long flags;
                   ^~~~~
   In file included from include/linux/spinlock.h:53:0,
                    from include/linux/rcupdate.h:38,
                    from include/linux/rculist.h:10,
                    from include/linux/pid.h:4,
                    from include/linux/sched.h:13,
                    from include/linux/utsname.h:5,
                    from drivers//char/random.c:238:
   drivers//char/random.c: In function 'get_random_u32':
>> include/linux/irqflags.h:69:3: warning: 'flags' may be used uninitialized in this function [-Wmaybe-uninitialized]
      arch_local_irq_restore(flags);  \
      ^~~~~~~~~~~~~~~~~~~~~~
   drivers//char/random.c:2095:16: note: 'flags' was declared here
     unsigned long flags;
                   ^~~~~
--
   In file included from include/linux/spinlock.h:53:0,
                    from include/linux/rcupdate.h:38,
                    from include/linux/rculist.h:10,
                    from include/linux/pid.h:4,
                    from include/linux/sched.h:13,
                    from include/linux/utsname.h:5,
                    from drivers/char/random.c:238:
   drivers/char/random.c: In function 'get_random_u64':
>> include/linux/irqflags.h:69:3: warning: 'flags' may be used uninitialized in this function [-Wmaybe-uninitialized]
      arch_local_irq_restore(flags);  \
      ^~~~~~~~~~~~~~~~~~~~~~
   drivers/char/random.c:2063:16: note: 'flags' was declared here
     unsigned long flags;
                   ^~~~~
   In file included from include/linux/spinlock.h:53:0,
                    from include/linux/rcupdate.h:38,
                    from include/linux/rculist.h:10,
                    from include/linux/pid.h:4,
                    from include/linux/sched.h:13,
                    from include/linux/utsname.h:5,
                    from drivers/char/random.c:238:
   drivers/char/random.c: In function 'get_random_u32':
>> include/linux/irqflags.h:69:3: warning: 'flags' may be used uninitialized in this function [-Wmaybe-uninitialized]
      arch_local_irq_restore(flags);  \
      ^~~~~~~~~~~~~~~~~~~~~~
   drivers/char/random.c:2095:16: note: 'flags' was declared here
     unsigned long flags;
                   ^~~~~

vim +/flags +69 include/linux/irqflags.h

81d68a96a Steven Rostedt 2008-05-12  53  # define start_critical_timings() do { } while (0)
81d68a96a Steven Rostedt 2008-05-12  54  #endif
81d68a96a Steven Rostedt 2008-05-12  55  
df9ee2927 David Howells  2010-10-07  56  /*
df9ee2927 David Howells  2010-10-07  57   * Wrap the arch provided IRQ routines to provide appropriate checks.
df9ee2927 David Howells  2010-10-07  58   */
df9ee2927 David Howells  2010-10-07  59  #define raw_local_irq_disable()		arch_local_irq_disable()
df9ee2927 David Howells  2010-10-07  60  #define raw_local_irq_enable()		arch_local_irq_enable()
df9ee2927 David Howells  2010-10-07  61  #define raw_local_irq_save(flags)			\
df9ee2927 David Howells  2010-10-07  62  	do {						\
df9ee2927 David Howells  2010-10-07  63  		typecheck(unsigned long, flags);	\
df9ee2927 David Howells  2010-10-07  64  		flags = arch_local_irq_save();		\
df9ee2927 David Howells  2010-10-07  65  	} while (0)
df9ee2927 David Howells  2010-10-07  66  #define raw_local_irq_restore(flags)			\
df9ee2927 David Howells  2010-10-07  67  	do {						\
df9ee2927 David Howells  2010-10-07  68  		typecheck(unsigned long, flags);	\
df9ee2927 David Howells  2010-10-07 @69  		arch_local_irq_restore(flags);		\
df9ee2927 David Howells  2010-10-07  70  	} while (0)
df9ee2927 David Howells  2010-10-07  71  #define raw_local_save_flags(flags)			\
df9ee2927 David Howells  2010-10-07  72  	do {						\
df9ee2927 David Howells  2010-10-07  73  		typecheck(unsigned long, flags);	\
df9ee2927 David Howells  2010-10-07  74  		flags = arch_local_save_flags();	\
df9ee2927 David Howells  2010-10-07  75  	} while (0)
df9ee2927 David Howells  2010-10-07  76  #define raw_irqs_disabled_flags(flags)			\
df9ee2927 David Howells  2010-10-07  77  	({						\

:::::: The code at line 69 was first introduced by commit
:::::: df9ee29270c11dba7d0fe0b83ce47a4d8e8d2101 Fix IRQ flag handling naming

:::::: TO: David Howells <dhowells@redhat.com>
:::::: CC: David Howells <dhowells@redhat.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--YZ5djTAD1cGYuMQK
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--YZ5djTAD1cGYuMQK--
