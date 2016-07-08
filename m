Reply-To: kernel-hardening@lists.openwall.com
From: Michael Ellerman <mpe@ellerman.id.au>
In-Reply-To: <CAGXu5jLyBfqXJKxohHiZgztRVrFyqwbta1W_Dw6KyyGM3LzshQ@mail.gmail.com>
References: <1467843928-29351-1-git-send-email-keescook@chromium.org> <1467843928-29351-2-git-send-email-keescook@chromium.org> <3418914.byvl8Wuxlf@wuerfel> <CAGXu5jLyBfqXJKxohHiZgztRVrFyqwbta1W_Dw6KyyGM3LzshQ@mail.gmail.com>
Date: Fri, 08 Jul 2016 15:34:19 +1000
Message-ID: <8760sgofqc.fsf@@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH 1/9] mm: Hardened usercopy
To: Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>
Cc: Jan Kara <jack@suse.cz>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Linux-MM <linux-mm@kvack.org>, sparclinux <sparclinux@vger.kernel.org>, linux-ia64@vger.kernel.org, Christoph Lameter <cl@linux.com>, Andrea Arcangeli <aarcange@redhat.com>, "x86@kernel.org" <x86@kernel.org>, Russell King <linux@armlinux.org.uk>, Dmitry Vyukov <dvyukov@google.com>, David Rientjes <rientjes@google.com>, PaX Team <pageexec@freemail.hu>, Mathias Krause <minipli@googlemail.com>, linux-arch <linux-arch@vger.kernel.org>, Rik van Riel <riel@redhat.com>, Brad Spengler <spender@grsecurity.net>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Laura Abbott <labbott@fedoraproject.org>, Tony Luck <tony.luck@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, LKML <linux-kernel@vger.ker>nel.org, Fenghua Yu <fenghua.yu@intel.com>, Pekka Enberg <penberg@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "David S. Miller" <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

Kees Cook <keescook@chromium.org> writes:

> On Thu, Jul 7, 2016 at 4:01 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Wednesday, July 6, 2016 3:25:20 PM CEST Kees Cook wrote:
>>> +
>>> +     /* Allow kernel rodata region (if not marked as Reserved). */
>>> +     if (ptr >= (const void *)__start_rodata &&
>>> +         end <= (const void *)__end_rodata)
>>> +             return NULL;
>>
>> Should we explicitly forbid writing to rodata, or is it enough to
>> rely on page protection here?
>
> Hm, interesting. That's a very small check to add. My knee-jerk is to
> just leave it up to page protection. I'm on the fence. :)

There are platforms that don't have page protection, so it would be nice
if they could at least opt-in to checking for it here.

cheers
