MIME-Version: 1.0
In-Reply-To: <20181026092609.GB3159@worktop.c.hoisthospitality.com>
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
 <20181023213504.28905-11-igor.stoppa@huawei.com> <20181026092609.GB3159@worktop.c.hoisthospitality.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 26 Oct 2018 11:46:28 +0100
Message-ID: <CAGXu5jKCs01jvtvpEFS7R8qCR-5iRqK11kJxLJY99NicGWc4aQ@mail.gmail.com>
Subject: Re: [PATCH 10/17] prmem: documentation
Content-Type: text/plain; charset="UTF-8"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Igor Stoppa <igor.stoppa@gmail.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Oct 26, 2018 at 10:26 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> I still don't really understand the whole write-rare thing; how does it
> really help? If we can write in kernel memory, we can write to
> page-tables too.

I can speak to the general goal. The specific implementation here may
not fit all the needs, but it's a good starting point for discussion.

One aspect of hardening the kernel against attack is reducing the
internal attack surface. Not all flaws are created equal, so there is
variation in what limitations an attacker may have when exploiting
flaws (not many flaws end up being a fully controlled "write anything,
anywhere, at any time"). By making the more sensitive data structures
of the kernel read-only, we reduce the risk of an attacker finding a
path to manipulating the kernel's behavior in a significant way.

Examples of typical sensitive targets are function pointers, security
policy, and page tables. Having these "read only at rest" makes them
much harder to control by an attacker using memory integrity flaws. We
already have the .rodata section for "const" things. Those are
trivially read-only. For example there is a long history of making
sure that function pointer tables are marked "const". However, some
things need to stay writable. Some of those in .data aren't changed
after __init, so we added the __ro_after_init which made them
read-only for the life of the system after __init. However, we're
still left with a lot of sensitive structures either in .data or
dynamically allocated, that need a way to be made read-only for most
of the time, but get written to during very specific times.

The "write rarely" name itself may not sufficiently describe what is
wanted either (I'll take the blame for the inaccurate name), so I'm
open to new ideas there. The implementation requirements for the
"sensitive data read-only at rest" feature are rather tricky:

- allow writes only from specific places in the kernel
- keep those locations inline to avoid making them trivial ROP targets
- keep the writeability window open only to a single uninterruptable CPU
- fast enough to deal with page table updates

The proposal I made a while back only covered .data things (and used
x86-specific features). Igor's proposal builds on this by including a
way to do this with dynamic allocation too, which greatly expands the
scope of structures that can be protected. Given that the x86-only
method of write-window creation was firmly rejected, this is a new
proposal for how to do it (vmap window). Using switch_mm() has also
been suggested, etc.

We need to find a good way to do the write-windowing that works well
for static and dynamic structures _and_ for the page tables... this
continues to be tricky.

Making it resilient against ROP-style targets makes it difficult to
deal with certain data structures (like list manipulation). In my
earlier RFC, I tried to provide enough examples of where this could
get used to let people see some of the complexity[1]. Igor's series
expands this to even more examples using dynamic allocation.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/log/?h=kspp/write-rarely

-- 
Kees Cook
