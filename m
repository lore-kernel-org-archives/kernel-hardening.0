Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAEXv5_jnutg89zQLyLCupKf0AOZ=ubdgbJy7AgeeN=7yQicW0A@mail.gmail.com>
References: <CAEXv5_jnutg89zQLyLCupKf0AOZ=ubdgbJy7AgeeN=7yQicW0A@mail.gmail.com>
Date: Tue, 24 Nov 2015 12:04:18 -0800
Message-ID: <CAGXu5jLqy1UchipmcgsUrXiWP0zfwjGAgfxcKUYkbQ9a_e2V_g@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] status: PAX_REFCOUNT
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 24, 2015 at 11:37 AM, David Windsor <dave@0x4141.net> wrote:
> I'm currently in the process of splitting PAX_REFCOUNT.
>
> It looks to touch a massive number of files.  Many of the modifications
> occur in drivers:
>
> dave@strontium:~/src/linux-grsec-4.2$ grep -ril "atomic.*unchecked" | wc -l
> 402
> dave@strontium:~/src/linux-grsec-4.2$ grep -ril "atomic.*unchecked" drivers/
> | wc -l
> 158

Interesting there are so many intentional overflows. I think the
hardest part for getting this series upstream will be sticking to our
principle of not needing a developer to "opt in" to the protection. I
still think this is a compelling reason to keep it as-is, but it
should be an interesting discussion. :)

> As it stands, I'm trying to come up with a good way to split the patches.
> I'm currently going with a scheme of creating separate patches per kernel
> subsystem, further separating by component type (filesystems, drivers,
> etc.).  For instance, for patches touching fs/, I've created a patch for
> filesystem-independent changes, then separate patches for each individual
> filesystem's changes.  Extrapolated over the entire kernel, I estimate this
> strategy will produce approximately between 50 and 75 patches.

That'll be a lot of patches. I wonder if we could break it up by
top-level maintainer? i.e. everything in drivers would go in one
patch, etc?

> I'm moving my way through the tree and will hopefully have an RFC submission
> soon.

Great! Are you working on this full-time? (If not, would potential CII
funding help at all?)

I'll send an lkdtm patch that'll twiddle the atomic type, so you have
something to validate it with.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
