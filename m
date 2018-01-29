Date: Mon, 29 Jan 2018 16:21:37 +0100
From: Solar Designer <solar@openwall.com>
Subject: list name prefix
Message-ID: <20180129152137.GA21423@openwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

Even though at least per my Twitter poll most people prefer mailing
lists to introduce [list name] prefix into message Subjects:

https://twitter.com/solardiz/status/957692620477779969

I am going to disable this for kernel-hardening on Kees Cook's request.
Kees' rationale is "to avoid making grumpy maintainers even more
grumpy", referring to the annoyance the [kernel-hardening] prefix is
causing to Linux kernel subsystem maintainers receiving messages via
other Linux kernel development lists that kernel-hardening messages are
commonly cross-posted to.

Because of the common cross-posts, kernel-hardening was already
configured differently from other Openwall mailing lists - it didn't set
the Reply-To header to the list.  Now it'll also differ in its non-use
of [list name] prefix.  I hope we can live with that, even though
personally I found that prefix convenient.

I am posting this primarily in case some of you were filtering by the
[list name] prefix, so that you know why your filters break.  If so,
please filter by the List-ID header instead.

Alexander
