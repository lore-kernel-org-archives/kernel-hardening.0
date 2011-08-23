Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 23 Aug 2011 14:44:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20110823144430.75315ce8.akpm@linux-foundation.org>
In-Reply-To: <20110804162009.GA2469@albatros>
References: <20110804162009.GA2469@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] proc: fix races of /proc/PID/{fd/,fdinfo/,fdinfo/*}
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com, Al Viro <viro@zeniv.linux.org.uk>, David Rientjes <rientjes@google.com>, Stephen Wilson <wilsons@start.ca>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-kernel@vger.kernel.org, security@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 4 Aug 2011 20:20:09 +0400
Vasiliy Kulikov <segoon@openwall.com> wrote:

> fd* files are restricted to the task's owner, but keeping opened procfs
> file descriptors makes it possible to violate the permission model.
> Keeping fdinfo/* may disclosure current position and flags, keeping
> fdinfo/ and fd/ may disclosure number of opened files.
> 
> Used existing (un)lock_trace functions to deal with the race.

what race.

When fixing a bug, please completely, utterly and exhaustively describe
the bug!

> CC: Stable Tree <stable@kernel.org>

And when cc'ing -stable, please make it very clear why you consider the
bug sufficiently serious to warant mackporting the fix into earlier
kernels.
