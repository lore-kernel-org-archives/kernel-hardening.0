Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 19 Sep 2011 21:35:39 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110919173539.GA3751@albatros>
References: <20110910164134.GA2442@albatros>
 <20110914192744.GC4529@outflux.net>
 <20110918170512.GA2351@albatros>
 <CAOJsxLF8DBEC9o9pSwa6c6pMg8ByFBdsDnzg22P3ucQcP98uzA@mail.gmail.com>
 <20110919144657.GA5928@albatros>
 <CAOJsxLG8gW=BLOptpULsaAEwTravADKbNbXp5e9Wd7xVEfR9AQ@mail.gmail.com>
 <20110919155718.GB16272@albatros>
 <CAOJsxLGZm+npcR0YgXSE2wLC2iXCtzYyCdTDCt1LN=Z28Rm_UA@mail.gmail.com>
 <20110919161837.GA2232@albatros>
 <CAOJsxLE2od0f+6cbL2hA_31CbrqS7AUofx5DT2L9fO_7gxH+PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLE2od0f+6cbL2hA_31CbrqS7AUofx5DT2L9fO_7gxH+PQ@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [RFC PATCH 2/2] mm: restrict access to
 /proc/slabinfo
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, Kees Cook <kees@ubuntu.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Lameter <cl@linux-foundation.org>, Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dan Rosenberg <drosenberg@vsecurity.com>, Theodore Tso <tytso@mit.edu>, Alan Cox <alan@linux.intel.com>, Jesper Juhl <jj@chaosbits.net>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Sep 19, 2011 at 20:31 +0300, Pekka Enberg wrote:
> On Mon, Sep 19, 2011 at 7:18 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> >> However, if the encryptfs and infoleaks really are serious enough to
> >> hide /proc/slabinfo, I think you should consider switching over to
> >> kmalloc() instead of kmem_cache_alloc() to make sure nobody can
> >> gain access to the information.
> >
> > kmalloc() is still visible in slabinfo as kmalloc-128 or so.
> 
> Yes, but there's no way for users to know where the allocations came from
> if you mix them up with other kmalloc-128 call-sites. That way the number
> of private files will stay private to the user, no? Doesn't that give you even
> better protection against the infoleak?

No, what it gives us is an obscurity, not a protection.  I'm sure it
highly depends on the specific situation whether an attacker is able to
identify whether the call is from e.g. ecryptfs or from VFS.  Also the
correlation between the number in slabinfo and the real private actions
still exists.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
