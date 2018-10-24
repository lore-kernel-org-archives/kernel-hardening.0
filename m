Subject: Re: [PATCH 14/17] prmem: llist, hlist, both plain and rcu
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
 <20181023213504.28905-15-igor.stoppa@huawei.com>
 <1634210774.446.1540381072927.JavaMail.zimbra@efficios.com>
From: Igor Stoppa <igor.stoppa@gmail.com>
Message-ID: <243a8ff2-889c-089f-a1ff-c882933ca5c3@gmail.com>
Date: Wed, 24 Oct 2018 17:03:01 +0300
MIME-Version: 1.0
In-Reply-To: <1634210774.446.1540381072927.JavaMail.zimbra@efficios.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, kernel-hardening@lists.openwall.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, igor stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, rostedt <rostedt@goodmis.org>, Lai Jiangshan <jiangshanlai@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 24/10/18 14:37, Mathieu Desnoyers wrote:

> I could not find a description of the overall context of this patch
> (e.g. a patch 00/17 ?) that would explain the attack vectors this aims
> to protect against.

Apologies, I have to admit I was a bit baffled about what to do: the 
patchset spans across several subsystems and I was reluctant at spamming 
all the mailing lists.

I was hoping that by CC-ing kernel.org, the explicit recipients would 
get both the mail directly intended for them (as subsystem 
maintainers/supporters) and the rest.

The next time I'll err in the opposite direction.

In the meanwhile, please find the whole set here:

https://www.openwall.com/lists/kernel-hardening/2018/10/23/3

> This might help figuring out whether this added complexity in the core
> kernel is worth it.

I hope it will.

> Also, is it the right approach to duplicate existing APIs, or should we
> rather hook into page fault handlers and let the kernel do those "shadow"
> mappings under the hood ?

This question is probably a good candidate for the small Q&A section I 
have in the 00/17.


> Adding a new GFP flags for dynamic allocation, and a macro mapping to
> a section attribute might suffice for allocation or definition of such
> mostly-read-only/seldom-updated data.

I think what you are proposing makes sense from a pure hardening 
standpoint. From a more defensive one, I'd rather minimise the chances 
of giving a free pass to an attacker.

Maybe there is a better implementation of this, than what I have in 
mind. But, based on my current understanding of what you are describing, 
there would be few issues:

1) where would the pool go? The pool is a way to manage multiple vmas 
and express common property they share. Even before a vma is associated 
to the pool.

2) there would be more code that can seamlessly deal with both protected 
and regular data. Based on what? Some parameter, I suppose.
That parameter would be the new target.
If the code is "duplicated", as you say, the actual differences are 
baked in at compile time. The "duplication" would also allow to have 
always inlined functions for write-rare and leave more freedom to the 
compiler for their non-protected version.

Besides, I think the separate wr version also makes it very clear, to 
the user of the API, that there will be a price to pay, in terms of 
performance. The more seamlessly alternative might make this price less 
obvious.

--
igor
