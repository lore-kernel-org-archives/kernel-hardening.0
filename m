Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 28 Sep 2011 21:52:35 +0100
From: Alan Cox <alan@linux.intel.com>
Message-ID: <20110928215235.05d4f2e5@bob.linux.org.uk>
In-Reply-To: <1317241905.16137.516.camel@nimitz>
References: <20110927175453.GA3393@albatros>
	<20110927175642.GA3432@albatros>
	<20110927193810.GA5416@albatros>
	<alpine.DEB.2.00.1109271459180.13797@router.home>
	<alpine.DEB.2.00.1109271328151.24402@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1109271546320.13797@router.home>
	<1317241905.16137.516.camel@nimitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 2/2] mm: restrict access to /proc/meminfo
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Vasiliy Kulikov <segoon@openwall.com>, kernel-hardening@lists.openwall.com, Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Kees Cook <kees@ubuntu.com>, Valdis.Kletnieks@vt.edu, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 28 Sep 2011 13:31:45 -0700
Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> On Tue, 2011-09-27 at 15:47 -0500, Christoph Lameter wrote:
> > On Tue, 27 Sep 2011, David Rientjes wrote:
> > > It'll turn into another one of our infinite number of
> > > capabilities.  Does anything actually care about statistics at KB
> > > granularity these days?
> > 
> > Changing that to MB may also break things. It may be better to have
> > consistent system for access control to memory management counters
> > that are not related to a process.
> 
> We could also just _effectively_ make it output in MB:
> 
> 	foo = foo & ~(1<<20)

I do not think that does what you intend 8)

I do like the idea - it avoids any interfaces vanishing and surprise
breakages while only CAP_SYS_whatever needs the real numbers
