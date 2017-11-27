Date: Tue, 28 Nov 2017 04:14:26 +0900 (KST)
Message-Id: <20171128.041426.801732093971324601.davem@davemloft.net>
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFwFEzEU9ci=mFZprjzrhG0P0XgXgqhBSWSv7vFWEAw6rQ@mail.gmail.com>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
	<CA+55aFwFEzEU9ci=mFZprjzrhG0P0XgXgqhBSWSv7vFWEAw6rQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v5 next 0/5] Improve Module autoloading infrastructure
To: torvalds@linux-foundation.org
Cc: tixxdz@gmail.com, keescook@chromium.org, luto@kernel.org, akpm@linux-foundation.org, mcgrof@kernel.org, james.l.morris@oracle.com, ben.hutchings@codethink.co.uk, solar@openwall.com, serge@hallyn.com, jeyu@kernel.org, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, corbet@lwn.net, mingo@kernel.org, netdev@vger.kernel.org, peterz@infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 27 Nov 2017 10:41:30 -0800

> What are the real life use-cases for normal users having modules
> auto-load?

User opens SCTP socket, SCTP protocol module loads.

People build test cases via namespaces, and in that namespaces normal
users can setup virtual tunnel devices themselves, and those configure
operations can bring the tunnel module in.
