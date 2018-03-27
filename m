Date: Wed, 28 Mar 2018 02:39:15 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v6] kernel.h: Retain constant expression output for
 max()/min()
Message-ID: <201803280107.bZw8jIAt%fengguang.wu@intel.com>
References: <20180326221554.GA45166@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180326221554.GA45166@beast>
To: Kees Cook <keescook@chromium.org>
Cc: kbuild-all@01.org, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Martin Uecker <Martin.Uecker@med.uni-goettingen.de>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Kees,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v4.16-rc7 next-20180327]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Kees-Cook/kernel-h-Retain-constant-expression-output-for-max-min/20180327-110916
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


vim +124 drivers/infiniband/hw/vmw_pvrdma/pvrdma_doorbell.c

29c8d9eb Adit Ranadive 2016-10-02  114  
29c8d9eb Adit Ranadive 2016-10-02  115  void pvrdma_uar_free(struct pvrdma_dev *dev, struct pvrdma_uar_map *uar)
29c8d9eb Adit Ranadive 2016-10-02  116  {
29c8d9eb Adit Ranadive 2016-10-02  117  	struct pvrdma_id_table *tbl = &dev->uar_table.tbl;
29c8d9eb Adit Ranadive 2016-10-02  118  	unsigned long flags;
29c8d9eb Adit Ranadive 2016-10-02  119  	u32 obj;
29c8d9eb Adit Ranadive 2016-10-02  120  
29c8d9eb Adit Ranadive 2016-10-02  121  	obj = uar->index & (tbl->max - 1);
29c8d9eb Adit Ranadive 2016-10-02  122  	spin_lock_irqsave(&tbl->lock, flags);
29c8d9eb Adit Ranadive 2016-10-02  123  	clear_bit(obj, tbl->table);
29c8d9eb Adit Ranadive 2016-10-02 @124  	tbl->last = min(tbl->last, obj);

:::::: The code at line 124 was first introduced by commit
:::::: 29c8d9eba550c6d73d17cc1618a9f5f2a7345aa1 IB: Add vmw_pvrdma driver

:::::: TO: Adit Ranadive <aditr@vmware.com>
:::::: CC: Doug Ledford <dledford@redhat.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
