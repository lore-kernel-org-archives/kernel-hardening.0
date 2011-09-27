Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 27 Sep 2011 13:33:24 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
In-Reply-To: <alpine.DEB.2.00.1109271459180.13797@router.home>
Message-ID: <alpine.DEB.2.00.1109271328151.24402@chino.kir.corp.google.com>
References: <20110927175453.GA3393@albatros> <20110927175642.GA3432@albatros> <20110927193810.GA5416@albatros> <alpine.DEB.2.00.1109271459180.13797@router.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH 2/2] mm: restrict access to /proc/meminfo
To: Christoph Lameter <cl@gentwo.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>, kernel-hardening@lists.openwall.com, Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Kees Cook <kees@ubuntu.com>, Dave Hansen <dave@linux.vnet.ibm.com>, Valdis.Kletnieks@vt.edu, Linus Torvalds <torvalds@linux-foundation.org>, Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 27 Sep 2011, Christoph Lameter wrote:

> Viewing free memory is usually necessary to check on reclaim activities
> (things otherwise operating normally). "free" memory (in the sense of the
> memory that an application can still allocate) is not really displayed by
> free. Wish we had a new free that avoids all the misinterpretations.
> 
> Meminfo is also requires by vmstat.
> 

Even with the patch, you could still get all this information by summing 
up the per-node meminfo in /sys/devices/system/node/nodeX/meminfo.  
Non-root users certainly need to be able to use things like numactl and be 
able to specify their own mempolicies for NUMA machines, so limiting basic 
memory state information isn't going to work.

I'd much rather just convert everything to use MB rather than KB so you 
can't determine things at a page level.  I think that gets us much closer 
to what the patch is intending to restrict.  But I also expect some 
breakage from things that just expect meminfo to be in KB units without 
parsing what the kernel is exporting.

> If we want to go down this route then we need some sort of diagnostic
> group that a user must be part of in order to allow viewing of basic
> memory statistics.
> 

It'll turn into another one of our infinite number of capabilities.  Does 
anything actually care about statistics at KB granularity these days?
