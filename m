Date: Fri, 26 Oct 2018 11:38:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 14/17] prmem: llist, hlist, both plain and rcu
Message-ID: <20181026093804.GD3126@worktop.c.hoisthospitality.com>
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
 <20181023213504.28905-15-igor.stoppa@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181023213504.28905-15-igor.stoppa@huawei.com>
To: Igor Stoppa <igor.stoppa@gmail.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, kernel-hardening@lists.openwall.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, igor.stoppa@huawei.com, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 24, 2018 at 12:35:01AM +0300, Igor Stoppa wrote:
> In some cases, all the data needing protection can be allocated from a pool
> in one go, as directly writable, then initialized and protected.
> The sequence is relatively short and it's acceptable to leave the entire
> data set unprotected.
> 
> In other cases, this is not possible, because the data will trickle over
> a relatively long period of time, in a non predictable way, possibly for
> the entire duration of the operations.
> 
> For these cases, the safe approach is to have the memory already write
> protected, when allocated. However, this will require replacing any
> direct assignment with calls to functions that can perform write rare.
> 
> Since lists are one of the most commonly used data structures in kernel,
> they are a the first candidate for receiving write rare extensions.
> 
> This patch implements basic functionality for altering said lists.
> 
> Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Kate Stewart <kstewart@linuxfoundation.org>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: Philippe Ombredanne <pombredanne@nexb.com>
> CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> CC: Josh Triplett <josh@joshtriplett.org>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Lai Jiangshan <jiangshanlai@gmail.com>
> CC: linux-kernel@vger.kernel.org
> ---
>  MAINTAINERS            |   1 +
>  include/linux/prlist.h | 934 +++++++++++++++++++++++++++++++++++++++++

I'm not at all sure I understand the Changelog, or how it justifies
duplicating almost 1k lines of code.

Sure lists aren't the most complicated thing we have, but duplicating
that much is still very _very_ bad form. Why are we doing this?
