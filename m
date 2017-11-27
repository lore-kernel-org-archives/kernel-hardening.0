Date: Tue, 28 Nov 2017 09:31:18 +1100 (AEDT)
From: James Morris <james.l.morris@oracle.com>
In-Reply-To: <20171128.041426.801732093971324601.davem@davemloft.net>
Message-ID: <alpine.LFD.2.20.1711280924350.11830@localhost>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>        <CA+55aFwFEzEU9ci=mFZprjzrhG0P0XgXgqhBSWSv7vFWEAw6rQ@mail.gmail.com> <20171128.041426.801732093971324601.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v5 next 0/5] Improve Module autoloading infrastructure
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, tixxdz@gmail.com, keescook@chromium.org, luto@kernel.org, akpm@linux-foundation.org, mcgrof@kernel.org, ben.hutchings@codethink.co.uk, solar@openwall.com, serge@hallyn.com, jeyu@kernel.org, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, corbet@lwn.net, mingo@kernel.org, netdev@vger.kernel.org, peterz@infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 28 Nov 2017, David Miller wrote:

> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Mon, 27 Nov 2017 10:41:30 -0800
> 
> > What are the real life use-cases for normal users having modules
> > auto-load?
> 
> User opens SCTP socket, SCTP protocol module loads.
> 
> People build test cases via namespaces, and in that namespaces normal
> users can setup virtual tunnel devices themselves, and those configure
> operations can bring the tunnel module in.

What about implementing a white list of modules which are able to be 
loaded by unprivileged users?

Then, Linus' solution would look something like:

	va_start(args, fmt);
	ret = vsnprintf(module_name, MODULE_NAME_LEN, fmt, args);
	va_end(args);

	if (WARN_ON_ONCE(!capable(CAP_SYS_MODULE) ||
                         !capable(CAP_SYS_ADMIN) ||
                         !capable(CAP_NET_ADMIN) ||
                         !unprivileged_autoload(module_name)))
		return -EPERM;



-- 
James Morris
<james.l.morris@oracle.com>
