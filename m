Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 3 Jul 2011 22:25:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-ID: <20110703222539.7d872051@lxorguk.ukuu.org.uk>
In-Reply-To: <20110703193808.GA17797@elte.hu>
References: <20110622152514.GA9521@albatros>
	<20110629151436.9be479fb.akpm@linux-foundation.org>
	<20110701112534.GG20990@elte.hu>
	<20110701113533.GA19945@albatros>
	<20110701120453.GA28008@elte.hu>
	<20110701151827.7061dcda@lxorguk.ukuu.org.uk>
	<20110703193808.GA17797@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC] ipc: introduce shm_rmid_forced sysctl
To: Ingo Molnar <mingo@elte.hu>
Cc: Vasiliy Kulikov <segoon@openwall.com>, solar@openwall.com, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, Randy Dunlap <rdunlap@xenotime.net>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge.hallyn@canonical.com>, Daniel Lezcano <daniel.lezcano@free.fr>, Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

> This is a simple extension of the OOM killer being able to ... kill 
> things on OOM, ok? 'to kill' implies 'to break'.

If you do it on the OOM killer then yes that aspect makes sense. The real
problem is that Linux has shipped a broken default for the past ten years.

The number of times I have to explain to industrial and business
customers that Linux doesn't suck but the defaults are stupid is
astounding, and they then wonder why either the authors or their vendor is
a complete and utter moron.

But yes from an OOM perspective killing an unattached SHM segment makes
as much sense as killing anything else.

Alan
