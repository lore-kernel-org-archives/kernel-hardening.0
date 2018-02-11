Subject: Re: [PATCH 2/6] genalloc: selftest
References: <20180204164732.28241-3-igor.stoppa@huawei.com>
 <201802080423.jTtuTsUK%fengguang.wu@intel.com>
From: Igor Stoppa <igor.stoppa@huawei.com>
Message-ID: <78f8d652-220f-05e9-ed69-39108517531c@huawei.com>
Date: Sun, 11 Feb 2018 04:01:25 +0200
MIME-Version: 1.0
In-Reply-To: <201802080423.jTtuTsUK%fengguang.wu@intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, jglisse@redhat.com, keescook@chromium.org, mhocko@kernel.org, labbott@redhat.com, hch@infradead.org, willy@infradead.org, cl@linux.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>



On 07/02/18 22:25, kbuild test robot wrote:

[...]

>>> lib/genalloc-selftest.c:17:10: fatal error: asm/set_memory.h: No such file or directory
>     #include <asm/set_memory.h>

This header is unnecessary and will be removed.

--
igor
