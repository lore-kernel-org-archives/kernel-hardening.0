Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 27 Sep 2011 15:47:24 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
In-Reply-To: <alpine.DEB.2.00.1109271328151.24402@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1109271546320.13797@router.home>
References: <20110927175453.GA3393@albatros> <20110927175642.GA3432@albatros> <20110927193810.GA5416@albatros> <alpine.DEB.2.00.1109271459180.13797@router.home> <alpine.DEB.2.00.1109271328151.24402@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH 2/2] mm: restrict access to /proc/meminfo
To: David Rientjes <rientjes@google.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>, kernel-hardening@lists.openwall.com, Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Kees Cook <kees@ubuntu.com>, Dave Hansen <dave@linux.vnet.ibm.com>, Valdis.Kletnieks@vt.edu, Linus Torvalds <torvalds@linux-foundation.org>, Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 27 Sep 2011, David Rientjes wrote:

> It'll turn into another one of our infinite number of capabilities.  Does
> anything actually care about statistics at KB granularity these days?

Changing that to MB may also break things. It may be better to have
consistent system for access control to memory management counters that
are not related to a process.
