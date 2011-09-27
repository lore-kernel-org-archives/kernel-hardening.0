Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 27 Sep 2011 11:27:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
In-Reply-To: <20110927175642.GA3432@albatros>
Message-ID: <alpine.DEB.2.00.1109271122480.17876@chino.kir.corp.google.com>
References: <20110927175453.GA3393@albatros> <20110927175642.GA3432@albatros>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH 2/2] mm: restrict access to /proc/meminfo
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com, Christoph Lameter <cl@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Kees Cook <kees@ubuntu.com>, Dave Hansen <dave@linux.vnet.ibm.com>, Valdis.Kletnieks@vt.edu, Linus Torvalds <torvalds@linux-foundation.org>, Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 27 Sep 2011, Vasiliy Kulikov wrote:

> /proc/meminfo stores information related to memory pages usage, which
> may be used to monitor the number of objects in specific caches (and/or
> the changes of these numbers).  This might reveal private information
> similar to /proc/slabinfo infoleaks.  To remove the infoleak, just
> restrict meminfo to root.  If it is used by unprivileged daemons,
> meminfo permissions can be altered the same way as slabinfo:
> 
>     groupadd meminfo
>     usermod -a -G meminfo $MONITOR_USER
>     chmod g+r /proc/meminfo
>     chgrp meminfo /proc/meminfo
> 

I guess the side-effect of this is that users without root will no longer 
report VM issues where "there's tons of freeable memory but my task got 
killed", "there's swap available but is unutilized in lowmem situations", 
etc. :)

Seriously, though, can't we just change the granularity of /proc/meminfo 
to be MB instead of KB or at least provide a separate file that is 
readable that does that?  I can understand not exporting information on a 
page-level granularity but not giving users a way to determine the amount 
of free memory is a little extreme.
