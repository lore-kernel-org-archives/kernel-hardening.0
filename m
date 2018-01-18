Date: Thu, 18 Jan 2018 04:43:02 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <20180118044302.GZ13338@ZenIV.linux.org.uk>
References: <151586748981.5820.14559543798744763404.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+55aFzoAR+MYX+ub0xZ32OsT7WtD5Kru2t6LhwB1buLWPResQ@mail.gmail.com>
 <CA+55aFxsg5+u7bCHj1N8xyyVf7-RMm-5ACNp=ENNrKL78omaow@mail.gmail.com>
 <CAPcyv4hfUx8gLScuNewY3+BWi4YBS_Z9dhvYf1D+WEWDDCShXA@mail.gmail.com>
 <CA+55aFxAFG5czVmCyhYMyHmXLNJ7pcXxWzusjZvLRh_qTGHj6Q@mail.gmail.com>
 <CA+55aFxB01XEEpdPynwYmzQMfTJdJnUrN+ZLqSV_UdnKLBgAZw@mail.gmail.com>
 <1516198646.4184.13.camel@linux.intel.com>
 <20180117185232.GW13338@ZenIV.linux.org.uk>
 <20180118030634.GY13338@ZenIV.linux.org.uk>
 <CA+55aFzKPed+89wz=ajWNpsQ8Kh+AQWx61hwVqqDh7_=h4tecg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzKPed+89wz=ajWNpsQ8Kh+AQWx61hwVqqDh7_=h4tecg@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Subject: [kernel-hardening] Re: [RFC][PATCH] get rid of the use of set_fs() (by way of
 kernel_recvmsg()) in sunrpc
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Network Development <netdev@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 17, 2018 at 07:16:02PM -0800, Linus Torvalds wrote:
> On Wed, Jan 17, 2018 at 7:06 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Similar to the way put_cmsg() handles 32bit case on biarch
> > targets, introduce a flag telling put_cmsg() to treat
> > ->msg_control as kernel pointer, using memcpy instead of
> > copy_to_user().  That allows to avoid the use of kernel_recvmsg()
> > with its set_fs().
> 
> If this is the only case that kernel_recvmsg() exists for, then by all
> means, that patch certainly looks like a good thing.

In -next that's the only remaining caller.  kernel_recvmsg() is
{
        mm_segment_t oldfs = get_fs();
        int result;

        iov_iter_kvec(&msg->msg_iter, READ | ITER_KVEC, vec, num, size);
        set_fs(KERNEL_DS);
        result = sock_recvmsg(sock, msg, flags);
        set_fs(oldfs);
        return result;
}
and 
        iov_iter_kvec(&msg->msg_iter, READ | ITER_KVEC, vec, num, size);
        result = sock_recvmsg(sock, msg, flags);
works just fine for copying the data - that gets handled by copy_to_iter()
and copy_page_to_iter().  Those don't care about set_fs(); the trouble with
sunrpc call site is that we want to fill msg_control-pointed kernel object.
That gets copied by put_cmsg().

	We could turn ->msg_control/->msg_controllen into another
iov_iter, but seeing that we never do scatter-gather for those
IMO that would be a massive overkill.  A flag controlling whether
->msg_control is kernel or userland pointer would do, especially
since we already have a flag for "do we want a native or compat
layout for cmsg" in there.

	That's the only caller we need it for, but that thing looks cheap
enough.  Obviously needs to pass testing, including "is it too ugly to
live as far as Davem is concerned" test, though...
