MIME-Version: 1.0
References: <12356C813DFF6F479B608F81178A5615869EB0@BGSMSX101.gar.corp.intel.com>
In-Reply-To: <12356C813DFF6F479B608F81178A5615869EB0@BGSMSX101.gar.corp.intel.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 18 Jun 2019 13:35:51 +0200
Message-ID: <CAG48ez1fGhPmARDo9F_h=aX5G4eS8ti76678ynrEF0=mqXH02Q@mail.gmail.com>
Subject: Re: Get involved
Content-Type: text/plain; charset="UTF-8"
To: "Gote, Nitin R" <nitin.r.gote@intel.com>
Cc: Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Shyam Saini <mayhs11saini@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 18, 2019 at 1:20 PM Gote, Nitin R <nitin.r.gote@intel.com> wrote:
>
> Hi Kees,
>
> I would like to be involved on upstream on security related topics.
> I'm planning to work on below items from KSPP to do list:
>         1. deprecate strcpy() in favor of strscpy().
>         2. deprecate strlcpy() in favor of strscpy().
>         3. deprecate strncpy() in favor of strscpy(), strscpy_pad(), or str2mem_pad().
>
> I'm thinking of following approach for above items :
>
> Approach 1 : Do we need to blindly replace strcpy() or strlcpy() or strncpy() with strscpy() in entire linux kernel tree ?
>                  (This approach is time consuming as lots of changes need to do in single patch or multiple patch)

Linus wrote at <https://lore.kernel.org/lkml/CA+55aFwHCPnPf_xs6GJu37UBvg_BSiFPH2uQps7qNNFV8Ej-SA@mail.gmail.com/>:

| I wrote a longish merge message about why - but it boils down to me
| hating the mindless trivial conversion patches. Which were not in the
| pull request, but I want to make it clear to everybody that I have
| absolutely zero interest in seeing such patches. I want to encourage
| judicious use of strscpy() in new code, or in code that gets modified
| because it is buggy or is updated for other reasons (and thus thought
| about and tested), but I am *not* going to accept patches that do mass
| conversions of strlcpy or strncpy to the new interface.

>From the "longish merge message" at
<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=30c44659f4a3e7e1f9f47e895591b4b40bf62671>:

| Every time we introduce a new-and-improved interface, people start doing
| these interminable series of trivial conversion patches.
|
| And every time that happens, somebody does some silly mistake, and the
| conversion patch to the improved interface actually makes things worse.
| Because the patch is mindnumbing and trivial, nobody has the attention
| span to look at it carefully, and it's usually done over large swatches
| of source code which means that not every conversion gets tested.
|
| So I'm pulling the strscpy() support because it *is* a better interface.
| But I will refuse to pull mindless conversion patches.  Use this in
| places where it makes sense, but don't do trivial patches to fix things
| that aren't actually known to be broken.

Unless Linus changed his mind about that in the years since then, you
probably don't want to spend your time writing a patch Linus doesn't
want.

> Approach 2 : Do we need to implement script or some mechanism which checks for functions likes strcpy(), strlcpy() or strncpy() and
>                  throw some deprecate error, if these functions found and suggest to use strscpy() ?

It would probably make sense to add warnings for strlcpy() and
strncpy() in scripts/checkpatch.pl.
