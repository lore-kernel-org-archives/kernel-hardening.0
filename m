MIME-Version: 1.0
In-Reply-To: <CA+55aFwu2L+YK-DtfCbtsZL+DopgksfnpazA8ja=FW9_4MNeyg@mail.gmail.com>
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151571802814.27429.12886210130791656117.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+55aFwu2L+YK-DtfCbtsZL+DopgksfnpazA8ja=FW9_4MNeyg@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 Jan 2018 17:14:29 -0800
Message-ID: <CAPcyv4jVtGCmCdpE_coHYYhCqArFozsq=oX+AdtH2Ems7biPFg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 08/19] x86: use __uaccess_begin_nospec and ASM_IFENCE
 in get_user paths
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 11, 2018 at 5:11 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> This patch doesn't affect arch/x86/lib/getuser.S, which I find surprising.
>
> Of all the user access functions, I actually think that get_user() is
> the one most likely to have the result then used speculatively as an
> index (the required second dependent read to actually leak data).
>
> I do *not* see people doing "copy_from_user()" and then somehow using
> the thing as an index to another array. I mean, it can happen (copy a
> structure, use a member in that structure), but it doesn't seem to be
> the most likely thing.
>
> The most likely thing would seem to be some random ioctl() do a
> "get_user()" to get an index, and then using that index. That would
> seem to be one of the easier ways to perhaps get that kind of kernel
> spectre attack.
>
> Adding the ASM_IFENCE to __get_user_X() in arch/x86/lib/getuser.S
> would seem to go naturally together with the copy_user_64.S changes in
> this patch.
>
> Is there some reason __get_user_X() was overlooked? Those are _the_
> most common user accessor functions that do the address limit
> checking.

Oversight, I was focused on the uaccess_begin conversions. Yes, let me
go add ASM_IFENCE after the ASM_STAC in those paths.
