Date: Tue, 10 Apr 2018 12:00:05 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH] dmaengine: dmatest: Remove use of VLAs
Message-ID: <201804101131.V43Xq6df%fengguang.wu@intel.com>
References: <20180409210603.3575-1-labbott@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <20180409210603.3575-1-labbott@redhat.com>
To: Laura Abbott <labbott@redhat.com>
Cc: kbuild-all@01.org, Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Laura,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v4.16 next-20180409]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Laura-Abbott/dmaengine-dmatest-Remove-use-of-VLAs/20180410-094633
config: i386-randconfig-x076-201814 (attached as .config)
compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All warnings (new ones prefixed by >>):

   Cyclomatic Complexity 1 include/linux/kasan-checks.h:kasan_check_write
   Cyclomatic Complexity 2 arch/x86/include/asm/bitops.h:set_bit
   Cyclomatic Complexity 1 arch/x86/include/asm/bitops.h:constant_test_bit
   Cyclomatic Complexity 1 arch/x86/include/asm/bitops.h:variable_test_bit
   Cyclomatic Complexity 1 arch/x86/include/asm/bitops.h:fls
   Cyclomatic Complexity 1 include/linux/log2.h:__ilog2_u32
   Cyclomatic Complexity 3 include/linux/log2.h:is_power_of_2
   Cyclomatic Complexity 1 include/linux/list.h:INIT_LIST_HEAD
   Cyclomatic Complexity 1 include/linux/list.h:__list_add_valid
   Cyclomatic Complexity 1 include/linux/list.h:__list_del_entry_valid
   Cyclomatic Complexity 2 include/linux/list.h:__list_add
   Cyclomatic Complexity 1 include/linux/list.h:list_add_tail
   Cyclomatic Complexity 1 include/linux/list.h:__list_del
   Cyclomatic Complexity 2 include/linux/list.h:__list_del_entry
   Cyclomatic Complexity 1 include/linux/list.h:list_del
   Cyclomatic Complexity 1 include/linux/err.h:IS_ERR
   Cyclomatic Complexity 1 arch/x86/include/asm/current.h:get_current
   Cyclomatic Complexity 1 arch/x86/include/asm/atomic.h:arch_atomic_read
   Cyclomatic Complexity 1 arch/x86/include/asm/atomic.h:arch_atomic_inc
   Cyclomatic Complexity 1 arch/x86/include/asm/atomic.h:arch_atomic_dec_and_test
   Cyclomatic Complexity 1 include/asm-generic/atomic-instrumented.h:atomic_read
   Cyclomatic Complexity 1 include/asm-generic/atomic-instrumented.h:atomic_inc
   Cyclomatic Complexity 1 include/asm-generic/atomic-instrumented.h:atomic_dec_and_test
   Cyclomatic Complexity 1 include/asm-generic/getorder.h:__get_order
   Cyclomatic Complexity 3 include/linux/bitmap.h:bitmap_zero
   Cyclomatic Complexity 1 include/linux/jiffies.h:_msecs_to_jiffies
   Cyclomatic Complexity 3 include/linux/jiffies.h:msecs_to_jiffies
   Cyclomatic Complexity 70 include/linux/ktime.h:ktime_divns
   Cyclomatic Complexity 1 include/linux/ktime.h:ktime_to_us
   Cyclomatic Complexity 1 include/linux/mmzone.h:pfn_to_section_nr
   Cyclomatic Complexity 2 include/linux/mmzone.h:__nr_to_section
   Cyclomatic Complexity 1 include/linux/mmzone.h:__section_mem_map_addr
   Cyclomatic Complexity 1 include/linux/mmzone.h:__pfn_to_section
   Cyclomatic Complexity 1 include/linux/kobject.h:kobject_name
   Cyclomatic Complexity 2 include/linux/device.h:dev_name
   Cyclomatic Complexity 1 include/linux/dma-debug.h:debug_dma_map_page
   Cyclomatic Complexity 1 include/linux/dma-debug.h:debug_dma_mapping_error
   Cyclomatic Complexity 1 include/linux/dma-mapping.h:valid_dma_direction
   Cyclomatic Complexity 1 arch/x86/include/asm/dma-mapping.h:get_arch_dma_ops
   Cyclomatic Complexity 4 include/linux/dma-mapping.h:get_dma_ops
   Cyclomatic Complexity 1 include/linux/dma-mapping.h:dma_map_page_attrs
   Cyclomatic Complexity 2 include/linux/dma-mapping.h:dma_mapping_error
   Cyclomatic Complexity 1 include/linux/dmaengine.h:dma_submit_error
   Cyclomatic Complexity 1 include/linux/dmaengine.h:dma_chan_name
   Cyclomatic Complexity 2 include/linux/dmaengine.h:dmaengine_terminate_all
   Cyclomatic Complexity 1 include/linux/dmaengine.h:dmaf_continue
   Cyclomatic Complexity 1 include/linux/dmaengine.h:dmaf_p_disabled_continue
   Cyclomatic Complexity 1 include/linux/dmaengine.h:dma_dev_has_pq_continue
   Cyclomatic Complexity 1 include/linux/dmaengine.h:dma_dev_to_maxpq
   Cyclomatic Complexity 4 include/linux/dmaengine.h:dma_maxpq
   Cyclomatic Complexity 1 include/linux/dmaengine.h:__dma_cap_set
   Cyclomatic Complexity 1 include/linux/dmaengine.h:__dma_cap_zero
   Cyclomatic Complexity 2 include/linux/dmaengine.h:__dma_has_cap
   Cyclomatic Complexity 1 include/linux/dmaengine.h:dma_async_issue_pending
   Cyclomatic Complexity 3 include/linux/dmaengine.h:dma_async_is_tx_complete
   Cyclomatic Complexity 2 include/linux/freezer.h:freezing
   Cyclomatic Complexity 2 include/linux/freezer.h:try_to_freeze_unsafe
   Cyclomatic Complexity 2 include/linux/freezer.h:try_to_freeze
   Cyclomatic Complexity 1 include/linux/kasan.h:kasan_kmalloc
   Cyclomatic Complexity 28 include/linux/slab.h:kmalloc_index
   Cyclomatic Complexity 1 include/linux/slab.h:kmem_cache_alloc_trace
   Cyclomatic Complexity 1 include/linux/slab.h:kmalloc_order_trace
   Cyclomatic Complexity 67 include/linux/slab.h:kmalloc_large
   Cyclomatic Complexity 5 include/linux/slab.h:kmalloc
   Cyclomatic Complexity 5 include/linux/slab.h:kmalloc_array
   Cyclomatic Complexity 1 include/linux/slab.h:kcalloc
   Cyclomatic Complexity 1 include/linux/slab.h:kzalloc
   Cyclomatic Complexity 2 include/linux/sched/task.h:put_task_struct
   Cyclomatic Complexity 2 drivers/dma/dmatest.c:gen_inv_idx
   Cyclomatic Complexity 1 drivers/dma/dmatest.c:gen_src_value
   Cyclomatic Complexity 1 drivers/dma/dmatest.c:gen_dst_value
   Cyclomatic Complexity 5 drivers/dma/dmatest.c:dmatest_init_srcs
   Cyclomatic Complexity 5 drivers/dma/dmatest.c:dmatest_init_dsts
   Cyclomatic Complexity 2 drivers/dma/dmatest.c:min_odd
   Cyclomatic Complexity 8 drivers/dma/dmatest.c:is_threaded_test_run
   Cyclomatic Complexity 5 drivers/dma/dmatest.c:dmatest_mismatch
   Cyclomatic Complexity 6 drivers/dma/dmatest.c:dmatest_verify
   Cyclomatic Complexity 1 drivers/dma/dmatest.c:result
   Cyclomatic Complexity 1 drivers/dma/dmatest.c:dbg_result
   Cyclomatic Complexity 5 drivers/dma/dmatest.c:dmatest_cleanup_channel
   Cyclomatic Complexity 5 drivers/dma/dmatest.c:stop_threaded_test
   Cyclomatic Complexity 2 drivers/dma/dmatest.c:dmatest_run_get
   Cyclomatic Complexity 1 drivers/dma/dmatest.c:dmatest_exit
   Cyclomatic Complexity 2 drivers/dma/dmatest.c:dmatest_match_channel
   Cyclomatic Complexity 2 drivers/dma/dmatest.c:dmatest_match_device
   Cyclomatic Complexity 3 drivers/dma/dmatest.c:filter
   Cyclomatic Complexity 69 drivers/dma/dmatest.c:dmatest_persec
   Cyclomatic Complexity 1 drivers/dma/dmatest.c:dmatest_KBs
   Cyclomatic Complexity 8 drivers/dma/dmatest.c:dmatest_add_threads
   Cyclomatic Complexity 8 drivers/dma/dmatest.c:dmatest_add_channel
   Cyclomatic Complexity 5 drivers/dma/dmatest.c:request_channels
   Cyclomatic Complexity 1 drivers/dma/dmatest.c:run_threaded_test
   Cyclomatic Complexity 2 drivers/dma/dmatest.c:restart_threaded_test
   Cyclomatic Complexity 4 drivers/dma/dmatest.c:dmatest_run_set
   Cyclomatic Complexity 4 drivers/dma/dmatest.c:dmatest_callback
   Cyclomatic Complexity 1 drivers/dma/dmatest.c:dmatest_random
   Cyclomatic Complexity 52 drivers/dma/dmatest.c:dmatest_func
   Cyclomatic Complexity 4 drivers/dma/dmatest.c:dmatest_wait_get
   Cyclomatic Complexity 6 drivers/dma/dmatest.c:dmatest_init
   drivers/dma/dmatest.c: In function 'dmatest_func':
>> drivers/dma/dmatest.c:806:1: warning: the frame size of 4264 bytes is larger than 2048 bytes [-Wframe-larger-than=]
    }
    ^

vim +806 drivers/dma/dmatest.c

95019c8c5 Andy Shevchenko           2013-03-04  425  
4a776f0aa Haavard Skinnemoen        2008-07-08  426  /*
4a776f0aa Haavard Skinnemoen        2008-07-08  427   * This function repeatedly tests DMA transfers of various lengths and
b54d5cb91 Dan Williams              2009-03-25  428   * offsets for a given operation type until it is told to exit by
b54d5cb91 Dan Williams              2009-03-25  429   * kthread_stop(). There may be multiple threads running this function
b54d5cb91 Dan Williams              2009-03-25  430   * in parallel for a single channel, and there may be multiple channels
b54d5cb91 Dan Williams              2009-03-25  431   * being tested in parallel.
4a776f0aa Haavard Skinnemoen        2008-07-08  432   *
4a776f0aa Haavard Skinnemoen        2008-07-08  433   * Before each test, the source and destination buffer is initialized
4a776f0aa Haavard Skinnemoen        2008-07-08  434   * with a known pattern. This pattern is different depending on
4a776f0aa Haavard Skinnemoen        2008-07-08  435   * whether it's in an area which is supposed to be copied or
4a776f0aa Haavard Skinnemoen        2008-07-08  436   * overwritten, and different in the source and destination buffers.
4a776f0aa Haavard Skinnemoen        2008-07-08  437   * So if the DMA engine doesn't copy exactly what we tell it to copy,
4a776f0aa Haavard Skinnemoen        2008-07-08  438   * we'll notice.
4a776f0aa Haavard Skinnemoen        2008-07-08  439   */
4a776f0aa Haavard Skinnemoen        2008-07-08  440  static int dmatest_func(void *data)
4a776f0aa Haavard Skinnemoen        2008-07-08  441  {
4a776f0aa Haavard Skinnemoen        2008-07-08  442  	struct dmatest_thread	*thread = data;
6f6a23a21 Adam Wallis               2017-11-27  443  	struct dmatest_done	*done = &thread->test_done;
e03e93a97 Andy Shevchenko           2013-03-04  444  	struct dmatest_info	*info;
15b8a8ea1 Andy Shevchenko           2013-03-04  445  	struct dmatest_params	*params;
4a776f0aa Haavard Skinnemoen        2008-07-08  446  	struct dma_chan		*chan;
8be9e32b3 Akinobu Mita              2012-10-28  447  	struct dma_device	*dev;
4a776f0aa Haavard Skinnemoen        2008-07-08  448  	unsigned int		error_count;
4a776f0aa Haavard Skinnemoen        2008-07-08  449  	unsigned int		failed_tests = 0;
4a776f0aa Haavard Skinnemoen        2008-07-08  450  	unsigned int		total_tests = 0;
4a776f0aa Haavard Skinnemoen        2008-07-08  451  	dma_cookie_t		cookie;
4a776f0aa Haavard Skinnemoen        2008-07-08  452  	enum dma_status		status;
b54d5cb91 Dan Williams              2009-03-25  453  	enum dma_ctrl_flags 	flags;
945b5af3c Andy Shevchenko           2013-03-04  454  	u8			*pq_coefs = NULL;
4a776f0aa Haavard Skinnemoen        2008-07-08  455  	int			ret;
b54d5cb91 Dan Williams              2009-03-25  456  	int			src_cnt;
b54d5cb91 Dan Williams              2009-03-25  457  	int			dst_cnt;
b54d5cb91 Dan Williams              2009-03-25  458  	int			i;
e9405ef08 Sinan Kaya                2016-09-01  459  	ktime_t			ktime, start, diff;
8b0e19531 Thomas Gleixner           2016-12-25  460  	ktime_t			filltime = 0;
8b0e19531 Thomas Gleixner           2016-12-25  461  	ktime_t			comparetime = 0;
86727443a Dan Williams              2013-11-06  462  	s64			runtime = 0;
86727443a Dan Williams              2013-11-06  463  	unsigned long long	total_len = 0;
d64816086 Dave Jiang                2016-11-29  464  	u8			align = 0;
61b5f54d8 Sinan Kaya                2017-06-29  465  	bool			is_memset = false;
4a776f0aa Haavard Skinnemoen        2008-07-08  466  
adfa543e7 Tejun Heo                 2011-11-23  467  	set_freezable();
4a776f0aa Haavard Skinnemoen        2008-07-08  468  
4a776f0aa Haavard Skinnemoen        2008-07-08  469  	ret = -ENOMEM;
4a776f0aa Haavard Skinnemoen        2008-07-08  470  
4a776f0aa Haavard Skinnemoen        2008-07-08  471  	smp_rmb();
e03e93a97 Andy Shevchenko           2013-03-04  472  	info = thread->info;
15b8a8ea1 Andy Shevchenko           2013-03-04  473  	params = &info->params;
4a776f0aa Haavard Skinnemoen        2008-07-08  474  	chan = thread->chan;
8be9e32b3 Akinobu Mita              2012-10-28  475  	dev = chan->device;
d64816086 Dave Jiang                2016-11-29  476  	if (thread->type == DMA_MEMCPY) {
d64816086 Dave Jiang                2016-11-29  477  		align = dev->copy_align;
b54d5cb91 Dan Williams              2009-03-25  478  		src_cnt = dst_cnt = 1;
61b5f54d8 Sinan Kaya                2017-06-29  479  	} else if (thread->type == DMA_MEMSET) {
61b5f54d8 Sinan Kaya                2017-06-29  480  		align = dev->fill_align;
61b5f54d8 Sinan Kaya                2017-06-29  481  		src_cnt = dst_cnt = 1;
61b5f54d8 Sinan Kaya                2017-06-29  482  		is_memset = true;
d64816086 Dave Jiang                2016-11-29  483  	} else if (thread->type == DMA_XOR) {
8be9e32b3 Akinobu Mita              2012-10-28  484  		/* force odd to ensure dst = src */
15b8a8ea1 Andy Shevchenko           2013-03-04  485  		src_cnt = min_odd(params->xor_sources | 1, dev->max_xor);
b54d5cb91 Dan Williams              2009-03-25  486  		dst_cnt = 1;
d64816086 Dave Jiang                2016-11-29  487  		align = dev->xor_align;
58691d64c Dan Williams              2009-08-29  488  	} else if (thread->type == DMA_PQ) {
8be9e32b3 Akinobu Mita              2012-10-28  489  		/* force odd to ensure dst = src */
15b8a8ea1 Andy Shevchenko           2013-03-04  490  		src_cnt = min_odd(params->pq_sources | 1, dma_maxpq(dev, 0));
58691d64c Dan Williams              2009-08-29  491  		dst_cnt = 2;
d64816086 Dave Jiang                2016-11-29  492  		align = dev->pq_align;
945b5af3c Andy Shevchenko           2013-03-04  493  
15b8a8ea1 Andy Shevchenko           2013-03-04  494  		pq_coefs = kmalloc(params->pq_sources + 1, GFP_KERNEL);
945b5af3c Andy Shevchenko           2013-03-04  495  		if (!pq_coefs)
945b5af3c Andy Shevchenko           2013-03-04  496  			goto err_thread_type;
945b5af3c Andy Shevchenko           2013-03-04  497  
94de648d7 Anatolij Gustschin        2010-02-15  498  		for (i = 0; i < src_cnt; i++)
58691d64c Dan Williams              2009-08-29  499  			pq_coefs[i] = 1;
b54d5cb91 Dan Williams              2009-03-25  500  	} else
945b5af3c Andy Shevchenko           2013-03-04  501  		goto err_thread_type;
b54d5cb91 Dan Williams              2009-03-25  502  
b54d5cb91 Dan Williams              2009-03-25  503  	thread->srcs = kcalloc(src_cnt + 1, sizeof(u8 *), GFP_KERNEL);
b54d5cb91 Dan Williams              2009-03-25  504  	if (!thread->srcs)
b54d5cb91 Dan Williams              2009-03-25  505  		goto err_srcs;
d64816086 Dave Jiang                2016-11-29  506  
d64816086 Dave Jiang                2016-11-29  507  	thread->usrcs = kcalloc(src_cnt + 1, sizeof(u8 *), GFP_KERNEL);
d64816086 Dave Jiang                2016-11-29  508  	if (!thread->usrcs)
d64816086 Dave Jiang                2016-11-29  509  		goto err_usrcs;
d64816086 Dave Jiang                2016-11-29  510  
b54d5cb91 Dan Williams              2009-03-25  511  	for (i = 0; i < src_cnt; i++) {
d64816086 Dave Jiang                2016-11-29  512  		thread->usrcs[i] = kmalloc(params->buf_size + align,
d64816086 Dave Jiang                2016-11-29  513  					   GFP_KERNEL);
d64816086 Dave Jiang                2016-11-29  514  		if (!thread->usrcs[i])
b54d5cb91 Dan Williams              2009-03-25  515  			goto err_srcbuf;
d64816086 Dave Jiang                2016-11-29  516  
d64816086 Dave Jiang                2016-11-29  517  		/* align srcs to alignment restriction */
d64816086 Dave Jiang                2016-11-29  518  		if (align)
d64816086 Dave Jiang                2016-11-29  519  			thread->srcs[i] = PTR_ALIGN(thread->usrcs[i], align);
d64816086 Dave Jiang                2016-11-29  520  		else
d64816086 Dave Jiang                2016-11-29  521  			thread->srcs[i] = thread->usrcs[i];
b54d5cb91 Dan Williams              2009-03-25  522  	}
b54d5cb91 Dan Williams              2009-03-25  523  	thread->srcs[i] = NULL;
b54d5cb91 Dan Williams              2009-03-25  524  
b54d5cb91 Dan Williams              2009-03-25  525  	thread->dsts = kcalloc(dst_cnt + 1, sizeof(u8 *), GFP_KERNEL);
b54d5cb91 Dan Williams              2009-03-25  526  	if (!thread->dsts)
b54d5cb91 Dan Williams              2009-03-25  527  		goto err_dsts;
d64816086 Dave Jiang                2016-11-29  528  
d64816086 Dave Jiang                2016-11-29  529  	thread->udsts = kcalloc(dst_cnt + 1, sizeof(u8 *), GFP_KERNEL);
d64816086 Dave Jiang                2016-11-29  530  	if (!thread->udsts)
d64816086 Dave Jiang                2016-11-29  531  		goto err_udsts;
d64816086 Dave Jiang                2016-11-29  532  
b54d5cb91 Dan Williams              2009-03-25  533  	for (i = 0; i < dst_cnt; i++) {
d64816086 Dave Jiang                2016-11-29  534  		thread->udsts[i] = kmalloc(params->buf_size + align,
d64816086 Dave Jiang                2016-11-29  535  					   GFP_KERNEL);
d64816086 Dave Jiang                2016-11-29  536  		if (!thread->udsts[i])
b54d5cb91 Dan Williams              2009-03-25  537  			goto err_dstbuf;
d64816086 Dave Jiang                2016-11-29  538  
d64816086 Dave Jiang                2016-11-29  539  		/* align dsts to alignment restriction */
d64816086 Dave Jiang                2016-11-29  540  		if (align)
d64816086 Dave Jiang                2016-11-29  541  			thread->dsts[i] = PTR_ALIGN(thread->udsts[i], align);
d64816086 Dave Jiang                2016-11-29  542  		else
d64816086 Dave Jiang                2016-11-29  543  			thread->dsts[i] = thread->udsts[i];
b54d5cb91 Dan Williams              2009-03-25  544  	}
b54d5cb91 Dan Williams              2009-03-25  545  	thread->dsts[i] = NULL;
b54d5cb91 Dan Williams              2009-03-25  546  
e44e0aa3c Dan Williams              2009-03-25  547  	set_user_nice(current, 10);
e44e0aa3c Dan Williams              2009-03-25  548  
b203bd3f6 Ira Snyder                2011-03-03  549  	/*
d1cab34c0 Bartlomiej Zolnierkiewicz 2013-10-18  550  	 * src and dst buffers are freed by ourselves below
b203bd3f6 Ira Snyder                2011-03-03  551  	 */
0776ae7b8 Bartlomiej Zolnierkiewicz 2013-10-18  552  	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
4a776f0aa Haavard Skinnemoen        2008-07-08  553  
86727443a Dan Williams              2013-11-06  554  	ktime = ktime_get();
0a2ff57d6 Nicolas Ferre             2009-07-03  555  	while (!kthread_should_stop()
15b8a8ea1 Andy Shevchenko           2013-03-04  556  	       && !(params->iterations && total_tests >= params->iterations)) {
b54d5cb91 Dan Williams              2009-03-25  557  		struct dma_async_tx_descriptor *tx = NULL;
4076e755d Dan Williams              2013-11-06  558  		struct dmaengine_unmap_data *um;
e9fe1e34b Laura Abbott              2018-04-09  559  		/* total buffer count must fit into u8 */
e9fe1e34b Laura Abbott              2018-04-09  560  		dma_addr_t srcs[255];
4076e755d Dan Williams              2013-11-06  561  		dma_addr_t *dsts;
ede23a586 Andy Shevchenko           2014-10-22  562  		unsigned int src_off, dst_off, len;
d86be86e9 Atsushi Nemoto            2009-01-13  563  
4a776f0aa Haavard Skinnemoen        2008-07-08  564  		total_tests++;
4a776f0aa Haavard Skinnemoen        2008-07-08  565  
fbfb8e1dc Stefan Roese              2017-04-27  566  		/* Check if buffer count fits into map count variable (u8) */
fbfb8e1dc Stefan Roese              2017-04-27  567  		if ((src_cnt + dst_cnt) >= 255) {
fbfb8e1dc Stefan Roese              2017-04-27  568  			pr_err("too many buffers (%d of 255 supported)\n",
fbfb8e1dc Stefan Roese              2017-04-27  569  			       src_cnt + dst_cnt);
fbfb8e1dc Stefan Roese              2017-04-27  570  			break;
fbfb8e1dc Stefan Roese              2017-04-27  571  		}
fbfb8e1dc Stefan Roese              2017-04-27  572  
15b8a8ea1 Andy Shevchenko           2013-03-04  573  		if (1 << align > params->buf_size) {
cfe4f2751 Guennadi Liakhovetski     2009-12-04  574  			pr_err("%u-byte buffer too small for %d-byte alignment\n",
15b8a8ea1 Andy Shevchenko           2013-03-04  575  			       params->buf_size, 1 << align);
cfe4f2751 Guennadi Liakhovetski     2009-12-04  576  			break;
cfe4f2751 Guennadi Liakhovetski     2009-12-04  577  		}
cfe4f2751 Guennadi Liakhovetski     2009-12-04  578  
ede23a586 Andy Shevchenko           2014-10-22  579  		if (params->noverify)
e3b9c3473 Dan Williams              2013-11-06  580  			len = params->buf_size;
ede23a586 Andy Shevchenko           2014-10-22  581  		else
15b8a8ea1 Andy Shevchenko           2013-03-04  582  			len = dmatest_random() % params->buf_size + 1;
ede23a586 Andy Shevchenko           2014-10-22  583  
83544ae9f Dan Williams              2009-09-08  584  		len = (len >> align) << align;
cfe4f2751 Guennadi Liakhovetski     2009-12-04  585  		if (!len)
cfe4f2751 Guennadi Liakhovetski     2009-12-04  586  			len = 1 << align;
ede23a586 Andy Shevchenko           2014-10-22  587  
ede23a586 Andy Shevchenko           2014-10-22  588  		total_len += len;
ede23a586 Andy Shevchenko           2014-10-22  589  
ede23a586 Andy Shevchenko           2014-10-22  590  		if (params->noverify) {
ede23a586 Andy Shevchenko           2014-10-22  591  			src_off = 0;
ede23a586 Andy Shevchenko           2014-10-22  592  			dst_off = 0;
ede23a586 Andy Shevchenko           2014-10-22  593  		} else {
e9405ef08 Sinan Kaya                2016-09-01  594  			start = ktime_get();
15b8a8ea1 Andy Shevchenko           2013-03-04  595  			src_off = dmatest_random() % (params->buf_size - len + 1);
15b8a8ea1 Andy Shevchenko           2013-03-04  596  			dst_off = dmatest_random() % (params->buf_size - len + 1);
cfe4f2751 Guennadi Liakhovetski     2009-12-04  597  
83544ae9f Dan Williams              2009-09-08  598  			src_off = (src_off >> align) << align;
83544ae9f Dan Williams              2009-09-08  599  			dst_off = (dst_off >> align) << align;
83544ae9f Dan Williams              2009-09-08  600  
e3b9c3473 Dan Williams              2013-11-06  601  			dmatest_init_srcs(thread->srcs, src_off, len,
61b5f54d8 Sinan Kaya                2017-06-29  602  					  params->buf_size, is_memset);
e3b9c3473 Dan Williams              2013-11-06  603  			dmatest_init_dsts(thread->dsts, dst_off, len,
61b5f54d8 Sinan Kaya                2017-06-29  604  					  params->buf_size, is_memset);
e9405ef08 Sinan Kaya                2016-09-01  605  
e9405ef08 Sinan Kaya                2016-09-01  606  			diff = ktime_sub(ktime_get(), start);
e9405ef08 Sinan Kaya                2016-09-01  607  			filltime = ktime_add(filltime, diff);
e3b9c3473 Dan Williams              2013-11-06  608  		}
b54d5cb91 Dan Williams              2009-03-25  609  
4076e755d Dan Williams              2013-11-06  610  		um = dmaengine_get_unmap_data(dev->dev, src_cnt + dst_cnt,
4076e755d Dan Williams              2013-11-06  611  					      GFP_KERNEL);
4076e755d Dan Williams              2013-11-06  612  		if (!um) {
4076e755d Dan Williams              2013-11-06  613  			failed_tests++;
4076e755d Dan Williams              2013-11-06  614  			result("unmap data NULL", total_tests,
4076e755d Dan Williams              2013-11-06  615  			       src_off, dst_off, len, ret);
4076e755d Dan Williams              2013-11-06  616  			continue;
4076e755d Dan Williams              2013-11-06  617  		}
4a776f0aa Haavard Skinnemoen        2008-07-08  618  
4076e755d Dan Williams              2013-11-06  619  		um->len = params->buf_size;
4076e755d Dan Williams              2013-11-06  620  		for (i = 0; i < src_cnt; i++) {
745c00daf Dan Williams              2013-12-09  621  			void *buf = thread->srcs[i];
4076e755d Dan Williams              2013-11-06  622  			struct page *pg = virt_to_page(buf);
f62e5f613 Geliang Tang              2017-04-22  623  			unsigned long pg_off = offset_in_page(buf);
4076e755d Dan Williams              2013-11-06  624  
4076e755d Dan Williams              2013-11-06  625  			um->addr[i] = dma_map_page(dev->dev, pg, pg_off,
4076e755d Dan Williams              2013-11-06  626  						   um->len, DMA_TO_DEVICE);
4076e755d Dan Williams              2013-11-06  627  			srcs[i] = um->addr[i] + src_off;
4076e755d Dan Williams              2013-11-06  628  			ret = dma_mapping_error(dev->dev, um->addr[i]);
afde3be12 Andy Shevchenko           2012-12-17  629  			if (ret) {
4076e755d Dan Williams              2013-11-06  630  				dmaengine_unmap_put(um);
872f05c6e Dan Williams              2013-11-06  631  				result("src mapping error", total_tests,
872f05c6e Dan Williams              2013-11-06  632  				       src_off, dst_off, len, ret);
afde3be12 Andy Shevchenko           2012-12-17  633  				failed_tests++;
afde3be12 Andy Shevchenko           2012-12-17  634  				continue;
afde3be12 Andy Shevchenko           2012-12-17  635  			}
4076e755d Dan Williams              2013-11-06  636  			um->to_cnt++;
b54d5cb91 Dan Williams              2009-03-25  637  		}
d86be86e9 Atsushi Nemoto            2009-01-13  638  		/* map with DMA_BIDIRECTIONAL to force writeback/invalidate */
4076e755d Dan Williams              2013-11-06  639  		dsts = &um->addr[src_cnt];
b54d5cb91 Dan Williams              2009-03-25  640  		for (i = 0; i < dst_cnt; i++) {
745c00daf Dan Williams              2013-12-09  641  			void *buf = thread->dsts[i];
4076e755d Dan Williams              2013-11-06  642  			struct page *pg = virt_to_page(buf);
f62e5f613 Geliang Tang              2017-04-22  643  			unsigned long pg_off = offset_in_page(buf);
4076e755d Dan Williams              2013-11-06  644  
4076e755d Dan Williams              2013-11-06  645  			dsts[i] = dma_map_page(dev->dev, pg, pg_off, um->len,
b54d5cb91 Dan Williams              2009-03-25  646  					       DMA_BIDIRECTIONAL);
4076e755d Dan Williams              2013-11-06  647  			ret = dma_mapping_error(dev->dev, dsts[i]);
afde3be12 Andy Shevchenko           2012-12-17  648  			if (ret) {
4076e755d Dan Williams              2013-11-06  649  				dmaengine_unmap_put(um);
872f05c6e Dan Williams              2013-11-06  650  				result("dst mapping error", total_tests,
872f05c6e Dan Williams              2013-11-06  651  				       src_off, dst_off, len, ret);
afde3be12 Andy Shevchenko           2012-12-17  652  				failed_tests++;
afde3be12 Andy Shevchenko           2012-12-17  653  				continue;
afde3be12 Andy Shevchenko           2012-12-17  654  			}
4076e755d Dan Williams              2013-11-06  655  			um->bidi_cnt++;
b54d5cb91 Dan Williams              2009-03-25  656  		}
83544ae9f Dan Williams              2009-09-08  657  
b54d5cb91 Dan Williams              2009-03-25  658  		if (thread->type == DMA_MEMCPY)
b54d5cb91 Dan Williams              2009-03-25  659  			tx = dev->device_prep_dma_memcpy(chan,
4076e755d Dan Williams              2013-11-06  660  							 dsts[0] + dst_off,
4076e755d Dan Williams              2013-11-06  661  							 srcs[0], len, flags);
61b5f54d8 Sinan Kaya                2017-06-29  662  		else if (thread->type == DMA_MEMSET)
61b5f54d8 Sinan Kaya                2017-06-29  663  			tx = dev->device_prep_dma_memset(chan,
61b5f54d8 Sinan Kaya                2017-06-29  664  						dsts[0] + dst_off,
61b5f54d8 Sinan Kaya                2017-06-29  665  						*(thread->srcs[0] + src_off),
61b5f54d8 Sinan Kaya                2017-06-29  666  						len, flags);
b54d5cb91 Dan Williams              2009-03-25  667  		else if (thread->type == DMA_XOR)
b54d5cb91 Dan Williams              2009-03-25  668  			tx = dev->device_prep_dma_xor(chan,
4076e755d Dan Williams              2013-11-06  669  						      dsts[0] + dst_off,
4076e755d Dan Williams              2013-11-06  670  						      srcs, src_cnt,
b54d5cb91 Dan Williams              2009-03-25  671  						      len, flags);
58691d64c Dan Williams              2009-08-29  672  		else if (thread->type == DMA_PQ) {
e9fe1e34b Laura Abbott              2018-04-09  673  			/* dst_cnt can't be more than u8 */
e9fe1e34b Laura Abbott              2018-04-09  674  			dma_addr_t dma_pq[255];
58691d64c Dan Williams              2009-08-29  675  
58691d64c Dan Williams              2009-08-29  676  			for (i = 0; i < dst_cnt; i++)
4076e755d Dan Williams              2013-11-06  677  				dma_pq[i] = dsts[i] + dst_off;
4076e755d Dan Williams              2013-11-06  678  			tx = dev->device_prep_dma_pq(chan, dma_pq, srcs,
94de648d7 Anatolij Gustschin        2010-02-15  679  						     src_cnt, pq_coefs,
58691d64c Dan Williams              2009-08-29  680  						     len, flags);
58691d64c Dan Williams              2009-08-29  681  		}
d86be86e9 Atsushi Nemoto            2009-01-13  682  
d86be86e9 Atsushi Nemoto            2009-01-13  683  		if (!tx) {
4076e755d Dan Williams              2013-11-06  684  			dmaengine_unmap_put(um);
872f05c6e Dan Williams              2013-11-06  685  			result("prep error", total_tests, src_off,
872f05c6e Dan Williams              2013-11-06  686  			       dst_off, len, ret);
d86be86e9 Atsushi Nemoto            2009-01-13  687  			msleep(100);
d86be86e9 Atsushi Nemoto            2009-01-13  688  			failed_tests++;
d86be86e9 Atsushi Nemoto            2009-01-13  689  			continue;
d86be86e9 Atsushi Nemoto            2009-01-13  690  		}
e44e0aa3c Dan Williams              2009-03-25  691  
6f6a23a21 Adam Wallis               2017-11-27  692  		done->done = false;
e44e0aa3c Dan Williams              2009-03-25  693  		tx->callback = dmatest_callback;
6f6a23a21 Adam Wallis               2017-11-27  694  		tx->callback_param = done;
d86be86e9 Atsushi Nemoto            2009-01-13  695  		cookie = tx->tx_submit(tx);
d86be86e9 Atsushi Nemoto            2009-01-13  696  
4a776f0aa Haavard Skinnemoen        2008-07-08  697  		if (dma_submit_error(cookie)) {
4076e755d Dan Williams              2013-11-06  698  			dmaengine_unmap_put(um);
872f05c6e Dan Williams              2013-11-06  699  			result("submit error", total_tests, src_off,
872f05c6e Dan Williams              2013-11-06  700  			       dst_off, len, ret);
4a776f0aa Haavard Skinnemoen        2008-07-08  701  			msleep(100);
4a776f0aa Haavard Skinnemoen        2008-07-08  702  			failed_tests++;
4a776f0aa Haavard Skinnemoen        2008-07-08  703  			continue;
4a776f0aa Haavard Skinnemoen        2008-07-08  704  		}
b54d5cb91 Dan Williams              2009-03-25  705  		dma_async_issue_pending(chan);
4a776f0aa Haavard Skinnemoen        2008-07-08  706  
6f6a23a21 Adam Wallis               2017-11-27  707  		wait_event_freezable_timeout(thread->done_wait, done->done,
15b8a8ea1 Andy Shevchenko           2013-03-04  708  					     msecs_to_jiffies(params->timeout));
981ed70d8 Guennadi Liakhovetski     2011-08-18  709  
e44e0aa3c Dan Williams              2009-03-25  710  		status = dma_async_is_tx_complete(chan, cookie, NULL, NULL);
4a776f0aa Haavard Skinnemoen        2008-07-08  711  
6f6a23a21 Adam Wallis               2017-11-27  712  		if (!done->done) {
4076e755d Dan Williams              2013-11-06  713  			dmaengine_unmap_put(um);
872f05c6e Dan Williams              2013-11-06  714  			result("test timed out", total_tests, src_off, dst_off,
95019c8c5 Andy Shevchenko           2013-03-04  715  			       len, 0);
4a776f0aa Haavard Skinnemoen        2008-07-08  716  			failed_tests++;
4a776f0aa Haavard Skinnemoen        2008-07-08  717  			continue;
19e9f99f2 Vinod Koul                2013-10-16  718  		} else if (status != DMA_COMPLETE) {
4076e755d Dan Williams              2013-11-06  719  			dmaengine_unmap_put(um);
872f05c6e Dan Williams              2013-11-06  720  			result(status == DMA_ERROR ?
872f05c6e Dan Williams              2013-11-06  721  			       "completion error status" :
872f05c6e Dan Williams              2013-11-06  722  			       "completion busy status", total_tests, src_off,
872f05c6e Dan Williams              2013-11-06  723  			       dst_off, len, ret);
e44e0aa3c Dan Williams              2009-03-25  724  			failed_tests++;
e44e0aa3c Dan Williams              2009-03-25  725  			continue;
4a776f0aa Haavard Skinnemoen        2008-07-08  726  		}
e44e0aa3c Dan Williams              2009-03-25  727  
4076e755d Dan Williams              2013-11-06  728  		dmaengine_unmap_put(um);
4a776f0aa Haavard Skinnemoen        2008-07-08  729  
e3b9c3473 Dan Williams              2013-11-06  730  		if (params->noverify) {
50137a7df Dan Williams              2013-11-08  731  			verbose_result("test passed", total_tests, src_off,
50137a7df Dan Williams              2013-11-08  732  				       dst_off, len, 0);
e3b9c3473 Dan Williams              2013-11-06  733  			continue;
e3b9c3473 Dan Williams              2013-11-06  734  		}
4a776f0aa Haavard Skinnemoen        2008-07-08  735  
e9405ef08 Sinan Kaya                2016-09-01  736  		start = ktime_get();
872f05c6e Dan Williams              2013-11-06  737  		pr_debug("%s: verifying source buffer...\n", current->comm);
e3b9c3473 Dan Williams              2013-11-06  738  		error_count = dmatest_verify(thread->srcs, 0, src_off,
61b5f54d8 Sinan Kaya                2017-06-29  739  				0, PATTERN_SRC, true, is_memset);
7b6101782 Dan Williams              2013-11-06  740  		error_count += dmatest_verify(thread->srcs, src_off,
7b6101782 Dan Williams              2013-11-06  741  				src_off + len, src_off,
61b5f54d8 Sinan Kaya                2017-06-29  742  				PATTERN_SRC | PATTERN_COPY, true, is_memset);
7b6101782 Dan Williams              2013-11-06  743  		error_count += dmatest_verify(thread->srcs, src_off + len,
7b6101782 Dan Williams              2013-11-06  744  				params->buf_size, src_off + len,
61b5f54d8 Sinan Kaya                2017-06-29  745  				PATTERN_SRC, true, is_memset);
7b6101782 Dan Williams              2013-11-06  746  
872f05c6e Dan Williams              2013-11-06  747  		pr_debug("%s: verifying dest buffer...\n", current->comm);
7b6101782 Dan Williams              2013-11-06  748  		error_count += dmatest_verify(thread->dsts, 0, dst_off,
61b5f54d8 Sinan Kaya                2017-06-29  749  				0, PATTERN_DST, false, is_memset);
61b5f54d8 Sinan Kaya                2017-06-29  750  
7b6101782 Dan Williams              2013-11-06  751  		error_count += dmatest_verify(thread->dsts, dst_off,
7b6101782 Dan Williams              2013-11-06  752  				dst_off + len, src_off,
61b5f54d8 Sinan Kaya                2017-06-29  753  				PATTERN_SRC | PATTERN_COPY, false, is_memset);
61b5f54d8 Sinan Kaya                2017-06-29  754  
7b6101782 Dan Williams              2013-11-06  755  		error_count += dmatest_verify(thread->dsts, dst_off + len,
7b6101782 Dan Williams              2013-11-06  756  				params->buf_size, dst_off + len,
61b5f54d8 Sinan Kaya                2017-06-29  757  				PATTERN_DST, false, is_memset);
4a776f0aa Haavard Skinnemoen        2008-07-08  758  
e9405ef08 Sinan Kaya                2016-09-01  759  		diff = ktime_sub(ktime_get(), start);
e9405ef08 Sinan Kaya                2016-09-01  760  		comparetime = ktime_add(comparetime, diff);
e9405ef08 Sinan Kaya                2016-09-01  761  
4a776f0aa Haavard Skinnemoen        2008-07-08  762  		if (error_count) {
872f05c6e Dan Williams              2013-11-06  763  			result("data error", total_tests, src_off, dst_off,
95019c8c5 Andy Shevchenko           2013-03-04  764  			       len, error_count);
4a776f0aa Haavard Skinnemoen        2008-07-08  765  			failed_tests++;
4a776f0aa Haavard Skinnemoen        2008-07-08  766  		} else {
50137a7df Dan Williams              2013-11-08  767  			verbose_result("test passed", total_tests, src_off,
50137a7df Dan Williams              2013-11-08  768  				       dst_off, len, 0);
4a776f0aa Haavard Skinnemoen        2008-07-08  769  		}
4a776f0aa Haavard Skinnemoen        2008-07-08  770  	}
e9405ef08 Sinan Kaya                2016-09-01  771  	ktime = ktime_sub(ktime_get(), ktime);
e9405ef08 Sinan Kaya                2016-09-01  772  	ktime = ktime_sub(ktime, comparetime);
e9405ef08 Sinan Kaya                2016-09-01  773  	ktime = ktime_sub(ktime, filltime);
e9405ef08 Sinan Kaya                2016-09-01  774  	runtime = ktime_to_us(ktime);
4a776f0aa Haavard Skinnemoen        2008-07-08  775  
4a776f0aa Haavard Skinnemoen        2008-07-08  776  	ret = 0;
8e1f50d74 Andy Shevchenko           2014-08-22  777  err_dstbuf:
d64816086 Dave Jiang                2016-11-29  778  	for (i = 0; thread->udsts[i]; i++)
d64816086 Dave Jiang                2016-11-29  779  		kfree(thread->udsts[i]);
d64816086 Dave Jiang                2016-11-29  780  	kfree(thread->udsts);
d64816086 Dave Jiang                2016-11-29  781  err_udsts:
b54d5cb91 Dan Williams              2009-03-25  782  	kfree(thread->dsts);
b54d5cb91 Dan Williams              2009-03-25  783  err_dsts:
8e1f50d74 Andy Shevchenko           2014-08-22  784  err_srcbuf:
d64816086 Dave Jiang                2016-11-29  785  	for (i = 0; thread->usrcs[i]; i++)
d64816086 Dave Jiang                2016-11-29  786  		kfree(thread->usrcs[i]);
d64816086 Dave Jiang                2016-11-29  787  	kfree(thread->usrcs);
d64816086 Dave Jiang                2016-11-29  788  err_usrcs:
b54d5cb91 Dan Williams              2009-03-25  789  	kfree(thread->srcs);
b54d5cb91 Dan Williams              2009-03-25  790  err_srcs:
945b5af3c Andy Shevchenko           2013-03-04  791  	kfree(pq_coefs);
945b5af3c Andy Shevchenko           2013-03-04  792  err_thread_type:
86727443a Dan Williams              2013-11-06  793  	pr_info("%s: summary %u tests, %u failures %llu iops %llu KB/s (%d)\n",
86727443a Dan Williams              2013-11-06  794  		current->comm, total_tests, failed_tests,
86727443a Dan Williams              2013-11-06  795  		dmatest_persec(runtime, total_tests),
86727443a Dan Williams              2013-11-06  796  		dmatest_KBs(runtime, total_len), ret);
0a2ff57d6 Nicolas Ferre             2009-07-03  797  
9704efaa5 Viresh Kumar              2011-07-29  798  	/* terminate all transfers on specified channels */
6f6a23a21 Adam Wallis               2017-11-27  799  	if (ret || failed_tests)
944ea4dd3 Jon Mason                 2012-11-11  800  		dmaengine_terminate_all(chan);
5e034f7b6 Shiraz Hashim             2012-11-09  801  
3e5ccd866 Andy Shevchenko           2013-03-04  802  	thread->done = true;
2d88ce76e Dan Williams              2013-11-06  803  	wake_up(&thread_wait);
0a2ff57d6 Nicolas Ferre             2009-07-03  804  
4a776f0aa Haavard Skinnemoen        2008-07-08  805  	return ret;
4a776f0aa Haavard Skinnemoen        2008-07-08 @806  }
4a776f0aa Haavard Skinnemoen        2008-07-08  807  

:::::: The code at line 806 was first introduced by commit
:::::: 4a776f0aa922a552460192c07b56f4fe9cd82632 dmatest: Simple DMA memcpy test client

:::::: TO: Haavard Skinnemoen <hskinnemoen@atmel.com>
:::::: CC: Dan Williams <dan.j.williams@intel.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--envbJBWh7q8WU6mo
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--envbJBWh7q8WU6mo--
