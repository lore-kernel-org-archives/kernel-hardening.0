Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 9 Nov 2011 22:49:54 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-ID: <20111109224954.3864c426@lxorguk.ukuu.org.uk>
In-Reply-To: <20111109222708.GA28509@kroah.com>
References: <20111108121412.GA14450@albatros>
	<4EBA0A32.3000607@kernel.sg>
	<20111109161123.GC2557@kroah.com>
	<20111109170946.GA30780@albatros>
	<20111109222708.GA28509@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: kernel: multiple flaws allowing to sniff keystrokes timings
To: Greg KH <greg@kroah.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>, Eugene Teo <eugeneteo@kernel.sg>, security@kernel.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

> > 1) show zero fields to unprivileged users (for /proc/interrupts and
> > /proc/stat it is CAP_SYS_ADMIN, for /proc/$PID/{stat,sched,schedstat} it
> > is ptrace_may_access(), for ttys it is uid check) and real values for
> > privileged.  The same technique is used in /proc/$PID/sched for eip/esp
> > values.
> 
> That makes sense to a point, users will wonder why they aren't seeing
> interrupts anymore, which is a valuable debug tool.

For the interrupts case you don't want show misleading data. It really
has only one use so it's better to change the permissions in the
hardening case. Something distros can already do

> All that is leaking here is the number of keystrokes at most, right?

If even that on USB.

> If we provide a "good" library function for keyboard password usage, we
> could get other applications to use it, but yes, it is a tough issue :(

You can also create noise by rounding off the values a bit. I don't think
it would need much rounding to keep useful data and fuzz, and the
rounding factor can be stuck in sysfs and default to 0.

Alan
