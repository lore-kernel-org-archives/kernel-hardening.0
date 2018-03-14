Date: Wed, 14 Mar 2018 05:25:12 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 6/8] Pmalloc selftest
Message-ID: <20180314122512.GF29631@bombadil.infradead.org>
References: <20180313214554.28521-1-igor.stoppa@huawei.com>
 <20180313214554.28521-7-igor.stoppa@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180313214554.28521-7-igor.stoppa@huawei.com>
To: Igor Stoppa <igor.stoppa@huawei.com>
Cc: david@fromorbit.com, rppt@linux.vnet.ibm.com, keescook@chromium.org, mhocko@kernel.org, labbott@redhat.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 13, 2018 at 11:45:52PM +0200, Igor Stoppa wrote:
> Add basic self-test functionality for pmalloc.

Here're some additional tests for your test-suite:

	for (i = 1; i; i *= 2)
		pzalloc(pool, i - 1, GFP_KERNEL);
