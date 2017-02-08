Date: Wed, 8 Feb 2017 12:41:03 +0800
From: kbuild test robot <lkp@intel.com>
Message-ID: <201702081207.FU7WMAOf%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <20170207234031.GA27933@beast>
Subject: [kernel-hardening] Re: [PATCH] time: Remove CONFIG_TIMER_STATS
To: Kees Cook <keescook@chromium.org>
Cc: kbuild-all@01.org, Thomas Gleixner <tglx@linutronix.de>, Xing Gao <xgao01@email.wm.edu>, Jessica Frazelle <me@jessfraz.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Jonathan Corbet <corbet@lwn.net>, John Stultz <john.stultz@linaro.org>, Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, Petr Mladek <pmladek@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nicolas Iooss <nicolas.iooss_linux@m4x.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Richard Cochran <richardcochran@gmail.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Michal Marek <mmarek@suse.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, Olof Johansson <olof@lixom.net>, Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Kees,

[auto build test WARNING on tip/timers/core]
[also build test WARNING on v4.10-rc7 next-20170207]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Kees-Cook/time-Remove-CONFIG_TIMER_STATS/20170208-080916
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   make[3]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
   include/linux/init.h:1: warning: no structured comments found
>> include/linux/hrtimer.h:108: warning: Excess struct/union/enum/typedef member 'start_pid' description in 'hrtimer'
>> include/linux/hrtimer.h:108: warning: Excess struct/union/enum/typedef member 'start_site' description in 'hrtimer'
>> include/linux/hrtimer.h:108: warning: Excess struct/union/enum/typedef member 'start_comm' description in 'hrtimer'
   include/linux/kthread.h:26: warning: Excess function parameter '...' description in 'kthread_create'
   kernel/sys.c:1: warning: no structured comments found
   drivers/dma-buf/seqno-fence.c:1: warning: no structured comments found
   include/drm/drm_drv.h:409: warning: No description found for parameter 'load'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'firstopen'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'open'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'preclose'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'postclose'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'lastclose'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'unload'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'dma_ioctl'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'dma_quiescent'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'context_dtor'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'set_busid'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'irq_handler'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'irq_preinstall'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'irq_postinstall'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'irq_uninstall'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'debugfs_init'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'debugfs_cleanup'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'gem_open_object'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'gem_close_object'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'prime_handle_to_fd'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'prime_fd_to_handle'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'gem_prime_export'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'gem_prime_import'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'gem_prime_pin'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'gem_prime_unpin'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'gem_prime_res_obj'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'gem_prime_get_sg_table'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'gem_prime_import_sg_table'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'gem_prime_vmap'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'gem_prime_vunmap'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'gem_prime_mmap'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'vgaarb_irq'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'gem_vm_ops'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'major'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'minor'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'patchlevel'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'name'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'desc'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'date'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'driver_features'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'dev_priv_size'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'ioctls'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'num_ioctls'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'fops'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'legacy_dev_list'
   drivers/media/dvb-core/dvb_frontend.h:677: warning: No description found for parameter 'refcount'
   drivers/char/tpm/tpm_vtpm_proxy.c:73: warning: No description found for parameter 'filp'
   drivers/char/tpm/tpm_vtpm_proxy.c:73: warning: No description found for parameter 'buf'
   drivers/char/tpm/tpm_vtpm_proxy.c:73: warning: No description found for parameter 'count'
   drivers/char/tpm/tpm_vtpm_proxy.c:73: warning: No description found for parameter 'off'
   drivers/char/tpm/tpm_vtpm_proxy.c:123: warning: No description found for parameter 'filp'
   drivers/char/tpm/tpm_vtpm_proxy.c:123: warning: No description found for parameter 'buf'
   drivers/char/tpm/tpm_vtpm_proxy.c:123: warning: No description found for parameter 'count'
   drivers/char/tpm/tpm_vtpm_proxy.c:123: warning: No description found for parameter 'off'
   drivers/char/tpm/tpm_vtpm_proxy.c:203: warning: No description found for parameter 'proxy_dev'
   sound/soc/soc-core.c:994: warning: No description found for parameter 'stream_name'
   Documentation/core-api/assoc_array.rst:13: WARNING: Enumerated list ends without a blank line; unexpected unindent.
   Documentation/doc-guide/sphinx.rst:110: ERROR: Unknown target name: "sphinx c domain".
   include/net/cfg80211.h:3154: ERROR: Unexpected indentation.
   include/net/mac80211.h:3214: ERROR: Unexpected indentation.
   include/net/mac80211.h:3217: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/net/mac80211.h:3219: ERROR: Unexpected indentation.
   include/net/mac80211.h:3220: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/net/mac80211.h:1773: ERROR: Unexpected indentation.
   include/net/mac80211.h:1777: WARNING: Block quote ends without a blank line; unexpected unindent.
   kernel/sched/fair.c:7587: WARNING: Inline emphasis start-string without end-string.
   kernel/time/timer.c:1198: ERROR: Unexpected indentation.
   kernel/time/timer.c:1200: ERROR: Unexpected indentation.
   kernel/time/timer.c:1201: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/linux/wait.h:121: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/linux/wait.h:124: ERROR: Unexpected indentation.
   include/linux/wait.h:126: WARNING: Block quote ends without a blank line; unexpected unindent.
   kernel/time/hrtimer.c:990: WARNING: Block quote ends without a blank line; unexpected unindent.
   kernel/signal.c:317: WARNING: Inline literal start-string without end-string.
   drivers/message/fusion/mptbase.c:5051: WARNING: Definition list ends without a blank line; unexpected unindent.
   drivers/tty/serial/serial_core.c:1897: WARNING: Definition list ends without a blank line; unexpected unindent.
   include/linux/spi/spi.h:369: ERROR: Unexpected indentation.
   drivers/usb/core/message.c:481: ERROR: Unexpected indentation.
   drivers/usb/core/message.c:482: WARNING: Block quote ends without a blank line; unexpected unindent.
   Documentation/driver-api/usb.rst:623: ERROR: Unknown target name: "usb_type".
   Documentation/driver-api/usb.rst:623: ERROR: Unknown target name: "usb_dir".
   Documentation/driver-api/usb.rst:623: ERROR: Unknown target name: "usb_recip".
   Documentation/driver-api/usb.rst:689: ERROR: Unknown target name: "usbdevfs_urb_type".
   sound/soc/soc-core.c:2508: ERROR: Unknown target name: "snd_soc_daifmt".
   sound/core/jack.c:312: ERROR: Unknown target name: "snd_jack_btn".
   Documentation/translations/ko_KR/howto.rst:293: WARNING: Inline emphasis start-string without end-string.
   WARNING: dvipng command 'dvipng' cannot be run (needed for math display), check the imgmath_dvipng setting

vim +108 include/linux/hrtimer.h

e2e680fb Viresh Kumar     2014-03-19   92   *		started the timer
54cdfdb4 Thomas Gleixner  2007-02-16   93   * @start_site:	timer statistics field to store the site where the timer
54cdfdb4 Thomas Gleixner  2007-02-16   94   *		was started
54cdfdb4 Thomas Gleixner  2007-02-16   95   * @start_comm: timer statistics field to store the name of the process which
54cdfdb4 Thomas Gleixner  2007-02-16   96   *		started the timer
c0a31329 Thomas Gleixner  2006-01-09   97   *
54cdfdb4 Thomas Gleixner  2007-02-16   98   * The hrtimer structure must be initialized by hrtimer_init()
c0a31329 Thomas Gleixner  2006-01-09   99   */
c0a31329 Thomas Gleixner  2006-01-09  100  struct hrtimer {
998adc3d John Stultz      2010-09-20  101  	struct timerqueue_node		node;
654c8e0b Arjan van de Ven 2008-09-01  102  	ktime_t				_softexpires;
c9cb2e3d Thomas Gleixner  2007-02-16  103  	enum hrtimer_restart		(*function)(struct hrtimer *);
3c8aa39d Thomas Gleixner  2007-02-16  104  	struct hrtimer_clock_base	*base;
203cbf77 Thomas Gleixner  2016-01-14  105  	u8				state;
203cbf77 Thomas Gleixner  2016-01-14  106  	u8				is_rel;
c0a31329 Thomas Gleixner  2006-01-09  107  };
c0a31329 Thomas Gleixner  2006-01-09 @108  
c0a31329 Thomas Gleixner  2006-01-09  109  /**
00362e33 Thomas Gleixner  2006-03-31  110   * struct hrtimer_sleeper - simple sleeper structure
00362e33 Thomas Gleixner  2006-03-31  111   * @timer:	embedded timer structure
00362e33 Thomas Gleixner  2006-03-31  112   * @task:	task to wake up
00362e33 Thomas Gleixner  2006-03-31  113   *
00362e33 Thomas Gleixner  2006-03-31  114   * task is set to NULL, when the timer expires.
00362e33 Thomas Gleixner  2006-03-31  115   */
00362e33 Thomas Gleixner  2006-03-31  116  struct hrtimer_sleeper {

:::::: The code at line 108 was first introduced by commit
:::::: c0a3132963db68f1fbbd0e316b73de100fee3f08 [PATCH] hrtimer: hrtimer core code

:::::: TO: Thomas Gleixner <tglx@linutronix.de>
:::::: CC: Linus Torvalds <torvalds@g5.osdl.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--xHFwDpU9dbj6ez1V
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--xHFwDpU9dbj6ez1V--
