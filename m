Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAKv+Gu_7AdRk7O-Mt8oS=t6prJY56=nS5CS1stgfqHzJ--YD9Q@mail.gmail.com>
References: <CAKv+Gu_7AdRk7O-Mt8oS=t6prJY56=nS5CS1stgfqHzJ--YD9Q@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 5 Oct 2016 13:30:48 -0700
Message-ID: <CAGXu5j+FjPie_mfVhyPa77BrOf+XkAfkZgc+T3RNjecTLH6w2Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] initcall randomization
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: Laura Abbott <labbott@fedoraproject.org>, Mark Rutland <mark.rutland@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 5, 2016 at 10:09 AM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> Did anyone ever look into whether there is anything to gain in terms
> of hardening from randomizing the order initcalls are issued at each
> level? I know entropy is hard to come by at this stage, but on recent
> UEFI systems, this is something we could potentially solve
> generically. (It may uncover some breakage as well, but only hidden
> breakage that could already surface at any time due to linker changes,
> so I think this could serve as a diagnostic option as well)

It could be a nice addition to CONFIG_RANDOMIZE_MEMORY which already
tries to address the "predictable memory locations at every boot"
problem by randomizing the offset of the kernel memory mappings on
x86_64. Could this be done on arm64 too?

> Since boot time mappings are often performed in initcalls, this could
> potentially reduce the predictability of the layout of the virtual
> kernel space. But before I start experimenting with this, I thought
> I'd ask if anyone has ever looked into this.

As Greg mentioned, I bet there are some implicit ordering (and
explicit) that would need solving.

-Kees

-- 
Kees Cook
Nexus Security
