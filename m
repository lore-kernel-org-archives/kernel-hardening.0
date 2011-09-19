Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 19 Sep 2011 22:55:18 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110919185518.GA5563@albatros>
References: <20110919144657.GA5928@albatros>
 <CAOJsxLG8gW=BLOptpULsaAEwTravADKbNbXp5e9Wd7xVEfR9AQ@mail.gmail.com>
 <20110919155718.GB16272@albatros>
 <CAOJsxLGZm+npcR0YgXSE2wLC2iXCtzYyCdTDCt1LN=Z28Rm_UA@mail.gmail.com>
 <20110919161837.GA2232@albatros>
 <CAOJsxLE2od0f+6cbL2hA_31CbrqS7AUofx5DT2L9fO_7gxH+PQ@mail.gmail.com>
 <20110919173539.GA3751@albatros>
 <CAOJsxLGc0bwCkDtk2PVe7c155a9wVoDAY0CmYDTLg8_bL4qxqg@mail.gmail.com>
 <20110919175856.GA4282@albatros>
 <CAOJsxLFdNVnW6Faap0UaqZQDQxbA_dEiR2HGdzZtGMJFsVR1WQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLFdNVnW6Faap0UaqZQDQxbA_dEiR2HGdzZtGMJFsVR1WQ@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [RFC PATCH 2/2] mm: restrict access to
 /proc/slabinfo
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, Kees Cook <kees@ubuntu.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Lameter <cl@linux-foundation.org>, Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dan Rosenberg <drosenberg@vsecurity.com>, Theodore Tso <tytso@mit.edu>, Alan Cox <alan@linux.intel.com>, Jesper Juhl <jj@chaosbits.net>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Sep 19, 2011 at 21:46 +0300, Pekka Enberg wrote:
> On Mon, Sep 19, 2011 at 8:58 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> >> Isn't this
> >> much stronger protection especially if you combine that with /proc/slabinfo
> >> restriction?
> >
> > I don't see any reason to change allocators if we close slabinfo.
> 
> OK, so what about /proc/meminfo, sysfs, 'perf kmem', and other kernel interfaces
> through which you can get direct or indirect information about kernel memory
> allocations?

Oh, we also have perf...  Given these are separate interfaces, I think
slab oriented restriction makes more sense.

So, now we have:

/proc/slabinfo
/sys/kernel/slab
/proc/meminfo
'perf kmem' - not sure what specific files should be guarded


Is there another way to get directly or indirectly the information about
slabs?


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
