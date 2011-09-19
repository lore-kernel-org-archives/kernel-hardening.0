Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 19 Sep 2011 13:59:19 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
In-Reply-To: <CAOJsxLE5TMXwAHPks-mvk0EPAHC18fDXf345uZ3umkzNkk7-cQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1109191350030.16739@chino.kir.corp.google.com>
References: <20110918170512.GA2351@albatros> <CAOJsxLF8DBEC9o9pSwa6c6pMg8ByFBdsDnzg22P3ucQcP98uzA@mail.gmail.com> <20110919144657.GA5928@albatros> <CAOJsxLG8gW=BLOptpULsaAEwTravADKbNbXp5e9Wd7xVEfR9AQ@mail.gmail.com> <20110919155718.GB16272@albatros>
 <CAOJsxLGZm+npcR0YgXSE2wLC2iXCtzYyCdTDCt1LN=Z28Rm_UA@mail.gmail.com> <20110919161837.GA2232@albatros> <CAOJsxLE2od0f+6cbL2hA_31CbrqS7AUofx5DT2L9fO_7gxH+PQ@mail.gmail.com> <20110919173539.GA3751@albatros> <CAOJsxLGc0bwCkDtk2PVe7c155a9wVoDAY0CmYDTLg8_bL4qxqg@mail.gmail.com>
 <20110919175856.GA4282@albatros> <CAOJsxLFdNVnW6Faap0UaqZQDQxbA_dEiR2HGdzZtGMJFsVR1WQ@mail.gmail.com> <CA+55aFwnxOvkS12i97kJcWFrH7n591vxq7vBXKzuROiirnYJ0g@mail.gmail.com> <CAOJsxLE5TMXwAHPks-mvk0EPAHC18fDXf345uZ3umkzNkk7-cQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: Re: [kernel-hardening] Re: [RFC PATCH 2/2] mm: restrict access to
 /proc/slabinfo
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Vasiliy Kulikov <segoon@openwall.com>, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, Kees Cook <kees@ubuntu.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Lameter <cl@linux-foundation.org>, Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dan Rosenberg <drosenberg@vsecurity.com>, Theodore Tso <tytso@mit.edu>, Alan Cox <alan@linux.intel.com>, Jesper Juhl <jj@chaosbits.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 19 Sep 2011, Pekka Enberg wrote:

> Well, sure. I was actually planning to rip out SLUB merging completely
> because it makes /proc/slabinfo so useless but never got around doing
> that.

Ripping out cache merging entirely for the benefit of an interface seems 
like overkill, it actually allows the allocator to return cache-hot 
objects that has a small but measurable impact on performance for some 
networking loads.  It would probably be better to increase awareness of 
slabinfo -a and the use of slub_nomerge on the command line when debugging 
issues.  The most complete solution would be to move everything out of 
struct kmem_cache except what is necessary for slabinfo and then point to 
the actual cache data structure that could be shared by merged caches.  
That's not hard to do, but would add an increment to both the alloc and 
free fastpaths and require some surgery throughout all of the slub code to 
understand the new data structures and that would be a pretty big patch.
