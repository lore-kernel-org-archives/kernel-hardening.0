Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160701145920.GF4593@pd.tnic>
References: <cover.1466974736.git.luto@kernel.org> <fa7bc42def35d37f8237d8f9b2f1b1e05eb885b8.1466974736.git.luto@kernel.org>
 <20160701145920.GF4593@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 1 Jul 2016 09:30:12 -0700
Message-ID: <CALCETrUmZbL3CquXPXftg3nve0Bk22qmPZSoYBvYnUeJZPenEA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 09/29] fork: Add generic vmalloced stack support
To: Borislav Petkov <bp@alien8.de>
Cc: Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Oleg Nesterov <oleg@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jul 1, 2016 at 7:59 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Sun, Jun 26, 2016 at 02:55:31PM -0700, Andy Lutomirski wrote:
>> If CONFIG_VMAP_STACK is selected, kernel stacks are allocated with
>> vmalloc_node.
>>

All done.
