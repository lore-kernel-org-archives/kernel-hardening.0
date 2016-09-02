Reply-To: kernel-hardening@lists.openwall.com
References: <1456496467-14247-1-git-send-email-juerg.haefliger@hpe.com>
 <20160902113909.32631-1-juerg.haefliger@hpe.com>
 <20160902113909.32631-3-juerg.haefliger@hpe.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <57C9E37A.9070805@intel.com>
Date: Fri, 2 Sep 2016 13:39:22 -0700
MIME-Version: 1.0
In-Reply-To: <20160902113909.32631-3-juerg.haefliger@hpe.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC PATCH v2 2/3] xpfo: Only put previous userspace pages into
 the hot cache
To: Juerg Haefliger <juerg.haefliger@hpe.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, linux-x86_64@vger.kernel.org
Cc: vpk@cs.columbia.edu
List-ID: <kernel-hardening.lists.openwall.com>

On 09/02/2016 04:39 AM, Juerg Haefliger wrote:
> Allocating a page to userspace that was previously allocated to the
> kernel requires an expensive TLB shootdown. To minimize this, we only
> put non-kernel pages into the hot cache to favor their allocation.

But kernel allocations do allocate from these pools, right?  Does this
just mean that kernel allocations usually have to pay the penalty to
convert a page?

So, what's the logic here?  You're assuming that order-0 kernel
allocations are more rare than allocations for userspace?
