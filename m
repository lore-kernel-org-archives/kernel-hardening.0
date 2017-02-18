Date: Sat, 18 Feb 2017 14:32:21 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
Message-ID: <alpine.DEB.2.20.1702181431020.3112@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v2 3/3] Make vmbus register arguments read-only (fwd)
To: Eddie Kovsky <ewk@edkovsky.org>
Cc: jeyu@redhat.com, rusty@rustcorp.com.au, keescook@chromium.org, kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

It looks like brace are missing on the if on lines 1057-1059.

julia



---------- Forwarded message ----------
Date: Sat, 18 Feb 2017 15:46:30 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: kbuild@01.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v2 3/3] Make vmbus register arguments read-only

CC: kbuild-all@01.org
In-Reply-To: <20170218055844.1457-4-ewk@edkovsky.org>

Hi Eddie,

[auto build test WARNING on linus/master]
[also build test WARNING on v4.10-rc8 next-20170217]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Eddie-Kovsky/provide-check-for-ro_after_init-memory-sections/20170218-141040
:::::: branch date: 2 hours ago
:::::: commit date: 2 hours ago

>> drivers/hv/vmbus_drv.c:1058:2-45: code aligned with following code on line 1059
   drivers/hv/vmbus_drv.c:1129:2-45: code aligned with following code on line 1130

git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 1fed72d7adca008d13119f00c095e1e379f319a1
vim +1058 drivers/hv/vmbus_drv.c

cf6a2eac drivers/hv/vmbus_drv.c         K. Y. Srinivasan   2011-12-01  1052  	ret = vmbus_exists();
cf6a2eac drivers/hv/vmbus_drv.c         K. Y. Srinivasan   2011-12-01  1053  	if (ret < 0)
cf6a2eac drivers/hv/vmbus_drv.c         K. Y. Srinivasan   2011-12-01  1054  		return ret;
cf6a2eac drivers/hv/vmbus_drv.c         K. Y. Srinivasan   2011-12-01  1055
1fed72d7 drivers/hv/vmbus_drv.c         Eddie Kovsky       2017-02-17  1056  	ret = kernel_ro_address(&hv_driver);
1fed72d7 drivers/hv/vmbus_drv.c         Eddie Kovsky       2017-02-17  1057  	if (ret < 1)
1fed72d7 drivers/hv/vmbus_drv.c         Eddie Kovsky       2017-02-17 @1058  		pr_err("Module address is not read-only.");
1fed72d7 drivers/hv/vmbus_drv.c         Eddie Kovsky       2017-02-17 @1059  		return ret;
1fed72d7 drivers/hv/vmbus_drv.c         Eddie Kovsky       2017-02-17  1060
768fa219 drivers/staging/hv/vmbus_drv.c Greg Kroah-Hartman 2011-08-25  1061  	hv_driver->driver.name = hv_driver->name;
768fa219 drivers/staging/hv/vmbus_drv.c Greg Kroah-Hartman 2011-08-25  1062  	hv_driver->driver.owner = owner;

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
