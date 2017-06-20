MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1497931790.11009.1.camel@gmail.com>
References: <1497915397-93805-1-git-send-email-keescook@chromium.org>
 <1497915397-93805-24-git-send-email-keescook@chromium.org> <1497931790.11009.1.camel@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 20 Jun 2017 15:51:18 -0700
Message-ID: <CAGXu5jJckTkYqWRv5AUv=Ks8_477xuZn=RB+0tiXC=sGDe1QEA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH 23/23] mm: Allow slab_nomerge to be set
 at build time
To: Daniel Micay <danielmicay@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, David Windsor <dave@nullcore.net>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 19, 2017 at 9:09 PM, Daniel Micay <danielmicay@gmail.com> wrote:
> On Mon, 2017-06-19 at 16:36 -0700, Kees Cook wrote:
>> Some hardened environments want to build kernels with slab_nomerge
>> already set (so that they do not depend on remembering to set the
>> kernel
>> command line option). This is desired to reduce the risk of kernel
>> heap
>> overflows being able to overwrite objects from merged caches,
>> increasing
>> the difficulty of these attacks. By keeping caches unmerged, these
>> kinds
>> of exploits can usually only damage objects in the same cache (though
>> the
>> risk to metadata exploitation is unchanged).
>
> It also further fragments the ability to influence slab cache layout,
> i.e. primitives to do things like filling up slabs to set things up for
> an exploit might not be able to deal with the target slabs anymore. It
> doesn't need to be mentioned but it's something to think about too. In
> theory, disabling merging can make it *easier* to get the right layout
> too if there was some annoyance that's now split away. It's definitely a
> lot more good than bad for security though, but allocator changes have
> subtle impact on exploitation. This can make caches more deterministic.

Good point about changes to heap grooming; I'll adjust the commit log.

-Kees

-- 
Kees Cook
Pixel Security
