Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sat, 2 Jul 2011 21:46:08 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110702174608.GA2490@albatros>
References: <20110626183321.GA3867@albatros>
 <20110629182505.GC14873@openwall.com>
 <20110629183728.GA8163@albatros>
 <20110629194339.GA15379@openwall.com>
 <20110630160345.GA15258@albatros>
 <20110702172159.GE26232@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110702172159.GE26232@openwall.com>
Subject: Re: [kernel-hardening] overview of PaX features
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Sat, Jul 02, 2011 at 21:21 +0400, Solar Designer wrote:
> Oh, of course the kernel itself also put a signal handler return
> trampoline on the stack.

As the kernel actually use NX for the stack on amd64 and on x86-32 with
PAE support, the signal handler is already rewritten to respect
the nonexecutable stack.


> You may want to check the code in linux-2.2.12-ow6.diff.  It turned out
> to be insufficient to cover some newer gcc versions, so it was enhanced
> in later 2.2.x-ow versions.
> 
> http://download.openwall.net/pub/patches/linux/v2.2/historical/

I'll take a look at it, thanks.


> That said, I don't have strong feelings one way or the other.  Feel free
> to use the stricter code from PaX if you like.  You can also ask for PaX
> Team's advice on this.

He told me that the PaX' version is based on the actual gcc code, so it
should be sufficient ;)


> > Btw, there is a tool to change executable stack settings per binary,
> > written by Jakub Jelinek (Red Hat):
> > 
> > http://linux.die.net/man/8/execstack
> 
> I think it makes sense for us to get it into Owl.

Also there is a paxtest utility, it shows some information related to
noexec, ASLR and NULL presence in some libc functions:

http://grsecurity.net/~spender/paxtest-0.9.9.tgz


Anyway, I expect to work on this patch just after PAX_USERCOPY
discussion with upstream (and trying to push it, of course!).

Thanks,

-- 
Vasiliy
