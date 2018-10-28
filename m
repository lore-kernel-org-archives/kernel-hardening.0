Date: Sun, 28 Oct 2018 05:52:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 14/17] prmem: llist, hlist, both plain and rcu
Message-ID: <20181028055233.08fd81b0@vmware.local.home>
In-Reply-To: <243a8ff2-889c-089f-a1ff-c882933ca5c3@gmail.com>
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
	<20181023213504.28905-15-igor.stoppa@huawei.com>
	<1634210774.446.1540381072927.JavaMail.zimbra@efficios.com>
	<243a8ff2-889c-089f-a1ff-c882933ca5c3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Igor Stoppa <igor.stoppa@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, kernel-hardening@lists.openwall.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, igor stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Lai Jiangshan <jiangshanlai@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 24 Oct 2018 17:03:01 +0300
Igor Stoppa <igor.stoppa@gmail.com> wrote:

> I was hoping that by CC-ing kernel.org, the explicit recipients would 
> get both the mail directly intended for them (as subsystem 
> maintainers/supporters) and the rest.
> 
> The next time I'll err in the opposite direction.

Please don't.

> 
> In the meanwhile, please find the whole set here:
> 
> https://www.openwall.com/lists/kernel-hardening/2018/10/23/3

Note, it is critical that every change log stands on its own. You do
not need to Cc the entire patch set to everyone. Each patch should have
enough information in it to know exactly what the patch does.

It's OK if each change log has duplicate information from other
patches. The important part is that one should be able to look at the
change log of a specific patch and understand exactly what the patch is
doing.

This is because 5 years from now, if someone does a git blame and comes
up with this commit, they wont have access to the patch series. All
they will have is this single commit log to explain why these changes
were done.

If a change log depends on other commits for context, it is
insufficient.

Thanks,

-- Steve
