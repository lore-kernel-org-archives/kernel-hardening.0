Date: Wed, 17 Jan 2018 18:52:32 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <20180117185232.GW13338@ZenIV.linux.org.uk>
References: <151586744180.5820.13215059696964205856.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151586748981.5820.14559543798744763404.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+55aFzoAR+MYX+ub0xZ32OsT7WtD5Kru2t6LhwB1buLWPResQ@mail.gmail.com>
 <CA+55aFxsg5+u7bCHj1N8xyyVf7-RMm-5ACNp=ENNrKL78omaow@mail.gmail.com>
 <CAPcyv4hfUx8gLScuNewY3+BWi4YBS_Z9dhvYf1D+WEWDDCShXA@mail.gmail.com>
 <CA+55aFxAFG5czVmCyhYMyHmXLNJ7pcXxWzusjZvLRh_qTGHj6Q@mail.gmail.com>
 <CA+55aFxB01XEEpdPynwYmzQMfTJdJnUrN+ZLqSV_UdnKLBgAZw@mail.gmail.com>
 <1516198646.4184.13.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1516198646.4184.13.camel@linux.intel.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Subject: [kernel-hardening] Re: [PATCH v3 8/9] x86: use __uaccess_begin_nospec and ASM_IFENCE in
 get_user paths
To: Alan Cox <alan@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 17, 2018 at 02:17:26PM +0000, Alan Cox wrote:
> On Tue, 2018-01-16 at 14:41 -0800, Linus Torvalds wrote:
> > 
> > 
> > On Jan 16, 2018 14:23, "Dan Williams" <dan.j.williams@intel.com>
> > wrote:
> > > That said, for get_user specifically, can we do something even
> > > cheaper. Dave H. reminds me that any valid user pointer that gets
> > > past
> > > the address limit check will have the high bit clear. So instead of
> > > calculating a mask, just unconditionally clear the high bit. It
> > > seems
> > > worse case userspace can speculatively leak something that's
> > > already
> > > in its address space.
> > 
> > That's not at all true.
> > 
> > The address may be a kernel address. That's the whole point of
> > 'set_fs()'.
> 
> Can we kill off the remaining users of set_fs() ?

Not easily.  They tend to come in pairs (the usual pattern is get_fs(),
save the result, set_fs(something), do work, set_fs(saved)), and
counting each such area as single instance we have (in my tree right
now) 121 locations.  Some could be killed (and will eventually be -
the number of set_fs()/access_ok()/__{get,put}_user()/__copy_...()
call sites had been seriously decreasing during the last couple of
years), but some are really hard to kill off.

How, for example, would you deal with this one:

/*
 * Receive a datagram from a UDP socket.
 */
static int svc_udp_recvfrom(struct svc_rqst *rqstp)
{
        struct svc_sock *svsk =
                container_of(rqstp->rq_xprt, struct svc_sock, sk_xprt);
        struct svc_serv *serv = svsk->sk_xprt.xpt_server;
        struct sk_buff  *skb;
        union {
                struct cmsghdr  hdr;
                long            all[SVC_PKTINFO_SPACE / sizeof(long)];
        } buffer;
        struct cmsghdr *cmh = &buffer.hdr;
        struct msghdr msg = {
                .msg_name = svc_addr(rqstp),
                .msg_control = cmh,
                .msg_controllen = sizeof(buffer),
                .msg_flags = MSG_DONTWAIT,
        };
...
        err = kernel_recvmsg(svsk->sk_sock, &msg, NULL,
                             0, 0, MSG_PEEK | MSG_DONTWAIT);

With kernel_recvmsg() (and in my tree the above is its last surviving caller)
being

int kernel_recvmsg(struct socket *sock, struct msghdr *msg,
                   struct kvec *vec, size_t num, size_t size, int flags)
{
        mm_segment_t oldfs = get_fs();
        int result;

        iov_iter_kvec(&msg->msg_iter, READ | ITER_KVEC, vec, num, size);
        set_fs(KERNEL_DS);
        result = sock_recvmsg(sock, msg, flags);
        set_fs(oldfs);
        return result;
}
EXPORT_SYMBOL(kernel_recvmsg);

We are asking for recvmsg() with zero data length; what we really want is
->msg_control.  And _that_ is why we need that set_fs() - we want the damn
thing to go into local variable.

But note that filling ->msg_control will happen in put_cmsg(), called
from ip_cmsg_recv_pktinfo(), called from ip_cmsg_recv_offset(),
called from udp_recvmsg(), called from sock_recvmsg_nosec(), called
from sock_recvmsg().  Or in another path in case of IPv6.
Sure, we can arrange for propagation of that all way down those
call chains.  My preference would be to try and mark that (one and
only) case in ->msg_flags, so that put_cmsg() would be able to
check.  ___sys_recvmsg() sets that as
        msg_sys->msg_flags = flags & (MSG_CMSG_CLOEXEC|MSG_CMSG_COMPAT);
so we ought to be free to use any bit other than those two.  Since
put_cmsg() already checks ->msg_flags, that shouldn't put too much
overhead.  But then we'll need to do something to prevent speculative
execution straying down that way, won't we?  I'm not saying it can't
be done, but quite a few of the remaining call sites will take
serious work.

	Incidentally, what about copy_to_iter() and friends?  They
check iov_iter flavour and go either into the "copy to kernel buffer"
or "copy to userland" paths.  Do we need to deal with mispredictions
there?  We are calling a bunch of those on read()...
