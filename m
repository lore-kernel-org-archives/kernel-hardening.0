MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAPcyv4jm7S+8ezntAo2LeOGshPdpt616RNOambOL6espzBYUvg@mail.gmail.com>
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151571802258.27429.932636277047687877.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180112175109.yoz4jaaipztdj34k@treble> <CAPcyv4heW2FqxpCa0NZeTsa5V7pgpzA-MdHYJA+y9C5L2GTP9w@mail.gmail.com>
 <20180112185815.meiwnnb5vmnrbsdt@treble> <CAPcyv4jm7S+8ezntAo2LeOGshPdpt616RNOambOL6espzBYUvg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 12 Jan 2018 12:01:04 -0800
Message-ID: <CA+55aFwhU110nyGerakLf-LHgfZDmJ6snTyQJqAHRbnxQoqbHg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 07/19] x86: introduce __uaccess_begin_nospec and ASM_IFENCE
To: Dan Williams <dan.j.williams@intel.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 12, 2018 at 11:26 AM, Dan Williams <dan.j.williams@intel.com> wrote:
>
> By the time we get to de-reference uptr we know it is not pointing at
> kernel memory, because access_ok would have failed and the cpu would
> have waited for that failure result before doing anything else.

I'm not actually convinced that's right in the original patches,
exactly because of the issue that Josh pointed out: even if there is a
comparison inside access_ok() that will be properly serialized, then
that comparison can (and sometimes does) just cause a truth value to
be generated, and then there  might be *another* comparison of that
return value after the lfence. And while the return value is table,
the conditional branch on that comparison isn't.

The new model of just doing it together with the STAC should be fine, though.

I do think that it would be a good idea to very expressly document the
fact that it's not that the user access itself is unsafe. I do agree
that things like "get_user()" want to be protected, but not because of
any direct bugs or problems with get_user() and friends, but simply
because get_user() is an excellent source of a pointer that is
obviously controlled from a potentially attacking user space. So it's
a prime candidate for then finding _subsequent_ accesses that can then
be used to perturb the cache.

                 Linus
