Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 20 Dec 2016 11:27:13 +0100 (CET)
From: Jiri Kosina <jikos@kernel.org>
In-Reply-To: <20161220092734.GA12200@kroah.com>
Message-ID: <alpine.LSU.2.20.1612201117220.19203@cbobk.fhfr.pm>
References: <20161214185000.GA3930@kroah.com> <87k2b0wus6.fsf@notabene.neil.brown.name> <20161216124913.GB31485@kroah.com> <alpine.LRH.2.00.1612191428060.15543@gjva.wvxbf.pm> <20161220092734.GA12200@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [RFC 0/4] make call_usermodehelper a bit more "safe"
To: Greg KH <gregkh@linuxfoundation.org>
Cc: NeilBrown <neilb@suse.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 20 Dec 2016, Greg KH wrote:

> > Sorry, I really don't get this.
> > 
> > If kernel memory can be easily changed (which is assumed here), why bother 
> > with all this? I'll just set current->uid to 0 and be done.
> 
> Because you don't want your current process to uid 0, you want some
> other program to run as root.  It's quite common for exploits to work
> this way, take a look at how the p0wn-to-own "contests" usually break
> out of sandboxed systems like browsers.

So what kind of sandbox are we talking about here?

namespaces-based sanbox? If you have direct access to kernel memory, you 
can just assign whatever context you want to task_struct's fs struct, and 
you are out of a sandbox.

chroot-based sandbox? Exactly the same argument (you just reset fs->root 
in task_struct).

I stay totally unconvinced that such kind of countermeasure brings any 
value whatsoever. Could you please bring up a particular usecase, where 
you have complete control over kernel memory, and still the only possible 
exploit factor is redirecting usermodhelper? It feels like rather random 
shot into darkness.

Thanks,

-- 
Jiri Kosina
SUSE Labs
